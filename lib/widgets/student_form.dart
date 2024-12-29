import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';

class StudentForm extends ConsumerStatefulWidget {
  const StudentForm({
    super.key,
    this.studentIndex
  });

  final int? studentIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentFormState();
}

class _StudentFormState extends ConsumerState<StudentForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _selectedDepartmentId = predefinedDepartments[0].id;
  Gender _selectedGender = Gender.male;
  int _grade = 0;

  @override
  void initState() {
    super.initState();
    if (widget.studentIndex != null) {
      final student = ref.read(studentsProvider).docs[widget.studentIndex!];
      _firstNameController.text = student.firstName;
      _lastNameController.text = student.lastName;
      _grade = student.grade;
      _selectedGender = student.gender;
      _selectedDepartmentId = student.departmentId;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _saveStudent() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _selectedDepartmentId == null ||
        _selectedGender == null) {
      return;
    }

    if (widget.studentIndex != null) {
      await ref.read(studentsProvider.notifier).updateStudent(
            widget.studentIndex!,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartmentId,
            _selectedGender,
            _grade,
          );
    } else {
      await ref.read(studentsProvider.notifier).addStudent(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartmentId,
            _selectedGender,
            _grade,
          );
    }

    if (!context.mounted) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Ім’я',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Прізвище',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDepartmentId,
                  decoration: const InputDecoration(
                    labelText: 'Факультет',
                    border: OutlineInputBorder(),
                  ),
                  items: predefinedDepartments.map((department) {
                    return DropdownMenuItem(
                      value: department.id,
                      child: Row(
                        children: [
                          Icon(department.icon, size: 20),
                          const SizedBox(width: 10),
                          Text(department.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedDepartmentId = value!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Gender>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Стать',
                    border: OutlineInputBorder(),
                  ),
                  items: Gender.values.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedGender = value!),
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _grade.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  activeColor: Colors.yellow, 
                  label: 'Оцінка: $_grade',
                  onChanged: (value) => setState(() => _grade = value.toInt()),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Скасувати'),
                    ),
                    ElevatedButton(
                      onPressed: _saveStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(widget.studentIndex == null ? 'Зберегти' : 'Оновити'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
