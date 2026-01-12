// screens/meal_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        child: state.hasMealPlan
            ? _buildMealPlan(context, state)
            : _buildEmptyState(context, state),
      ),
    );
  }

  Widget _buildMealPlan(BuildContext context, AppState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meal',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Todays meal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                'Today 27th Oct',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Total Calories gained',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 5),
          Text(
            '${state.caloriesGained} kcal',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FF88),
            ),
          ),
          const SizedBox(height: 25),
          ...state.meals.map((meal) => _buildMealCard(meal)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back, color: Colors.grey),
                label: const Text('Previous', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Text('Next', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildGenerateButton(context, state),
        ],
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                meal['name'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF88).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  meal['type'],
                  style: const TextStyle(
                    color: Color(0xFF00FF88),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${meal['calories']} kcal, ${meal['protein']}g Protein, ${meal['carbs']}g Carbs, ${meal['fat']}g Fat',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Meal',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu_outlined,
                size: 50,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'No meal timetable yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            Text(
              'You don\'t have any meal set up. Can you click on\nthe button below to set up your meal',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 40),
            _buildGenerateButton(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton(BuildContext context, AppState state) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          state.generateMealPlan();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal plan generated!'),
              backgroundColor: Color(0xFF00FF88),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: const Color(0xFF00FF88),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Generate new meal',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}