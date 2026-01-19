import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/core/services/news_parenting_service.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/news_article_model.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/widgets/news_card.dart';
import 'package:provider/provider.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/child_model.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/services/child_service.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/services/recipe_service.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/recipe_model.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/widgets/child_dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DashboardPage extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const DashboardPage({super.key, this.onNavigateToTab});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _selectedChildId; // State to track selected child
  final NewsParentingService _newsService = NewsParentingService();
  List<NewsArticle> _newsList = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final news = await _newsService.getNews();
      setState(() {
        _newsList = news;
      });
    } catch (e) {
      debugPrint('Error fetching parenting news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get user data from provider
    final auth = context.watch<AuthProvider>();
    final user = auth.userModel;
    final userName = user?.name ?? 'Parents';
    final userPhoto = user?.profileImage;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // Light background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Blue overlapping
            // 1. Header with Overlapping Card (Using Column + Transform for correct HitTest)
            _buildHeaderBackground(context, userName, userPhoto),
            Transform.translate(
              offset: const Offset(0, -40), // Move up to overlap header
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildChildrenProfileCard(context, user?.id),
              ),
            ),
            // Removed SizedBox(height: 100) because the Transform moves the visual card up,
            // leaving empty space below it in the layout flow, which acts as the spacer for the next section.

            // 2. Menu Icons
            _buildMenuGrid(context),

            // 3. Popular Thread (Parenting News)
            _buildSectionHeader('Popular Thread', onViewAll: () {
              Navigator.pushNamed(context, AppRouter.allNews);
            }),
            _buildPopularThreadList(),

            // 4. Popular Doctor
            _buildSectionHeader('Popular Doctor', onViewAll: () {
              Navigator.pushNamed(context, AppRouter.doctorList);
            }),
            _buildPopularDoctorList(),

            // 5. Ide Resep Makanan -> Meal Recipe Ideas
            _buildSectionHeader('Meal Recipe Ideas', onViewAll: () {
              Navigator.pushNamed(context, AppRouter.allRecipes);
            }),
            _buildNewestArticleList(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBackground(
    BuildContext context,
    String name,
    String? photoUrl,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 100),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5C9DFF), // Soft Blue
            Color(0xFF3A7BC8), // Darker Blue
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'How was your day?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to Profile Screen
              Navigator.pushNamed(context, AppRouter.profile);
            },
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white.withOpacity(0.3),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenProfileCard(BuildContext context, String? userId) {
    if (userId == null) return const SizedBox.shrink();

    final childService = ChildService();

    return StreamBuilder<List<ChildModel>>(
      stream: childService.getChildrenStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5C9DFF).withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final children = snapshot.data ?? [];

        // Determine displayed child
        ChildModel? displayedChild;
        if (children.isNotEmpty) {
          if (_selectedChildId != null &&
              children.any((c) => c.id == _selectedChildId)) {
            displayedChild =
                children.firstWhere((c) => c.id == _selectedChildId);
          } else {
            displayedChild = children.first;
          }
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5C9DFF).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Children Profile',
                    style: TextStyle(
                      color: Color(0xFF5C9DFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      // Swap/Switch Button if multiple children
                      if (children.length > 1)
                        GestureDetector(
                          onTap: () {
                            // Show selection sheet
                            _showChildSelectionSheet(context, children);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: const Color(0xFF5C9DFF)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.swap_horiz,
                                    size: 14, color: Color(0xFF5C9DFF)),
                                SizedBox(width: 4),
                                Text(
                                  'Ganti',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5C9DFF)),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (displayedChild != null)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) =>
                                  AddEditChildDialog(userId: userId),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.add_circle,
                                  size: 16, color: Color(0xFF5C9DFF)),
                              SizedBox(width: 4),
                              Text(
                                'Tambah',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5C9DFF)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (displayedChild != null) ...[
                Row(
                  children: [
                    // Child Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: displayedChild.gender == 'Perempuan'
                            ? AppColors.femalePink.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                        image: displayedChild.profileImage != null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                    displayedChild.profileImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: displayedChild.profileImage == null
                          ? Center(
                              child: Icon(
                                Icons.face,
                                color: displayedChild.gender == 'Perempuan'
                                    ? AppColors.femalePink
                                    : Colors.blue,
                                size: 36,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    // Child Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayedChild.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            displayedChild.ageString,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: displayedChild.status == 'Normal'
                            ? const Color(0xFFE8F5E9)
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        displayedChild.status,
                        style: TextStyle(
                          color: displayedChild.status == 'Normal'
                              ? const Color(0xFF2E7D32)
                              : Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // View Detail (Edit)
                          showDialog(
                            context: context,
                            builder: (ctx) => AddEditChildDialog(
                                userId: userId, child: displayedChild),
                          );
                        },
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View Detail'),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF5C9DFF),
                            side: const BorderSide(color: Color(0xFF5C9DFF)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            visualDensity: VisualDensity.compact),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Empty State
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "Belum ada data anak",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) =>
                                AddEditChildDialog(userId: userId),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Anak'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C9DFF),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showChildSelectionSheet(
      BuildContext context, List<ChildModel> children) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Anak',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              itemCount: children.length,
              separatorBuilder: (ctx, i) => const Divider(),
              itemBuilder: (context, index) {
                final child = children[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: child.gender == 'Perempuan'
                        ? AppColors.femalePink.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    backgroundImage: child.profileImage != null
                        ? CachedNetworkImageProvider(child.profileImage!)
                        : null,
                    child: child.profileImage == null
                        ? Icon(
                            Icons.face,
                            color: child.gender == 'Perempuan'
                                ? AppColors.femalePink
                                : Colors.blue,
                          )
                        : null,
                  ),
                  title: Text(
                    child.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(child.ageString),
                  trailing: _selectedChildId == child.id ||
                          (_selectedChildId == null && index == 0)
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedChildId = child.id;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final menus = [
      {
        'icon': Icons.pregnant_woman,
        'label': "Mom's\nHealth",
        'color': const Color(0xFF5C9DFF),
        'onTap': () {},
      },
      {
        'icon': Icons.vaccines,
        'label': 'Vaccine\nSchedule',
        'color': const Color(0xFF5C9DFF),
        'onTap': () {},
      },
      {
        'icon': Icons.sentiment_satisfied_alt,
        'label': 'Stress\nMgmt',
        'color': const Color(0xFF5C9DFF),
        'onTap': () {},
      },
      {
        'icon': Icons.contact_phone,
        'label': 'Emergency\nContacts',
        'color': const Color(0xFF5C9DFF),
        'onTap': () {},
      },
      {
        'icon': Icons.quiz,
        'label': 'Fun\nQuiz',
        'color': const Color(0xFF5C9DFF),
        'onTap': () {},
      },
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: menus.length,
        separatorBuilder: (ctx, i) => const SizedBox(width: 16),
        itemBuilder: (ctx, i) {
          final menu = menus[i];
          return GestureDetector(
            onTap: menu['onTap'] as VoidCallback?,
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5C9DFF).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    menu['icon'] as IconData,
                    color: menu['color'] as Color,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  menu['label'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A5568),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Color(0xFF5C9DFF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPopularThreadList() {
    if (_newsList.isEmpty) {
      return const SizedBox(
        height: 190,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 250, // Increased height to fit NewsCard
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: _newsList.take(5).length, // Show top 5
        separatorBuilder: (ctx, i) => const SizedBox(width: 16),
        itemBuilder: (ctx, i) {
          final article = _newsList[i];
          return NewsCard(
            article: article,
            onTap: () {
              Navigator.pushNamed(context, AppRouter.newsDetail,
                  arguments: article);
            },
          );
        },
      ),
    );
  }

  Widget _buildPopularDoctorList() {
    final doctors = [
      {
        'name': 'Dr. Truluck Nik',
        'role': 'Medicine Specialist',
        'rating': 4.0,
        'image': 'https://placehold.co/200x200/png?text=Dr+Nik'
      },
      {
        'name': 'Dr. Tranquilli',
        'role': 'Pathology Specialist',
        'rating': 5.0,
        'image': 'https://placehold.co/200x200/png?text=Dr+Tran'
      },
      {
        'name': 'Dr. Shoemaker',
        'role': 'Pediatrician',
        'rating': 3.0,
        'image': 'https://placehold.co/200x200/png?text=Dr+Shoe'
      },
      {
        'name': 'Dr. Haddock',
        'role': 'Obstetrician',
        'rating': 5.0,
        'image': 'https://placehold.co/200x200/png?text=Dr+Had'
      },
    ];

    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: doctors.length,
        separatorBuilder: (ctx, i) => const SizedBox(width: 16),
        itemBuilder: (ctx, i) {
          final doctor = doctors[i];
          return Container(
            width: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            doctor['image'] as String),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        doctor['name'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor['role'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          double rating = doctor['rating'] as double;
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 14,
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewestArticleList() {
    final recipeService = RecipeService();

    return SizedBox(
      height: 160,
      child: FutureBuilder<List<RecipeModel>>(
        future: recipeService.getHealthyRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Fallback or error display
            return Center(
                child: Text("Failed to load articles",
                    style: TextStyle(color: Colors.grey.shade500)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("No articles found",
                    style: TextStyle(color: Colors.grey.shade500)));
          }

          final recipes = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            separatorBuilder: (ctx, i) => const SizedBox(width: 16),
            itemBuilder: (ctx, i) {
              final recipe = recipes[i];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.recipeDetail,
                    arguments: recipe,
                  );
                },
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        recipe.image.isNotEmpty
                            ? recipe.image
                            : 'https://via.placeholder.com/240x160?text=No+Image',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5C9DFF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Nutrition',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                recipe.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
