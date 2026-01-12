// screens/sleep_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({Key? key}) : super(key: key);

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
                    'Sleep',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () => _showEditGoalDialog(context, state),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Time slept today',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              _buildSleepCard(state),
              const SizedBox(height: 25),
              const Text(
                'This week',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              _buildWeekChart(state),
              const SizedBox(height: 30),
              _buildTimeSettings(context, state),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepCard(AppState state) {
    int hours = state.todaySleepMinutes ~/ 60;
    int minutes = state.todaySleepMinutes % 60;
    int goalHours = state.sleepGoal ~/ 60;
    double progress = state.todaySleepMinutes / state.sleepGoal;
    int percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$hours hours $minutes minutes',
            style: const TextStyle(
              color: Color(0xFF00FF88),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'goal: $goalHours hours',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 15),
          Text(
            '$percentage% done',
            style: const TextStyle(color: Color(0xFF00FF88), fontSize: 16),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress > 1.0 ? 1.0 : progress,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00FF88)),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekChart(AppState state) {
    int maxHours = 8;
    bool hasData = state.weekSleep.any((day) => day['hours'] > 0);

    if (!hasData) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            'No information for this week',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: state.weekSleep.map((day) {
          int hours = day['hours'];
          double height = hours > 0 ? (hours / maxHours) * 200 : 40;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 40,
                height: height,
                decoration: BoxDecoration(
                  color: hours > 0 ? Colors.black : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: hours > 0
                    ? Center(
                        child: Text(
                          '${hours}hr',
                          style: const TextStyle(
                            color: Color(0xFF00FF88),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 10),
              Text(
                day['day'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeSettings(BuildContext context, AppState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bedtime',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        state.bedtime,
                        style: const TextStyle(
                          color: Color(0xFF00FF88),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wake time',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        state.wakeTime,
                        style: const TextStyle(
                          color: Color(0xFF00FF88),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showSuggestTimeDialog(context, state),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Suggest time',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF00FF88), size: 26),
                onPressed: () => _showAddSleepDialog(context, state),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddSleepDialog(BuildContext context, AppState state) {
    TimeOfDay bedtime = const TimeOfDay(hour: 23, minute: 0);
    TimeOfDay wakeTime = const TimeOfDay(hour: 7, minute: 0);
    int hours = 8;
    int minutes = 0;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Add Sleep Record'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sleep duration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
                                items: List.generate(13, (index) => index).map((hour) {
                                  return DropdownMenuItem(
                                    value: hour,
                                    child: Text('$hour'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    hours = value ?? 8;
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
                    const SizedBox(height: 20),
                    const Text('From', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: bedtime,
                        );
                        if (picked != null) {
                          setState(() {
                            bedtime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(bedtime.format(context)),
                            const Icon(Icons.access_time, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('To', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: wakeTime,
                        );
                        if (picked != null) {
                          setState(() {
                            wakeTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(wakeTime.format(context)),
                            const Icon(Icons.access_time, color: Colors.grey),
                          ],
                        ),
                      ),
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
                    final totalMinutes = (hours * 60) + minutes;
                    if (totalMinutes > 0) {
                      state.addSleepRecord(
                        totalMinutes,
                        bedtime.format(context),
                        wakeTime.format(context),
                      );
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sleep record added: ${hours}h ${minutes}m'),
                          backgroundColor: const Color(0xFF00FF88),
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
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: const Color(0xFF00FF88),
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
    final goalController = TextEditingController(text: (state.sleepGoal ~/ 60).toString());

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Edit Sleep Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Daily sleep goal (hours)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: goalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter sleep goal',
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
                if (goalController.text.isNotEmpty) {
                  final goalHours = int.tryParse(goalController.text);
                  if (goalHours != null && goalHours > 0) {
                    state.updateSleepGoal(goalHours * 60);
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sleep goal updated successfully!'),
                        backgroundColor: Color(0xFF00FF88),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: const Color(0xFF00FF88),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSuggestTimeDialog(BuildContext context, AppState state) {
    String? suggestionType;
    final timeController = TextEditingController();
    String suggestedTime = '';

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Suggest Time'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('What would you like to calculate?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: suggestionType,
                      hint: const Text('Select option'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'bedtime', child: Text('Suggest bedtime')),
                        DropdownMenuItem(value: 'wakeup', child: Text('Suggest wakeup time')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          suggestionType = value;
                          suggestedTime = '';
                        });
                      },
                    ),
                    if (suggestionType != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        suggestionType == 'bedtime' ? 'Desired wake time (e.g., 7:00 AM)' : 'Desired bedtime (e.g., 11:00 PM)',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: timeController,
                        decoration: InputDecoration(
                          hintText: 'Enter time',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (timeController.text.isNotEmpty) {
                            final goalHours = state.sleepGoal ~/ 60;
                            setState(() {
                              if (suggestionType == 'bedtime') {
                                suggestedTime = 'Based on ${goalHours}h sleep goal, suggested bedtime: Calculate $goalHours hours before ${timeController.text}';
                              } else {
                                suggestedTime = 'Based on ${goalHours}h sleep goal, suggested wake time: Calculate $goalHours hours after ${timeController.text}';
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FF88),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Calculate'),
                      ),
                      if (suggestedTime.isNotEmpty) ...[
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            suggestedTime,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Close', style: TextStyle(color: Colors.grey)),
                ),
                if (suggestedTime.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      if (suggestionType == 'bedtime') {
                        state.updateBedtime(timeController.text);
                      } else {
                        state.updateWakeTime(timeController.text);
                      }
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Time updated successfully!'),
                          backgroundColor: Color(0xFF00FF88),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: const Color(0xFF00FF88),
                    ),
                    child: const Text('Apply'),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}