import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;
  final VoidCallback onEdit;

  const StudentItem({
    super.key,
    required this.student,
    required this.onEdit,
  });

  Color _getBackgroundColorByGender(Gender gender) {
    return gender == Gender.male ? Colors.blue.shade50 : Colors.pink.shade50;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          student.department.icon,
          color: student.gender == Gender.male ? Colors.blue : Colors.pink,
          size: 30,
        ),
        title: Text(
          '${student.firstName} ${student.lastName}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Department: ${student.department.name}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Grade: ${student.grade}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_square),
          color: Colors.green,
          onPressed: onEdit,
        ),
      ),
    );
  }
}
