import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import '../widgets/student_item.dart';
import '../widgets/student_form.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список студентів'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => StudentForm(
                  onSave: (newStudent) {
                    ref.read(studentsProvider.notifier).addStudent(newStudent);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: students.isEmpty
          ? const Center(
              child: Text(
                'Немає студентів',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];

                return Dismissible(
                  key: ValueKey(student.id),
                  background: Container(
                    color: Colors.red.shade400,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red.shade400,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onDismissed: (_) {
                    ref.read(studentsProvider.notifier).removeStudent(index);
                    final container = ProviderScope.containerOf(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${student.firstName} ${student.lastName} видалено',
                        ),
                        action: SnackBarAction(
                          label: 'Відмінити',
                          onPressed: () {
                            container
                                .read(studentsProvider.notifier)
                                .undoRemoval();
                          },
                        ),
                      ),
                    );
                  },
                  child: StudentItem(
                    student: student,
                    onEdit: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => StudentForm(
                          student: student,
                          onSave: (updatedStudent) {
                            ref
                                .read(studentsProvider.notifier)
                                .updateStudent(index, updatedStudent);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
