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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!state.hasMealPlan) {
            state.generateMealPlan();
          }
          _showAddFoodDialog(context);
        },
        backgroundColor: const Color(0xFF1A1A1A),
        child: const Icon(Icons.add, color: Color(0xFF00EE7C)),
      ),
    );
  }

  static final List<Map<String, dynamic>> _foodDatabase = [
    {'name': 'Chicken Breast', 'type': 'Protein', 'calories': 165, 'protein': 31, 'carbs': 0, 'fat': 4},
    {'name': 'Salmon', 'type': 'Protein', 'calories': 208, 'protein': 20, 'carbs': 0, 'fat': 13},
    {'name': 'Eggs', 'type': 'Protein', 'calories': 155, 'protein': 13, 'carbs': 1, 'fat': 11},
    {'name': 'Greek Yogurt', 'type': 'Protein', 'calories': 100, 'protein': 17, 'carbs': 6, 'fat': 0},
    {'name': 'Brown Rice', 'type': 'Carbs', 'calories': 216, 'protein': 5, 'carbs': 45, 'fat': 2},
    {'name': 'Sweet Potato', 'type': 'Carbs', 'calories': 112, 'protein': 2, 'carbs': 26, 'fat': 0},
    {'name': 'Oatmeal', 'type': 'Carbs', 'calories': 154, 'protein': 6, 'carbs': 27, 'fat': 3},
    {'name': 'Whole Wheat Bread', 'type': 'Carbs', 'calories': 82, 'protein': 4, 'carbs': 14, 'fat': 1},
    {'name': 'Quinoa', 'type': 'Carbs', 'calories': 222, 'protein': 8, 'carbs': 39, 'fat': 4},
    {'name': 'Avocado', 'type': 'Fat', 'calories': 240, 'protein': 3, 'carbs': 13, 'fat': 22},
    {'name': 'Almonds', 'type': 'Fat', 'calories': 164, 'protein': 6, 'carbs': 6, 'fat': 14},
    {'name': 'Olive Oil', 'type': 'Fat', 'calories': 119, 'protein': 0, 'carbs': 0, 'fat': 14},
    {'name': 'Peanut Butter', 'type': 'Fat', 'calories': 188, 'protein': 8, 'carbs': 7, 'fat': 16},
    {'name': 'Broccoli', 'type': 'Vegetable', 'calories': 55, 'protein': 4, 'carbs': 11, 'fat': 1},
    {'name': 'Spinach', 'type': 'Vegetable', 'calories': 23, 'protein': 3, 'carbs': 4, 'fat': 0},
    {'name': 'Carrots', 'type': 'Vegetable', 'calories': 41, 'protein': 1, 'carbs': 10, 'fat': 0},
    {'name': 'Tomatoes', 'type': 'Vegetable', 'calories': 22, 'protein': 1, 'carbs': 5, 'fat': 0},
    {'name': 'Banana', 'type': 'Fruit', 'calories': 105, 'protein': 1, 'carbs': 27, 'fat': 0},
    {'name': 'Apple', 'type': 'Fruit', 'calories': 95, 'protein': 0, 'carbs': 25, 'fat': 0},
    {'name': 'Blueberries', 'type': 'Fruit', 'calories': 84, 'protein': 1, 'carbs': 21, 'fat': 0},
    {'name': 'Strawberries', 'type': 'Fruit', 'calories': 49, 'protein': 1, 'carbs': 12, 'fat': 0},
    {'name': 'Orange', 'type': 'Fruit', 'calories': 62, 'protein': 1, 'carbs': 15, 'fat': 0},
    {'name': 'Turkey Breast', 'type': 'Protein', 'calories': 135, 'protein': 30, 'carbs': 0, 'fat': 1},
    {'name': 'Tuna', 'type': 'Protein', 'calories': 132, 'protein': 28, 'carbs': 0, 'fat': 1},
    {'name': 'Cottage Cheese', 'type': 'Protein', 'calories': 163, 'protein': 28, 'carbs': 6, 'fat': 2},
    {'name': 'Beef Steak', 'type': 'Protein', 'calories': 271, 'protein': 26, 'carbs': 0, 'fat': 18},
    {'name': 'Lentils', 'type': 'Carbs', 'calories': 230, 'protein': 18, 'carbs': 40, 'fat': 1},
    {'name': 'Chickpeas', 'type': 'Carbs', 'calories': 269, 'protein': 15, 'carbs': 45, 'fat': 4},
    {'name': 'Pasta', 'type': 'Carbs', 'calories': 220, 'protein': 8, 'carbs': 43, 'fat': 1},
    {'name': 'White Rice', 'type': 'Carbs', 'calories': 205, 'protein': 4, 'carbs': 45, 'fat': 0},
  ];

  void _showAddFoodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _AddFoodDialog(foods: _foodDatabase);
      },
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
              color: Color(0xFF00EE7C),
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
                  color: const Color(0xFF00EE7C).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  meal['type'],
                  style: const TextStyle(
                    color: Color(0xFF00EE7C),
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
          ],
        ),
      ),
    );
  }
}

