class RecipeModel {
  final int id;
  final String title;
  final String image;
  final String summary;
  final int readyInMinutes;
  final int servings;
  final bool vegetarian;
  final bool vegan;
  final bool glutenFree;
  final bool dairyFree;
  final bool veryHealthy;
  final int aggregateLikes;
  final double healthScore;
  final List<String> dishTypes;
  final List<String> diets;

  RecipeModel({
    required this.id,
    required this.title,
    required this.image,
    this.summary = '',
    this.readyInMinutes = 0,
    this.servings = 0,
    this.vegetarian = false,
    this.vegan = false,
    this.glutenFree = false,
    this.dairyFree = false,
    this.veryHealthy = false,
    this.aggregateLikes = 0,
    this.healthScore = 0.0,
    this.dishTypes = const [],
    this.diets = const [],
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      image: json['image'] ?? '',
      summary: json['summary'] ?? '',
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      vegetarian: json['vegetarian'] ?? false,
      vegan: json['vegan'] ?? false,
      glutenFree: json['glutenFree'] ?? false,
      dairyFree: json['dairyFree'] ?? false,
      veryHealthy: json['veryHealthy'] ?? false,
      aggregateLikes: json['aggregateLikes'] ?? 0,
      healthScore: (json['healthScore'] ?? 0).toDouble(),
      dishTypes: (json['dishTypes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      diets: (json['diets'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
