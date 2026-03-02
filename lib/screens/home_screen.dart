import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const HomeScreen({Key? key, required this.onNavigateToTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              _buildWeekActivity(state),
              const SizedBox(height: 30),
              _buildMetricsGrid(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekActivity(AppState state) {
    int activeDays = state.weekActivity.where((d) => d['hours'] > 0).length;
    int totalHours = state.weekActivity.fold(0, (sum, day) => sum + (day['hours'] as int));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('This Week', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text('$activeDays/7 Days', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: state.weekActivity.map((day) {
            return _buildDayIndicator(day['day'], day['hours'] > 0);
          }).toList(),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Hours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text('$totalHours hours', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: state.weekActivity.map((day) {
            return _buildHourBar(day['day'], day['hours']);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDayIndicator(String day, bool active) {
    return Container(
      width: 45,
      height: 70,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF1A1A1A) : Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey[400],
              fontSize: 12,
            ),
          ),
          if (active)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Icon(Icons.check, color: Color(0xFF00EE7C), size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildHourBar(String day, int hours) {
    return Column(
      children: [
        Container(
          width: 40,
          height: hours * 30.0,
          decoration: BoxDecoration(
            color: hours > 0 ? const Color(0xFF1A1A1A) : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: hours > 0
              ? Center(
                  child: Text(
                    '${hours}hr',
                    style: const TextStyle(color: Color(0xFF00EE7C), fontSize: 12),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 8),
        Text(day, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildMetricsGrid(BuildContext context, AppState state) {
    int sleepHours = state.todaySleepMinutes ~/ 60;
    int sleepMinutes = state.todaySleepMinutes % 60;
    int workoutHours = state.totalWorkoutTime ~/ 60;
    int workoutMinutes = state.totalWorkoutTime % 60;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1,
      children: [
        _buildMetricCard(
          context,
          'Calories gained',
          '${state.totalCaloriesFromMeals} kcal',
          '${state.totalProteinFromMeals}g protein\n${state.totalCarbsFromMeals}g carbs\n${state.totalFatFromMeals}g fat',
          Icons.lunch_dining,
          showArrow: true,
          onTap: () => onNavigateToTab(1),
        ),
        _buildMetricCard(
          context,
          'Calories burned',
          '${state.totalCaloriesBurned} kcal',
          'Total workout time:\n$workoutHours hours $workoutMinutes minutes',
          Icons.fitness_center,
          showArrow: true,
          onTap: () => onNavigateToTab(2),
        ),
        _buildMetricCard(
          context,
          'Water Intake',
          '${state.waterIntake.toStringAsFixed(1)} liters',
          '${(state.waterIntake * 100).toInt()}% out of daily goal',
          Icons.water_drop_outlined,
          showArrow: false,
        ),
        _buildMetricCard(
          context,
          'Sleep',
          sleepHours > 0 || sleepMinutes > 0 ? '${sleepHours}h ${sleepMinutes}m' : '0h 0m',
          '',
          Icons.bedtime_outlined,
          showArrow: true,
          onTap: () => onNavigateToTab(3),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    String details,
    IconData icon, {
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Faded background icon
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    icon,
                    color: Colors.white.withValues(alpha: 0.08),
                    size: 76,
                  ),
                ),
              ),
              // Card content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(color: Colors.white, fontSize: 13)),
                        if (showArrow)
                          const Icon(Icons.arrow_forward_ios, color: Color(0xFF00EE7C), size: 16),
                      ],
                    ),
                    const Spacer(),
                    if (details.isNotEmpty) ...[
                      Text(
                        details,
                        style: TextStyle(color: Colors.grey[400], fontSize: 10, height: 1.3),
                      ),
                      const SizedBox(height: 6),
                    ],
                    Text(
                      value,
                      style: const TextStyle(
                        color: Color(0xFF00EE7C),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