class _AddFoodDialog extends StatefulWidget {
  final List<Map<String, dynamic>> foods;

  const _AddFoodDialog({required this.foods});

  @override
  State<_AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<_AddFoodDialog> {
  int _selectedTab = 0; // 0 for Saved, 1 for Search
  Map<String, dynamic>? _selectedFood;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'New meal',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Find your meal:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildTabButton('Saved', 0, Icons.bookmark_outline),
                const SizedBox(width: 10),
                _buildTabButton('Search', 1, Icons.search),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _selectedTab == 0
                  ? _buildSavedFoodsList(state)
                  : _buildSearchFoodsList(state),
            ),
            const SizedBox(height: 15),
            if (_selectedFood != null) ...[
              const Text(
                'Fat:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(
                '${_selectedFood!['fat']}g',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),
              const Text(
                'Carb:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(
                '${_selectedFood!['carbs']}g',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),
              const Text(
                'Protein:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(
                '${_selectedFood!['protein']}g',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _selectedFood == null
                    ? null
                    : () {
                        state.addMeal(
                          _selectedFood!['name'],
                          _selectedFood!['type'],
                          _selectedFood!['calories'],
                          _selectedFood!['protein'],
                          _selectedFood!['carbs'],
                          _selectedFood!['fat'],
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${_selectedFood!['name']} added to meals!'),
                            backgroundColor: const Color(0xFF00EE7C),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedFood == null ? Colors.grey : const Color(0xFF1A1A1A),
                  foregroundColor: const Color(0xFF00EE7C),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Finish',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int tabIndex, IconData icon) {
    final isSelected = _selectedTab == tabIndex;
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _selectedTab = tabIndex;
            _selectedFood = null;
          });
        },
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
          foregroundColor: isSelected ? const Color(0xFF00EE7C) : const Color(0xFF1A1A1A),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: isSelected ? const Color(0xFF1A1A1A) : Colors.grey[300]!),
          ),
        ),
      ),
    );
  }

  Widget _buildSavedFoodsList(AppState state) {
    final savedFoods = widget.foods
        .where((food) => state.isFoodSaved(food['name']))
        .toList();

    if (savedFoods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 15),
            Text(
              'No saved foods yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Save foods from Search to see them here',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: savedFoods.length,
      itemBuilder: (context, index) {
        final food = savedFoods[index];
        return _buildFoodItem(food, state);
      },
    );
  }

  Widget _buildSearchFoodsList(AppState state) {
    return ListView.builder(
      itemCount: widget.foods.length,
      itemBuilder: (context, index) {
        final food = widget.foods[index];
        return _buildFoodItem(food, state);
      },
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> food, AppState state) {
    final isSelected = _selectedFood == food;
    final isSaved = state.isFoodSaved(food['name']);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFood = food;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00EE7C).withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF00EE7C) : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food['name'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${food['calories']} kcal | P: ${food['protein']}g | C: ${food['carbs']}g | F: ${food['fat']}g',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                state.toggleSavedFood(food['name']);
              },
              icon: Icon(
                isSaved ? Icons.favorite : Icons.favorite_border,
                color: isSaved ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}