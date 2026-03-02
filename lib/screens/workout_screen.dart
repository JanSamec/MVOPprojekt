// screens/workout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Workout',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF1A1A1A)),
                    onPressed: () => _showEditGoalDialog(context, state),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Burned Calories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              _buildCaloriesCard(state),
              const SizedBox(height: 25),
              const Text(
                'Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              _buildTimeCard(state),
              const SizedBox(height: 25),
              const Text(
                'History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              _buildHistoryCard(state),
              const SizedBox(height: 25),
              _buildStartButton(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaloriesCard(AppState state) {
    double progress = state.totalCaloriesBurned / state.caloriesGoal;
    int percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${state.totalCaloriesBurned} kcal ',
                  style: const TextStyle(
                    color: Color(0xFF00EE7C),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'out of ${state.caloriesGoal} kcal   ',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                TextSpan(
                  text: "(today's goal)",
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '$percentage% done',
            style: const TextStyle(color: Color(0xFF00EE7C), fontSize: 16),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress > 1.0 ? 1.0 : progress,
              backgroundColor: const Color(0xFFF5F5F7),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00EE7C)),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(AppState state) {
    int hours = state.totalWorkoutTime ~/ 60;
    int minutes = state.totalWorkoutTime % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$hours hours $minutes minutes',
            style: const TextStyle(
              color: Color(0xFF00EE7C),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'out of ${state.workoutGoal ~/ 60} hours',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(AppState state) {
    if (state.workoutHistory.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'No workouts yet',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: state.workoutHistory.map((workout) {
          int hours = workout['duration'] ~/ 60;
          int minutes = workout['duration'] % 60;
          String timeStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    workout['name'],
                    style: const TextStyle(
                      color: Color(0xFF00EE7C),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    timeStr,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${workout['caloriesBurned']} kcal',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, AppState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showAddWorkoutDialog(context, state),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A1A),
          foregroundColor: const Color(0xFF00EE7C),
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Start new workout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showAddWorkoutDialog(BuildContext context, AppState state) {
    String? selectedActivity;
    int hours = 0;
    int minutes = 30;

    final activities = [
      'Running',
      'Walking',
      'Cycling',
      'Swimming',
      'Yoga',
      'Weight Training',
      'Dancing',
      'Hiking',
      'Jump Rope',
      'Rowing',
      'Basketball',
      'Soccer',
      'Tennis',
      'Boxing',
      'Pilates',
      'Aerobics',
      'Elliptical',
      'Stairs',
      'Push-ups',
      'Sit-ups',
    ];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Add Workout'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Activity', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedActivity,
                      hint: const Text('Select activity'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      items: activities.map((activity) {
                        return DropdownMenuItem(
                          value: activity,
                          child: Text(activity),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedActivity = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Duration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Hours', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<int>(
                                value: hours,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                items: List.generate(11, (index) => index).map((hour) {
                                  return DropdownMenuItem(
                                    value: hour,
                                    child: Text('$hour'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    hours = value ?? 0;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Minutes', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<int>(
                                value: minutes,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                items: [0, 15, 30, 45].map((min) {
                                  return DropdownMenuItem(
                                    value: min,
                                    child: Text('$min'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    minutes = value ?? 0;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedActivity != null) {
                      final totalMinutes = (hours * 60) + minutes;
                      if (totalMinutes > 0) {
                        final calories = state.calculateCaloriesForActivity(selectedActivity!, totalMinutes);
                        state.addWorkout(selectedActivity!, totalMinutes, calories);
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Workout added: $selectedActivity - $calories kcal'),
                            backgroundColor: const Color(0xFF00EE7C),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a duration greater than 0'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an activity'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    foregroundColor: const Color(0xFF00EE7C),
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditGoalDialog(BuildContext context, AppState state) {
    final calorieGoalController = TextEditingController(text: (state.caloriesGoal).toString());
    final timeGoalController = TextEditingController(text: (state.workoutGoal).toString());

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Edit Goals'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Daily calorie goal (kcal)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: calorieGoalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter calorie goal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Daily time goal (minutes)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: timeGoalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter time goal in minutes',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                bool updated = false;
                if (calorieGoalController.text.isNotEmpty) {
                  final calorieGoal = int.tryParse(calorieGoalController.text);
                  if (calorieGoal != null && calorieGoal > 0) {
                    state.updateWorkoutGoal(calorieGoal);
                    updated = true;
                  }
                }
                if (timeGoalController.text.isNotEmpty) {
                  final timeGoal = int.tryParse(timeGoalController.text);
                  if (timeGoal != null && timeGoal > 0) {
                    state.updateTimeGoal(timeGoal);
                    updated = true;
                  }
                }
                if (updated) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Goals updated successfully!'),
                      backgroundColor: Color(0xFF00EE7C),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: const Color(0xFF00EE7C),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}