import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/services/news_parenting_service.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/news_article_model.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({super.key});

  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  final NewsParentingService _newsService = NewsParentingService();
  final List<NewsArticle> _allNews = [];
  bool _isLoading = true;
  bool _hasMore = true;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  // Filtering
  List<NewsArticle> _filteredNews = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadNews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _loadNews();
    }
  }

  Future<void> _loadNews() async {
    if (_isLoading && _currentPage > 1) return; // Prevent double loading

    setState(() => _isLoading = true);

    try {
      final news = await _newsService.getNews(page: _currentPage, limit: 10);

      setState(() {
        if (news.isEmpty) {
          _hasMore = false;
        } else {
          _allNews.addAll(news);
          _currentPage++; // Prepare for next page
        }

        // Apply current filter/search to newly loaded data
        _filterNews(_searchController.text);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading news: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterNews(String query) {
    setState(() {
      _filteredNews = _allNews.where((article) {
        final matchesQuery =
            article.title.toLowerCase().contains(query.toLowerCase());
        final matchesFilter =
            _selectedFilter == 'All' || article.sourceName == _selectedFilter;
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    _filterNews(value);
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filterNews(_searchController.text);
    });
  }

  // Extract unique sources for filter chips
  List<String> get _filterOptions {
    final sources = _allNews.map((e) => e.sourceName).toSet().toList();
    sources.sort();
    return ['All', ...sources.take(5)]; // Limit to a few for UI cleanliness
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Parenting Insights',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue)), // Changed title
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search articles...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Filter Chips
          if (!_isLoading)
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filterOptions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filterOptions[index];
                  final isSelected = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => _onFilterSelected(filter),
                    selectedColor: const Color(0xFF5C9DFF),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.shade300,
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),

          // News List
          Expanded(
            child: _isLoading && _allNews.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _filteredNews.isEmpty
                    ? const Center(child: Text("No articles found"))
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredNews.length + (_hasMore ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (index == _filteredNews.length) {
                            return const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ));
                          }
                          final article = _filteredNews[index];
                          // Use SizedBox to constrain the height of the card in the vertical list if necessary
                          // Since NewsCard was designed for horizontal, let's adjust or wrap it.
                          // Actually, the NewsCard has width 250 fixed. We should either make it flexible or use a different widget.
                          // Let's wrap it in a Container w/o width to specific, but the widget has width: 250.
                          // Ideally NewsCard should take width parameter.
                          // For now, let's just use it and see, or better, modify NewsCard to be flexible if width is not provided?
                          // The user "card nya ini saya ingin ada gambar".
                          // Let's modify NewsCard to accept width.

                          // Wait, I can't modify NewsCard in this turn again efficiently without context switch risk.
                          // But I can replicate the "Image Card" look here or use the NewsDetail routing logic.

                          // Actually, the user asks for "card nya ini" (this card) implying the ones on dashboard.
                          // For AllNewsScreen, it's a list.

                          // Let's use the same behavior: Navigation.

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRouter.newsDetail,
                                  arguments: article);
                            },
                            child: Container(
                              // Replicating basic card structure but for vertical list with Image
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  if (article.urlToImage.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                      child: Image.network(
                                        article.urlToImage,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                    height: 150,
                                                    color: Colors.grey[200],
                                                    child: const Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey)),
                                      ),
                                    ),

                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D3748),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          article.sourceName,
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
