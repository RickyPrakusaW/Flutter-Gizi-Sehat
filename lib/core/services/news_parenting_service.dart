import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/news_article_model.dart';

class NewsParentingService {
  Future<List<NewsArticle>> getNews({int page = 1, int limit = 10}) async {
    final String response =
        await rootBundle.loadString('assets/data/NewsParentingData.json');
    final data = json.decode(response);
    final List<dynamic> articlesJson = data['articles'];

    // Simulate pagination for local JSON
    final startIndex = (page - 1) * limit;
    if (startIndex >= articlesJson.length) return [];

    final endIndex = (startIndex + limit).clamp(0, articlesJson.length);
    final paginatedList = articlesJson.sublist(startIndex, endIndex);

    return paginatedList.map((json) => NewsArticle.fromJson(json)).toList();
  }
}
