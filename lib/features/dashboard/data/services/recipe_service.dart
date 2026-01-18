import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/recipe_model.dart';

class RecipeResponse {
  final List<RecipeModel> results;
  final int totalResults;

  RecipeResponse({required this.results, required this.totalResults});
}

class RecipeService {
  List<RecipeModel>? _cachedRecipes;

  // Load from local JSON assets
  Future<void> _loadRecipesFromAssets() async {
    if (_cachedRecipes != null) return;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/recipe.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      if (data['results'] != null) {
        final List results = data['results'];
        _cachedRecipes =
            results.map((json) => RecipeModel.fromJson(json)).toList();
      } else {
        _cachedRecipes = [];
      }
    } catch (e) {
      print('Error loading recipe.json: $e');
      _cachedRecipes = [];
    }
  }

  Future<RecipeResponse> getRecipes({
    int offset = 0,
    int limit = 20,
    String query = '',
    String sort = 'popularity',
    List<String> types = const [],
    List<String> diets = const [],
  }) async {
    // Ensure data is loaded
    await _loadRecipesFromAssets();

    List<RecipeModel> filtered = List.from(_cachedRecipes ?? []);

    // 1. Filter by Query
    if (query.isNotEmpty) {
      filtered = filtered.where((recipe) {
        return recipe.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    // 2. Filter by Type (Multiple Checkbox)
    if (types.isNotEmpty) {
      filtered = filtered.where((recipe) {
        // Returns true if ANY of the recipe's dishTypes match ANY of the selected types
        return recipe.dishTypes.any((dt) => types.contains(dt.toLowerCase()));
      }).toList();
    }

    // 3. Filter by Diet (Multiple Checkbox)
    if (diets.isNotEmpty) {
      filtered = filtered.where((recipe) {
        // Special mapping for boolean fields in RecipeModel (e.g. vegetarian, vegan)
        // Check if selected diets map to boolean fields or existing diet strings
        bool dietMatch = false;

        for (var diet in diets) {
          if (diet == 'vegetarian' && recipe.vegetarian)
            dietMatch = true;
          else if (diet == 'vegan' && recipe.vegan)
            dietMatch = true;
          else if (diet == 'gluten free' && recipe.glutenFree)
            dietMatch = true;
          else if (diet == 'dairy free' && recipe.dairyFree)
            dietMatch = true;
          else if (recipe.diets.contains(diet)) dietMatch = true;

          if (dietMatch)
            break; // OR logic for simplicity: Match ANY selected diet
        }
        return dietMatch;
      }).toList();
    }

    // 4. Sort
    if (sort == 'healthiness') {
      filtered.sort((a, b) => b.healthScore.compareTo(a.healthScore));
    } else if (sort == 'popularity') {
      filtered.sort((a, b) => b.aggregateLikes.compareTo(a.aggregateLikes));
    }

    // 5. Pagination
    final int totalResults = filtered.length;
    int end = offset + limit;
    if (end > totalResults) end = totalResults;

    List<RecipeModel> pageResults = [];
    if (offset < totalResults) {
      pageResults = filtered.sublist(offset, end);
    }

    return RecipeResponse(
      results: pageResults,
      totalResults: totalResults,
    );
  }

  // Backward compatibility
  Future<List<RecipeModel>> getHealthyRecipes(
      {int offset = 0, int limit = 5}) async {
    final response =
        await getRecipes(offset: offset, limit: limit, sort: 'healthiness');
    return response.results;
  }
}
