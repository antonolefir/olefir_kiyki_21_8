import 'package:flutter/material.dart';
import 'package:olefir_kiyki_21_8/models/department.dart';
import 'package:olefir_kiyki_21_8/utils.dart';
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
    return gender == Gender.male ? Colors.blue : Colors.pink;
  }

  @override
  Widget build(BuildContext context) {
    Department currentDepartment = getDepartmentById(student.departmentId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          currentDepartment.icon,
          color: _getBackgroundColorByGender(student.gender),
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
              'Department: ${currentDepartment.name}',
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
