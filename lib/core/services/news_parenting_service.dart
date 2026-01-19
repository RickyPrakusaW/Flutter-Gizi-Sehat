import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/news_article_model.dart';

class NewsParentingService {
  Future<List<NewsArticle>> getNews() async {
    final String response =
        await rootBundle.loadString('assets/data/NewsParentingData.json');
    final data = json.decode(response);
    final List<dynamic> articlesJson = data['articles'];
    return articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
  }
}
