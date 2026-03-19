// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:khidma/mock/mock_data.dart';
import 'package:khidma/models/order.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Order> pendingJobs = [];
  List<Order> completedJobs = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initializing the tasks
    pendingJobs = mockHelperJobs
        .where((task) => task.status == 'pending')
        .toList();
    completedJobs = mockHelperEarnings
        .where((task) => task.status == 'completed')
        .toList();
  }

  // Add a new task
  void _addTask(String title, double price) {
    setState(() {
      final newTask = Order(
        id: 'new${pendingJobs.length + 1}',
        title: title,
        location: 'مكان غير محدد',
        dateTime: DateTime.now(),
        price: price,
        status: 'pending',
      );
      pendingJobs.add(newTask);
    });
  }

  // Toggle the task status (from pending to completed or vice versa)
  void _toggleTaskStatus(Order task) {
    setState(() {
      if (task.status == 'pending') {
        // Move to completed
        final updatedTask = Order(
          id: task.id,
          title: task.title,
          location: task.location,
          dateTime: task.dateTime,
          price: task.price,
          status: 'completed',
          isUrgent: task.isUrgent,
          progressPhotos: task.progressPhotos,
          clientId: task.clientId,
          helperId: task.helperId,
        );
        completedJobs.insert(0, updatedTask);
        pendingJobs.remove(task);
      } else {
        // Move to pending
        final updatedTask = Order(
          id: task.id,
          title: task.title,
          location: task.location,
          dateTime: task.dateTime,
          price: task.price,
          status: 'pending',
          isUrgent: task.isUrgent,
          progressPhotos: task.progressPhotos,
          clientId: task.clientId,
          helperId: task.helperId,
        );
        pendingJobs.add(updatedTask);
        completedJobs.remove(task);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المهام'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Show a dialog to add a new task
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('إضافة مهمة جديدة'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            labelText: 'عنوان المهمة',
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'السعر'),
                          onChanged: (value) {
                            // Here you can add validation if needed
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          final taskTitle = _taskController.text;
                          final taskPrice =
                              double.tryParse(_taskController.text) ?? 0.0;

                          if (taskTitle.isNotEmpty && taskPrice > 0) {
                            _addTask(taskTitle, taskPrice);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('إضافة'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('إلغاء'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // عرض المهام المعلقة
            if (pendingJobs.isNotEmpty) ...[
              const Text('المهام المعلقة', style: TextStyle(fontSize: 18)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: pendingJobs.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(pendingJobs[index].title),
                      subtitle: Text(
                        '${pendingJobs[index].location} - ${pendingJobs[index].dateTime}',
                      ),
                      trailing: Text('${pendingJobs[index].price} ج.م'),
                      onTap: () {
                        _toggleTaskStatus(pendingJobs[index]);
                      },
                    ),
                  );
                },
              ),
            ],
            // عرض المهام المنتهية
            if (completedJobs.isNotEmpty) ...[
              const Text('المهام المنتهية', style: TextStyle(fontSize: 18)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: completedJobs.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(completedJobs[index].title),
                      subtitle: Text(
                        '${completedJobs[index].location} - ${completedJobs[index].dateTime}',
                      ),
                      trailing: Text('${completedJobs[index].price} ج.م'),
                      onTap: () {
                        _toggleTaskStatus(completedJobs[index]);
                      },
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
