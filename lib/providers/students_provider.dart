import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier() : super([]);

  Student? _lastRemovedStudent;
  int? _lastRemovedIndex;

  void addStudent(Student student) {
    state = [...state, student];
  }

  void updateStudent(int index, Student updatedStudent) {
    final updatedList = [...state];
    updatedList[index] = updatedStudent;
    state = updatedList;
  }

  void removeStudent(int index) {
    _lastRemovedStudent = state[index];
    _lastRemovedIndex = index;

    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void undoRemoval() {
    if (_lastRemovedStudent != null && _lastRemovedIndex != null) {
      final updatedList = [...state];
      updatedList.insert(_lastRemovedIndex!, _lastRemovedStudent!);
      state = updatedList;

      _lastRemovedStudent = null;
      _lastRemovedIndex = null;
    }
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, List<Student>>((ref) {
  return StudentsNotifier();
});
