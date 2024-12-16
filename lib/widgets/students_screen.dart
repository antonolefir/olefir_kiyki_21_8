import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';
import 'new_student.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> students = [
    Student(
      firstName: 'Андрій',
      lastName: 'Коваленко',
      department: Department.it,
      grade: 85,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Марія',
      lastName: 'Шевченко',
      department: Department.finance,
      grade: 92,
      gender: Gender.female,
    ),
  ];

  void _addOrEditStudent({Student? student, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewStudent(
          student: student,
          onSave: (newStudent) {
            setState(() {
              if (index == null) {
                students.add(newStudent);
              } else {
                students[index] = newStudent;
              }
            });
          },
        );
      },
    );
  }

  void _deleteStudent(Student student, int index) {
    final removedStudent = students[index];
    setState(() => students.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Студента видалено'),
        action: SnackBarAction(
          label: 'Відмінити',
          onPressed: () {
            setState(() => students.insert(index, removedStudent));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список студентів'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Dismissible(
            key: ValueKey(student),
            background: Container(color: Colors.red),
            onDismissed: (_) => _deleteStudent(student, index),
            child: InkWell(
              onTap: () => _addOrEditStudent(student: student, index: index),
              child: StudentItem(student: student),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditStudent(),
        backgroundColor: Colors.purple,
        label: const Text('Додати студента'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
