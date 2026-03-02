import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppState extends ChangeNotifier {
  int caloriesBurned = 0;
  int caloriesGoal = 800;
  int workoutMinutes = 0;
  int workoutGoal = 180;

  int caloriesGained = 0;
  double waterIntake = 0.0;
  int sleepMinutes = 0;
  int sleepGoal = 480;

  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  int age = 0;

  List<Map<String, dynamic>> weekActivity = [
    {'day': 'Sun', 'hours': 0},
    {'day': 'Mon', 'hours': 0},
    {'day': 'Tue', 'hours': 0},
    {'day': 'Wed', 'hours': 0},
    {'day': 'Thu', 'hours': 0},
    {'day': 'Fri', 'hours': 0},
    {'day': 'Sat', 'hours': 0},
  ];

  List<Map<String, dynamic>> weekSleep = [
    {'day': 'Sun', 'hours': 0},
    {'day': 'Mon', 'hours': 0},
    {'day': 'Tue', 'hours': 0},
    {'day': 'Wed', 'hours': 0},
    {'day': 'Thu', 'hours': 0},
    {'day': 'Fri', 'hours': 0},
    {'day': 'Sat', 'hours': 0},
  ];

  List<Map<String, dynamic>> workoutHistory = [];

  List<Map<String, dynamic>> sleepHistory = [];

  List<Map<String, dynamic>> meals = [];

  Set<String> savedFoods = {};

  bool hasMealPlan = false;
  String userName = '';
  String bedtime = '11:00 PM';
  String wakeTime = '7:00 AM';

  String get fullName => '$firstName $lastName';

  int get totalCaloriesFromMeals {
    if (meals.isEmpty) return 0;
    return meals.fold(0, (sum, meal) => sum + (meal['calories'] as int));
  }

  int get totalProteinFromMeals {
    if (meals.isEmpty) return 0;
    return meals.fold(0, (sum, meal) => sum + (meal['protein'] as int));
  }

  int get totalCarbsFromMeals {
    if (meals.isEmpty) return 0;
    return meals.fold(0, (sum, meal) => sum + (meal['carbs'] as int));
  }

  int get totalFatFromMeals {
    if (meals.isEmpty) return 0;
    return meals.fold(0, (sum, meal) => sum + (meal['fat'] as int));
  }

  int get totalWorkoutTime {
    if (workoutHistory.isEmpty) return 0;
    return workoutHistory.fold(0, (sum, workout) => sum + (workout['duration'] as int));
  }

  int get totalCaloriesBurned {
    if (workoutHistory.isEmpty) return 0;
    return workoutHistory.fold(0, (sum, workout) => sum + (workout['caloriesBurned'] as int));
  }

  int get todaySleepMinutes {
    if (sleepHistory.isEmpty) return 0;
    return sleepHistory.last['duration'] as int;
  }

  Future<void> loadUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    if (data != null) {
      final fullName = data['fullName'] as String? ?? '';
      final parts = fullName.trim().split(' ');
      firstName = parts.isNotEmpty ? parts.first : '';
      lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      email = data['email'] as String? ?? '';
      age = data['age'] as int? ?? 0;
      userName = firstName;
      notifyListeners();
    }
  }

  void updateProfile(String first, String last, String mail, String phone) {
    firstName = first;
    lastName = last;
    email = mail;
    phoneNumber = phone;
    userName = first;
    notifyListeners();
  }

  void updateCaloriesBurned(int value) {
    caloriesBurned = value;
    notifyListeners();
  }

  void updateWaterIntake(double value) {
    waterIntake = value;
    notifyListeners();
  }

  void clearMealPlan() {
    hasMealPlan = false;
    notifyListeners();
  }

  void generateMealPlan() {
    hasMealPlan = true;
    notifyListeners();
  }

  void addWorkout(String activity, int duration, int calories) {
    workoutHistory.add({
      'name': activity,
      'duration': duration,
      'caloriesBurned': calories,
      'timestamp': DateTime.now(),
    });
    workoutMinutes = totalWorkoutTime;
    caloriesBurned = totalCaloriesBurned;
    _updateWeekActivity();
    notifyListeners();
  }

  void _updateWeekActivity() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    for (var i = 0; i < weekActivity.length; i++) {
      final dayDate = startOfWeek.add(Duration(days: i));
      final dayWorkouts = workoutHistory.where((workout) {
        final workoutDate = workout['timestamp'] as DateTime;
        return workoutDate.year == dayDate.year &&
            workoutDate.month == dayDate.month &&
            workoutDate.day == dayDate.day;
      });

      final totalMinutes = dayWorkouts.fold(0, (sum, workout) => sum + (workout['duration'] as int));
      weekActivity[i]['hours'] = (totalMinutes / 60).round();
    }
  }

  void updateWorkoutGoal(int newGoal) {
    caloriesGoal = newGoal;
    notifyListeners();
  }

  void updateTimeGoal(int newGoal) {
    workoutGoal = newGoal;
    notifyListeners();
  }

  void updateSleepGoal(int newGoal) {
    sleepGoal = newGoal;
    notifyListeners();
  }

  void addSleepRecord(int duration, String from, String to) {
    sleepHistory.add({
      'duration': duration,
      'from': from,
      'to': to,
      'timestamp': DateTime.now(),
    });
    sleepMinutes = todaySleepMinutes;
    _updateWeekSleep();
    notifyListeners();
  }

  void _updateWeekSleep() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    for (var i = 0; i < weekSleep.length; i++) {
      final dayDate = startOfWeek.add(Duration(days: i));
      final daySleep = sleepHistory.where((sleep) {
        final sleepDate = sleep['timestamp'] as DateTime;
        return sleepDate.year == dayDate.year &&
            sleepDate.month == dayDate.month &&
            sleepDate.day == dayDate.day;
      });

      final totalMinutes = daySleep.fold(0, (sum, sleep) => sum + (sleep['duration'] as int));
      weekSleep[i]['hours'] = (totalMinutes / 60).round();
    }
  }

  void updateBedtime(String time) {
    bedtime = time;
    notifyListeners();
  }

  void updateWakeTime(String time) {
    wakeTime = time;
    notifyListeners();
  }

  int calculateCaloriesForActivity(String activity, int durationMinutes) {
    final caloriesPerMinute = {
      'Running': 11.4,
      'Walking': 4.0,
      'Cycling': 8.0,
      'Swimming': 11.0,
      'Yoga': 3.0,
      'Weight Training': 6.0,
      'Dancing': 5.5,
      'Hiking': 6.0,
      'Jump Rope': 12.3,
      'Rowing': 9.0,
      'Basketball': 8.0,
      'Soccer': 9.0,
      'Tennis': 7.0,
      'Boxing': 10.0,
      'Pilates': 4.0,
      'Aerobics': 7.0,
      'Elliptical': 8.5,
      'Stairs': 9.0,
      'Push-ups': 8.0,
      'Sit-ups': 5.0,
    };

    final rate = caloriesPerMinute[activity] ?? 5.0;
    return (rate * durationMinutes).round();
  }

  void addMeal(String name, String type, int calories, int protein, int carbs, int fat) {
    meals.add({
      'name': name,
      'type': type,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'timestamp': DateTime.now(),
    });
    caloriesGained = totalCaloriesFromMeals;
    notifyListeners();
  }

  void toggleSavedFood(String foodName) {
    if (savedFoods.contains(foodName)) {
      savedFoods.remove(foodName);
    } else {
      savedFoods.add(foodName);
    }
    notifyListeners();
  }

  bool isFoodSaved(String foodName) {
    return savedFoods.contains(foodName);
  }
}