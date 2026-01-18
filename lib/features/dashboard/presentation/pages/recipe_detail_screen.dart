import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/recipe_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeDetailScreen extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: CustomScrollView(
        slivers: [
          // 1. App Bar Image (Improved)
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFF5C9DFF),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'recipe_image_${recipe.id}',
                    child: recipe.image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: recipe.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                _buildPlaceholderImage(),
                          )
                        : _buildPlaceholderImage(),
                  ),
                  // Gradient Overlay for better text visibility (if title was over image)
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.3, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
                child:
                    Icon(Icons.arrow_back, color: Color(0xFF5C9DFF), size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Icon(Icons.favorite, color: Colors.red, size: 20),
                ),
                onPressed: () {}, // Favorite action stub
              )
            ],
          ),

          // 2. Content
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title & Badges
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (recipe.veryHealthy)
                          _buildBadge(Icons.health_and_safety, "Very Healthy",
                              Colors.green),
                        if (recipe.glutenFree)
                          _buildBadge(Icons.check_circle_outline, "Gluten Free",
                              Colors.orange),
                        if (recipe.dairyFree)
                          _buildBadge(
                              Icons.water_drop, "Dairy Free", Colors.blue),
                        if (recipe.vegetarian)
                          _buildBadge(Icons.eco, "Vegetarian", Colors.teal),
                        if (recipe.vegan)
                          _buildBadge(Icons.spa, "Vegan", Colors.green),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Quick Stats (Enhanced Colors)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                              Icons.timer_outlined,
                              "${recipe.readyInMinutes} min",
                              "Cook Time",
                              Colors.blue),
                          _buildStatItem(
                              Icons.restaurant_menu,
                              "${recipe.servings} Servings",
                              "Yield",
                              Colors.orange),
                          _buildStatItem(Icons.thumb_up_alt_outlined,
                              "${recipe.aggregateLikes}", "Likes", Colors.red),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Health Score
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFE3F2FD),
                            Colors.blue.shade50
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFF90CAF9).withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.star_rounded,
                                color: Color(0xFF1E88E5), size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Health Score: ${recipe.healthScore.clamp(0, 100).toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF1565C0),
                                  ),
                                ),
                                const Text(
                                  "Based on Spoonacular analysis",
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF64B5F6)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Summary
                    const Text(
                      "About this Recipe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _removeAllHtmlTags(recipe.summary),
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Tags Section
                    if (recipe.dishTypes.isNotEmpty ||
                        recipe.diets.isNotEmpty) ...[
                      const Text("Tags",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...recipe.dishTypes.map((e) => Chip(
                                label: Text(e,
                                    style: const TextStyle(fontSize: 12)),
                                backgroundColor: Colors.grey.shade100,
                                side: BorderSide.none,
                              )),
                          ...recipe.diets.map((e) => Chip(
                                label: Text(e,
                                    style: const TextStyle(fontSize: 12)),
                                backgroundColor: Colors.green.shade50,
                                labelStyle:
                                    TextStyle(color: Colors.green.shade800),
                                side: BorderSide.none,
                              )),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF2D3748),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.blue.shade50,
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          color: Colors.blue.shade200,
          size: 80,
        ),
      ),
    );
  }

  String _removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}
