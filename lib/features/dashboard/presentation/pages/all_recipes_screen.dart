import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/recipe_model.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/services/recipe_service.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AllRecipesScreen extends StatefulWidget {
  const AllRecipesScreen({super.key});

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  final RecipeService _recipeService = RecipeService();
  final int _itemsPerPage = 20;
  int _currentPage = 1;

  // Search & Filter State
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<String> _selectedMealTypes = [];
  List<String> _selectedDiets = [];
  String _currentSort =
      'none'; // Default to 'none' as 'popularity' was requested to be removed/optional

  List<RecipeModel> _recipes = [];
  int _totalResults = 0;
  bool _isLoading = false;
  String? _error;

  // Colors
  final Color _activePageColor = const Color(0xFF1976D2);

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final offset = (_currentPage - 1) * _itemsPerPage;
      final response = await _recipeService.getRecipes(
        offset: offset,
        limit: _itemsPerPage,
        query: _searchQuery,
        types: _selectedMealTypes,
        diets: _selectedDiets,
        sort: _currentSort,
      );

      setState(() {
        _recipes = response.results;
        _totalResults = response.totalResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_searchQuery != query) {
      setState(() {
        _searchQuery = query;
        _currentPage = 1;
      });
      _fetchRecipes();
    }
  }

  void _goToPage(int page) {
    if (page < 1) return;
    int maxPage = (_totalResults / _itemsPerPage).ceil();
    if (maxPage == 0) maxPage = 1;
    if (page > maxPage) return;

    setState(() {
      _currentPage = page;
    });
    _fetchRecipes();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return _FilterContent(
            scrollController: scrollController,
            initialSort: _currentSort,
            initialMealTypes: _selectedMealTypes,
            initialDiets: _selectedDiets,
            onApply: (sort, mealTypes, diets) {
              setState(() {
                _currentSort = sort;
                _selectedMealTypes = mealTypes;
                _selectedDiets = diets;
                _currentPage = 1; // Reset to page 1
              });
              _fetchRecipes();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int maxPage = (_totalResults / _itemsPerPage).ceil();
    if (maxPage == 0 && !_isLoading) maxPage = 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Ide Resep Makanan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _activePageColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari resep...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: _onSearchChanged,
            ),
          ),

          // Debug/Info: Show active filters if any
          if (_selectedMealTypes.isNotEmpty || _selectedDiets.isNotEmpty)
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ..._selectedMealTypes.map((e) => _buildFilterChip(e, true)),
                  ..._selectedDiets.map((e) => _buildFilterChip(e, false)),
                ],
              ),
            ),

          // List
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: _activePageColor))
                : _recipes.isEmpty
                    ? Center(
                        child: Text("Tidak ada resep.",
                            style: TextStyle(color: Colors.grey[600])))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              0.75, // Keeps uniform height, better for grid.
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) {
                          return _buildRecipeCard(_recipes[index]);
                        },
                      ),
          ),

          // Pagination
          if (!_isLoading && _recipes.isNotEmpty) _buildPaginationBar(maxPage),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isMealType) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.white)),
        backgroundColor: _activePageColor,
        deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white),
        onDeleted: () {
          setState(() {
            if (isMealType) {
              _selectedMealTypes.remove(label);
            } else {
              _selectedDiets.remove(label);
            }
            _currentPage = 1;
          });
          _fetchRecipes();
        },
        padding: const EdgeInsets.all(0),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  // Same Modern Pagination Design
  Widget _buildPaginationBar(int maxPage) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Text
          InkWell(
            onTap: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(Icons.chevron_left,
                      size: 16,
                      color: _currentPage > 1
                          ? Colors.grey[600]
                          : Colors.grey[300]),
                  Text("Previous",
                      style: TextStyle(
                          color: _currentPage > 1
                              ? Colors.grey[600]
                              : Colors.grey[300])),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Page Numbers
          ..._buildPageNumbers(maxPage),

          const SizedBox(width: 8),

          // Next Text
          InkWell(
            onTap: _currentPage < maxPage
                ? () => _goToPage(_currentPage + 1)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text("Next",
                      style: TextStyle(
                          color: _currentPage < maxPage
                              ? _activePageColor
                              : Colors.grey[300],
                          fontWeight: FontWeight.w500)),
                  Icon(Icons.chevron_right,
                      size: 16,
                      color: _currentPage < maxPage
                          ? _activePageColor
                          : Colors.grey[300]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(int maxPage) {
    List<Widget> pages = [];

    void addPage(int page) {
      pages.add(_buildPageItem(page));
    }

    void addEllipsis() {
      pages.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text("...", style: TextStyle(color: Colors.grey[600])),
      ));
    }

    // Always 1
    addPage(1);

    if (_currentPage > 3) {
      addEllipsis();
    }

    int start = _currentPage - 1;
    if (start < 2) start = 2;
    int end = _currentPage + 1;
    if (end >= maxPage) end = maxPage - 1;

    for (int i = start; i <= end; i++) {
      addPage(i);
    }

    if (_currentPage < maxPage - 2) {
      addEllipsis();
    }

    if (maxPage > 1) {
      addPage(maxPage);
    }

    return pages;
  }

  Widget _buildPageItem(int page) {
    final bool isActive = page == _currentPage;
    return InkWell(
      onTap: () => _goToPage(page),
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? _activePageColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          "$page",
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[700],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // UPDATED: Recipe Card with Love Icon overlaid on the image
  Widget _buildRecipeCard(RecipeModel recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.recipeDetail, arguments: recipe);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: recipe.image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: recipe.image,
                            fit: BoxFit
                                .cover, // Ensures image fills the area (simulating adapting to card space)
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade100,
                              child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                _buildPlaceholderImage(),
                          )
                        : _buildPlaceholderImage(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(recipe.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13, height: 1.2)),
          const SizedBox(height: 4),
          Row(
            children: [
              if (recipe.veryHealthy)
                const Icon(Icons.verified, size: 14, color: Colors.green),
              if (recipe.veryHealthy) const SizedBox(width: 4),
              Text("${recipe.readyInMinutes} min",
                  style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              const Spacer(),
              const Icon(Icons.favorite, size: 14, color: Colors.red),
              const SizedBox(width: 2),
              Text(
                "${recipe.aggregateLikes}",
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, size: 14, color: Colors.orange),
              Text(" ${(recipe.healthScore).clamp(0, 100).toStringAsFixed(0)}",
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  // Custom placeholder for missing/error images
  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.blue.shade50,
      child: Center(
        child: Icon(
          Icons.restaurant_menu, // The food icon as requested
          color: Colors.blue.shade200,
          size: 40,
        ),
      ),
    );
  }
}

// Filter Modal Content Widget
class _FilterContent extends StatefulWidget {
  final ScrollController scrollController;
  final String initialSort;
  final List<String> initialMealTypes;
  final List<String> initialDiets;
  final Function(String, List<String>, List<String>) onApply;

  const _FilterContent({
    required this.scrollController,
    required this.initialSort,
    required this.initialMealTypes,
    required this.initialDiets,
    required this.onApply,
  });

  @override
  State<_FilterContent> createState() => _FilterContentState();
}

class _FilterContentState extends State<_FilterContent> {
  late String _sort;
  late List<String> _mealTypes;
  late List<String> _diets;

  final List<String> _allMealTypes = [
    'Main Course',
    'Side Dish',
    'Dessert',
    'Appetizer',
    'Salad',
    'Bread',
    'Breakfast',
    'Soup',
    'Beverage',
    'Sauce',
    'Marinade',
    'Fingerfood',
    'Snack',
    'Drink'
  ];

  final List<String> _allDiets = [
    'Gluten Free',
    'Ketogenic',
    'Vegetarian',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Vegan',
    'Pescetarian',
    'Paleo',
    'Primal',
    'Whole30'
  ];

  @override
  void initState() {
    super.initState();
    _sort = widget.initialSort;
    _mealTypes = List.from(widget.initialMealTypes);
    _diets = List.from(widget.initialDiets);
  }

  void _toggleMealType(String type) {
    setState(() {
      if (_mealTypes.contains(type)) {
        _mealTypes.remove(type);
      } else {
        _mealTypes.add(type);
      }
    });
  }

  void _toggleDiet(String diet) {
    setState(() {
      if (_diets.contains(diet)) {
        _diets.remove(diet);
      } else {
        _diets.add(diet);
      }
    });
  }

  // Checkbox Item Builder
  Widget _buildCheckboxItem(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: isSelected,
                onChanged: (val) => onTap(),
                activeColor: const Color(0xFF1976D2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected ? const Color(0xFF1976D2) : Colors.black87,
                    ))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: ListView(
        controller: widget.scrollController,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Filter Recipes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          // Sort Section (Updated)
          const Text("Sort By",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              // No Sort option
              ChoiceChip(
                  label: const Text("Default (None)"),
                  selected: _sort == 'none',
                  onSelected: (b) => setState(() => _sort = 'none'),
                  selectedColor: Colors.blue.shade100),
              // Sort Options
              ChoiceChip(
                  label: const Text("Popularity"),
                  selected: _sort == 'popularity',
                  onSelected: (b) => setState(() => _sort = 'popularity'),
                  selectedColor: Colors.blue.shade100),
              ChoiceChip(
                  label: const Text("Healthiness"),
                  selected: _sort == 'healthiness',
                  onSelected: (b) => setState(() => _sort = 'healthiness'),
                  selectedColor: Colors.blue.shade100),
            ],
          ),
          const SizedBox(height: 20),

          // Types (Checkbox List)
          const Text("Meal Types",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          // We can use a grid or list. Grid looks better for filter sheets.
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.5, // wide, short items
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
            ),
            itemCount: _allMealTypes.length,
            itemBuilder: (context, index) {
              final type = _allMealTypes[index];
              final isSelected = _mealTypes.contains(type.toLowerCase());
              return _buildCheckboxItem(
                  type, isSelected, () => _toggleMealType(type.toLowerCase()));
            },
          ),

          const SizedBox(height: 20),

          // Diets (Checkbox List)
          const Text("Diets",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
            ),
            itemCount: _allDiets.length,
            itemBuilder: (context, index) {
              final diet = _allDiets[index];
              final isSelected = _diets.contains(diet.toLowerCase());
              return _buildCheckboxItem(
                  diet, isSelected, () => _toggleDiet(diet.toLowerCase()));
            },
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _sort = 'none';
                      _mealTypes.clear();
                      _diets.clear();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Reset"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_sort, _mealTypes, _diets);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Apply Filter"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
