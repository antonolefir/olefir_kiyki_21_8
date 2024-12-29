import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/department.dart';
import '../providers/students_provider.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentState = ref.watch(studentsProvider);

    if (currentState.load) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Факультети')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: predefinedDepartments.length,
        itemBuilder: (context, index) {
          final department = predefinedDepartments[index];
          final studentCount = currentState.docs
              .where((student) => student.departmentId == department.id)
              .length;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [department.color.withOpacity(0.7), department.color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(department.icon, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  department.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$studentCount студентів',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
