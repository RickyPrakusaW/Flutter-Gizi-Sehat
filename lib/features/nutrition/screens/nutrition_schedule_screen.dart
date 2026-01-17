import 'package:flutter/material.dart';
import '../models/meal_plan_model.dart';

class NutritionScheduleScreen extends StatefulWidget {
  const NutritionScheduleScreen({super.key});

  @override
  State<NutritionScheduleScreen> createState() =>
      _NutritionScheduleScreenState();
}

class _NutritionScheduleScreenState extends State<NutritionScheduleScreen> {
  // Mock Data
  final List<MealPlanModel> _meals = [
    MealPlanModel(
      id: '1',
      type: MealType.breakfast,
      title: 'Bubur Manado + Telur',
      description: 'Porsi kecil, tambah 1 butir telur rebus.',
      calories: 250,
      time: DateTime(2024, 1, 1, 07, 00),
      isCompleted: true,
    ),
    MealPlanModel(
      id: '2',
      type: MealType.snack,
      title: 'Buah Pisang / Papaya',
      description: 'Potong kecil-kecil agar mudah dikunyah.',
      calories: 90,
      time: DateTime(2024, 1, 1, 10, 00),
      isCompleted: false,
    ),
    MealPlanModel(
      id: '3',
      type: MealType.lunch,
      title: 'Nasi Tim Ayam Worl & Brokoli',
      description: 'Pastikan sayuran matang sempurna.',
      calories: 320,
      time: DateTime(2024, 1, 1, 12, 30),
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Nutrisi Anak'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Add new schedule
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _meals.length,
        itemBuilder: (context, index) {
          final meal = _meals[index];
          return _buildMealCard(meal);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to Food Scanner
          Navigator.pushNamed(context, '/food-scanner');
        },
        icon: const Icon(Icons.camera_alt),
        label: const Text('Scan Makanan'),
      ),
    );
  }

  Widget _buildMealCard(MealPlanModel meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: meal.isCompleted
              ? Colors.green.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
          child: Icon(
            meal.isCompleted ? Icons.check : Icons.access_time,
            color: meal.isCompleted ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(
          meal.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              meal.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  meal.timeFormatted,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.local_fire_department,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${meal.calories} kkal',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Checkbox(
          value: meal.isCompleted,
          onChanged: (val) {
            setState(() {
              // In real app, update model
            });
          },
        ),
      ),
    );
  }
}
