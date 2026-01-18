import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/child_model.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/services/child_service.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/widgets/child_dialogs.dart';

class ChildPage extends StatefulWidget {
  const ChildPage({super.key});

  @override
  State<ChildPage> createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  // 0 = Child Growth, 1 = Daily Diaries
  int _selectedTab = 0;
  // 0 = Weight, 1 = Height, 2 = Head Girth
  int _selectedGrowthMetric = 0;
  // null = Summary, 'Carbs', 'Proteins', 'Fat'
  String? _selectedNutrientType;

  final ChildService _childService = ChildService();
  String? _selectedChildId;

  void _showChildSelection(List<ChildModel> children) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: children.length + 1,
        itemBuilder: (context, index) {
          if (index == children.length) {
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.add, color: AppColors.primary),
              ),
              title: const Text(
                'Tambah Anak',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                final uid = context.read<AuthProvider>().userModel?.id;
                if (uid != null) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AddEditChildDialog(userId: uid),
                  );
                }
              },
            );
          }
          final child = children[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: child.gender == 'Perempuan'
                  ? AppColors.femalePink.withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
              child: Icon(
                Icons.face,
                color: child.gender == 'Perempuan'
                    ? AppColors.femalePink
                    : Colors.blue,
              ),
            ),
            title: Text(
              child.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(child.ageString),
            trailing: _selectedChildId == child.id
                ? const Icon(Icons.check_circle, color: AppColors.primary)
                : null,
            onTap: () {
              setState(() => _selectedChildId = child.id);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.watch<AuthProvider>().userModel?.id;

    if (uid == null) {
      return const Scaffold(body: Center(child: Text('Please login first')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: _selectedNutrientType != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => setState(() => _selectedNutrientType = null),
              )
            : null,
        toolbarHeight: _selectedNutrientType != null ? 56 : 80, // Adjust height
        title: _selectedNutrientType != null
            ? null // No custom title when in detail mode
            : StreamBuilder<List<ChildModel>>(
                stream: _childService.getChildrenStream(uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  final children = snapshot.data ?? [];
                  if (children.isEmpty)
                    return const SizedBox(); // Handle empty in body

                  // Determine selected child
                  ChildModel displayedChild;
                  if (_selectedChildId != null &&
                      children.any((c) => c.id == _selectedChildId)) {
                    displayedChild = children.firstWhere(
                      (c) => c.id == _selectedChildId,
                    );
                  } else {
                    displayedChild = children.first;
                    // Defer state update to avoid build error
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_selectedChildId != displayedChild.id) {
                        setState(() => _selectedChildId = displayedChild.id);
                      }
                    });
                  }

                  return _buildHeader(children, displayedChild, uid);
                },
              ),
      ),
      body: StreamBuilder<List<ChildModel>>(
        stream: _childService.getChildrenStream(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final children = snapshot.data ?? [];

          if (children.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.child_care,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Belum ada data anak',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tambahkan data anak untuk memantau\ntumbuh kembangnya.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AddEditChildDialog(userId: uid),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Anak'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tabs
                if (_selectedNutrientType == null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _buildTabItem(0, 'Child growth'),
                        const SizedBox(width: 24),
                        _buildTabItem(1, 'Daily diaries'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _selectedTab == 0
                      ? _buildGrowthTabContent()
                      : _buildDailyDiariesTabContent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    List<ChildModel> allChildren,
    ChildModel currentChild,
    String uid,
  ) {
    return GestureDetector(
      onTap: () => _showChildSelection(allChildren),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        color: Colors.transparent, // Hit test
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: currentChild.gender == 'Perempuan'
                      ? AppColors.femalePink.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.2),
                  child: Icon(
                    Icons.face,
                    color: currentChild.gender == 'Perempuan'
                        ? AppColors.femalePink
                        : Colors.blue,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.stars,
                      size: 12,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          currentChild.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '- ${currentChild.status}',
                        style: TextStyle(
                          color: currentChild.status == 'Normal'
                              ? AppColors.success
                              : Colors.orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    currentChild.ageString,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            // Edit Button
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AddEditChildDialog(
                    userId: uid,
                    child: currentChild, // Edit mode
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons
                    .search, // Replaced arrow with search or something else, actually arrow is fine for dropdown
                size: 18,
                color: Colors.blue.shade700,
              ),
            ),
            // Force icon back to arrow in replacement content
            const SizedBox(width: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            height: 2,
            width: 100, // Fixed width underline
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }

  // --- Growth Tab ---
  Widget _buildGrowthTabContent() {
    String chartTitle;
    String chartUnit;
    switch (_selectedGrowthMetric) {
      case 1:
        chartTitle = 'Height Growth chart';
        chartUnit = 'Height (cm)';
        break;
      case 2:
        chartTitle = 'Head girth Growth chart';
        chartUnit = 'Head Girth (cm)';
        break;
      case 0:
      default:
        chartTitle = 'Weight Growth chart';
        chartUnit = 'Weight (kg)';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedGrowthMetric == 0
              ? 'Current Weight Growth'
              : _selectedGrowthMetric == 1
              ? 'Current Height Growth'
              : 'Current Head Girth Growth',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last updated on 06/11/2024',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.help_outline,
                        size: 18,
                        color: Colors.blue.shade700,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      index: 0,
                      label: 'Weight',
                      value: '9.4 Kg',
                      icon: Icons.monitor_weight_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      index: 1,
                      label: 'Height',
                      value: '80 Cm',
                      icon: Icons.height,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      index: 2,
                      label: 'H. Girth',
                      value: '47.5 Cm',
                      icon: Icons.face,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Interpretation',
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Normal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "The child's weight is normal for her age. You can monitor your child's weight and height regularly by referring to the weight/height curve.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "For further questions, you can schedule a visit to your pediatrician or the nearest integrated service post.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // --- Dynamic Chart Section ---
        Text(
          chartTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                      children: [
                        TextSpan(text: 'Last updated on '),
                        TextSpan(
                          text: '06/11/2024',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.question_mark,
                      size: 14,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                chartUnit,
                style: TextStyle(
                  color: Colors.blue.shade300,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                // Custom Painter to draw the graph
                child: CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: SimpleLineChartPainter(
                    metricType: _selectedGrowthMetric,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '1y 2m',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    '1y 3m',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    '1y 4m',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    '1y 5m',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    '1y 6m',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Age (year - month)',
                  style: TextStyle(fontSize: 10, color: Colors.indigoAccent),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        _buildBlueBanner('Child Growth Guide', '19 - 24 Months (2 Years)'),
        const SizedBox(height: 40),
        const Text(
          'Vaccine schedule',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      children: [
                        TextSpan(text: 'Current date '),
                        TextSpan(
                          text: '06/11/2024',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'See all',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Recommends to take vaccines on Nov. 12, 2024',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              _buildVaccineItem('Hepatitis B1', false),
              const Divider(height: 24),
              _buildVaccineItem('Polio 0', false),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- Daily Diaries Tab ---
  Widget _buildDailyDiariesTabContent() {
    if (_selectedNutrientType != null) {
      return _buildNutrientDetail(_selectedNutrientType!);
    }
    return _buildDailyDiariesSummary();
  }

  Widget _buildDailyDiariesSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition needs today',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 13),
                      children: [
                        TextSpan(text: 'Current date '),
                        TextSpan(
                          text: '06/11/2024',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'See recommendation',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Top Stats row with Circular Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side stats: Calories & Calcium
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSimpleStat(
                        icon: Icons.restaurant,
                        label: 'Calories',
                        value: '1000 Kcal',
                        iconColor: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      _buildSimpleStat(
                        icon: Icons.local_drink,
                        label: 'Calcium',
                        value: '300/500 mg',
                        iconColor: Colors.blue,
                      ),
                    ],
                  ),
                  // Circular Progress
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: 0.75, // 750/1000
                          strokeWidth: 8,
                          backgroundColor: Colors.blue.shade50,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF2196F3),
                          ),
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '750 Kcal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'has eaten',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Bottom nutrient cards (Carbs, Protein, Fat)
              Row(
                children: [
                  Expanded(
                    child: _buildNutrientCard(
                      label: 'Carbs',
                      value: '98/130 g',
                      subLabel: 'per day',
                      icon: Icons.rice_bowl,
                      color: Colors.blue.shade50,
                      textColor: Colors.black87,
                      onTap: () =>
                          setState(() => _selectedNutrientType = 'Carbs'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNutrientCard(
                      label: 'Proteins',
                      value: '9.8/13 g',
                      subLabel: 'per day',
                      icon: Icons.egg_alt,
                      color: Colors.blue.shade100,
                      textColor: Colors.black87,
                      onTap: () =>
                          setState(() => _selectedNutrientType = 'Proteins'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNutrientCard(
                      label: 'Fat',
                      value: '26.3/35 g',
                      subLabel: 'per day',
                      icon: Icons.fastfood,
                      color: Colors.blue.shade200,
                      textColor: Colors.black87,
                      onTap: () =>
                          setState(() => _selectedNutrientType = 'Fat'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildBlueBanner('Child Nutrition Guide', '19 - 24 Months (2 Years)'),
        const SizedBox(height: 24),

        const Text(
          'Today meal diary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        // Meal Diary List
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current date  06/11/2024',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMealItem('Breakfast', '410 Kcal', [
                'Chicken vegetable rice',
                'Boiled egg',
                'Milk',
              ], const Color(0xFFB2DFDB)), // Greenish background
              const SizedBox(height: 16),
              _buildMealItem('Lunch', '340 Kcal', [
                'Chicken vegetable rice',
                'Boiled egg',
              ], const Color(0xFFB2DFDB)),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- Daily Diaries Detailed Nutrient View ---
  Widget _buildNutrientDetail(String type) {
    // Data setup based on type
    final isCarbs = type == 'Carbs';
    final isProtein = type == 'Proteins';

    // Theme Colors
    const Color progressColor = Color(0xFF2196F3);

    // Content Data
    String title = '$type recommendation';
    String descriptionTitle = 'What is ${type.toLowerCase()}?';
    String description = '';
    String progressText = '';
    double progressValue = 0.0;

    List<Map<String, dynamic>> recommendations = [];

    if (isCarbs) {
      progressText = '98/130 g';
      progressValue = 98 / 130;
      description =
          "Carbohydrates are one of the essential macronutrients that serve as the primary energy source for the body. Found in foods like rice, bread, fruits, and vegetables, carbohydrates are broken down into glucose, which fuels the body's cells, tissues, and organs.";
      recommendations = [
        {
          'title': 'White rice',
          'tag': 'Staple food',
          'desc':
              'White rice is a source of complex carbohydrates that is rich in fiber.',
          'icon': Icons.rice_bowl,
          'color': Colors.orange.shade100,
        },
        {
          'title': 'Potato',
          'tag': 'Staple food',
          'desc':
              'Potatoes can provide stable energy and contain many nutrients.',
          'icon': Icons.eco,
          'color': Colors.amber.shade100,
        },
      ];
    } else if (isProtein) {
      progressText = '9.8/13 g';
      progressValue = 9.8 / 13;
      description =
          "Protein is one of the most important nutrients for the body. Protein serves to build and repair body tissues, as well as help with metabolic processes and hormone production.";
      recommendations = [
        {
          'title': 'Chicken meat',
          'tag': 'Side dish',
          'desc':
              'Chicken meat is a source of animal protein rich in amino acids.',
          'icon': Icons.egg, // Fallback icon
          'color': Colors.red.shade100,
        },
        {
          'title': 'Fish',
          'tag': 'Side dish',
          'desc':
              'Fish is an excellent source of protein contains omega-3 fatty acids.',
          'icon': Icons.set_meal,
          'color': Colors.blue.shade100,
        },
      ];
    } else {
      // Fat
      progressText = '26.3/35 g';
      progressValue = 26.3 / 35;
      description =
          "Fat is one of the essential macronutrients for the body, which functions as a source of energy reserves, a protector of the body's organs, and helps the absorption of fat-soluble vitamins.";
      recommendations = [
        {
          'title': 'Avocado',
          'tag': 'Healthy fat',
          'desc':
              'Avocados contain monounsaturated fats that are good for heart health.',
          'icon': Icons.circle, // Fallback
          'color': Colors.green.shade100,
        },
        {
          'title': 'Cheese',
          'tag': 'Saturated Fat',
          'desc':
              'Cheese contains saturated fat and is often eaten as an accompaniment.',
          'icon': Icons.breakfast_dining,
          'color': Colors.yellow.shade100,
        },
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 13),
                      children: [
                        TextSpan(text: 'Current date '),
                        TextSpan(
                          text: '06/11/2024',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'See recommendation',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Big Circular Indicator
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: CircularProgressIndicator(
                        value: progressValue,
                        strokeWidth: 12,
                        backgroundColor: Colors.blue.shade50,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          progressText,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'per day',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                descriptionTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              if (type == 'Carbs')
                Text(
                  'If you have further questions about carbohydrate intake or its role in your diet, consider consulting a nutritionist or healthcare professional.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Text(
          'Our recommendation for ${type.toLowerCase()}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),

        // Recommendations Horizontal List
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: recommendations
                .map((rec) => _buildFoodRecommendationCard(rec))
                .toList(),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildFoodRecommendationCard(Map<String, dynamic> data) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / Placeholder area
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: data['color'] ?? Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Icon(data['icon'], size: 50, color: Colors.black26),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF80CBC4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data['tag'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['desc'],
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: Colors.blue.shade800,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Detail Nutrition',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlueBanner(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3), // Bright Blue
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientCard({
    required String label,
    required String value,
    required String subLabel,
    required IconData icon,
    required Color color,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              subLabel,
              style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.7)),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.keyboard_arrow_right,
                  size: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealItem(
    String mealType,
    String calories,
    List<String> items,
    Color bgColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.wb_sunny_outlined,
              size: 20,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        mealType,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        calories,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.keyboard_arrow_right,
              size: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required int index,
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedGrowthMetric == index;
    final bgColor = isSelected
        ? const Color(0xFF80CBC4).withOpacity(0.3)
        : Colors.grey.shade100;
    final borderColor = isSelected
        ? const Color(0xFF80CBC4).withOpacity(0.5)
        : Colors.transparent;
    final contentColor = isSelected
        ? const Color(0xFF00695C)
        : Colors.grey.shade600;
    final valueColor = isSelected ? const Color(0xFF004D40) : Colors.black87;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGrowthMetric = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: contentColor, size: 24),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 12, color: contentColor)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 12,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccineItem(String name, bool isTaken) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isTaken
                    ? AppColors.successLight
                    : const Color(0xFFFFCDD2), // Red light for not taken
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isTaken ? 'Taken' : 'Not taken',
                style: TextStyle(
                  fontSize: 12,
                  color: isTaken
                      ? AppColors.successDark
                      : const Color(0xFFC62828),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ],
    );
  }
}

// Custom Painter for simple line chart
class SimpleLineChartPainter extends CustomPainter {
  final int metricType; // 0, 1, 2 to vary the curve slightly
  SimpleLineChartPainter({required this.metricType});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Grid Lines (Dashed)
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    // Draw 5 horizontal grid lines
    for (int i = 0; i < 5; i++) {
      double y = size.height - (i * (size.height / 4));
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), gridPaint);

      // Draw Y-axis labels
      // Dummy logic for labels based on metric
      int baseVal = metricType == 0 ? 7 : (metricType == 1 ? 72 : 44);
      int step = 2;
      int val = baseVal + (i * step);

      TextSpan span = TextSpan(
        style: TextStyle(color: Colors.blue.shade200, fontSize: 10),
        text: val.toString(),
      );
      TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(0, y - 15));
    }

    // Path for line
    final path = Path();
    // Simulate data points based on metric
    // Metric 0 (Weight): Increasing curve
    // Metric 1 (Height): Steeper curve
    // Metric 2 (Girth): Flatter curve

    double h = size.height;
    double w = size.width;

    path.moveTo(0, h * 0.8); // Start point

    if (metricType == 0) {
      // Weight
      path.lineTo(w * 0.2, h * 0.78);
      path.lineTo(w * 0.4, h * 0.65);
      path.lineTo(w * 0.6, h * 0.7); // Dip
      path.lineTo(w * 0.8, h * 0.4);
      path.lineTo(w, h * 0.45);
    } else if (metricType == 1) {
      // Height (Steady up)
      path.lineTo(w * 0.2, h * 0.7);
      path.lineTo(w * 0.4, h * 0.6);
      path.lineTo(w * 0.6, h * 0.4);
      path.lineTo(w * 0.8, h * 0.2);
      path.lineTo(w, h * 0.15);
    } else {
      // Girth (Gradual)
      path.lineTo(w * 0.2, h * 0.75);
      path.lineTo(w * 0.4, h * 0.72);
      path.lineTo(w * 0.6, h * 0.68);
      path.lineTo(w * 0.8, h * 0.65);
      path.lineTo(w, h * 0.6);
    }

    // Draw Fill
    final fillPath = Path.from(path);
    fillPath.lineTo(w, h);
    fillPath.lineTo(0, h);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Draw Line
    canvas.drawPath(path, paint);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 5;
    double dashSpace = 5;
    double distance = (p2 - p1).distance;
    double dx = (p2.dx - p1.dx) / distance;
    double dy = (p2.dy - p1.dy) / distance;

    double currentDistance = 0;
    while (currentDistance < distance) {
      canvas.drawLine(
        Offset(p1.dx + dx * currentDistance, p1.dy + dy * currentDistance),
        Offset(
          p1.dx + dx * (currentDistance + dashWidth),
          p1.dy + dy * (currentDistance + dashWidth),
        ),
        paint,
      );
      currentDistance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant SimpleLineChartPainter oldDelegate) {
    return oldDelegate.metricType != metricType;
  }
}
