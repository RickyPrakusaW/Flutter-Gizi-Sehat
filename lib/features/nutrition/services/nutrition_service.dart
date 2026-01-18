import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:gizi_sehat_mobile_app/features/nutrition/models/who_standard_model.dart';

class NutritionService {
  List<WhoStandard> _boysHeightStandards = [];
  List<WhoStandard> _girlsHeightStandards = [];

  Future<void> loadWhoStandards() async {
    final String boysString = await rootBundle.loadString(
      'assets/data/who_boys_height.json',
    );
    final List<dynamic> boysJson = jsonDecode(boysString);
    _boysHeightStandards = boysJson
        .map((e) => WhoStandard.fromJson(e))
        .toList();

    final String girlsString = await rootBundle.loadString(
      'assets/data/who_girls_height.json',
    );
    final List<dynamic> girlsJson = jsonDecode(girlsString);
    _girlsHeightStandards = girlsJson
        .map((e) => WhoStandard.fromJson(e))
        .toList();
  }

  // Calculate Z-Score using LMS method
  double calculateZScore(
    double value,
    int ageInMonths,
    bool isMale,
    String indicator,
  ) {
    // Determine which list to use (currently only supporting height-for-age)
    // In a full app, 'indicator' ('height', 'weight') would choose the list
    List<WhoStandard> standards = isMale
        ? _boysHeightStandards
        : _girlsHeightStandards;

    // Find the standard for the child's age
    WhoStandard? standard;
    try {
      standard = standards.firstWhere((s) => s.month == ageInMonths);
    } catch (e) {
      // Fallback: finding closest
      if (standards.isNotEmpty) {
        // Find closest without mutating the original list
        standard = standards.reduce((curr, next) {
          return (curr.month - ageInMonths).abs() <
                  (next.month - ageInMonths).abs()
              ? curr
              : next;
        });
      }
    }

    if (standard == null) return 0.0;

    // Formula: Z = ((X/M)^L - 1) / (L*S)
    double l = standard.l;
    double m = standard.m;
    double s = standard.s;

    if (l == 0) {
      // Special case for L=0, Z = ln(X/M)/S
      return log(value / m) / s;
    } else {
      return (pow((value / m), l) - 1) / (l * s);
    }
  }

  String classifyHeightStatus(double zScore) {
    if (zScore < -3) {
      return 'Sangat Pendek (Severely Stunted)';
    } else if (zScore < -2) {
      return 'Pendek (Stunted)';
    } else if (zScore <= 3) {
      return 'Normal';
    } else {
      return 'Tinggi';
    }
  }

  List<WhoStandard> getGrowthChartData(bool isMale) {
    return isMale ? _boysHeightStandards : _girlsHeightStandards;
  }
}
