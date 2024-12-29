import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsState {
  final List<Student> docs;
  final bool load;
  final String? exc;

  StudentsState({
    required this.docs,
    required this.load,
    this.exc,
  });

  StudentsState copyWith({
    List<Student>? students,
    bool? isLoading,
    String? errorMessage,
  }) {
    return StudentsState(
      docs: students ?? this.docs,
      load: isLoading ?? this.load,
      exc: errorMessage ?? this.exc,
    );
  }
}

class StudentsNotifier extends StateNotifier<StudentsState> {
  StudentsNotifier() : super(StudentsState(docs: [], load: false));

  Student? _lastRemovedStudent;
  int? _lastRemovedIndex;

  Future<void> loadStudents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final students = await Student.remoteGetList();
      state = state.copyWith(students: students, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addStudent(
    String firstName,
    String lastName,
    departmentId,
    gender,
    int grade,
  ) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final student = await Student.remoteCreate(
          firstName, lastName, departmentId, gender, grade);
      state = state.copyWith(
        students: [...state.docs, student],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateStudent(
    int index,
    String firstName,
    String lastName,
    departmentId,
    gender,
    int grade,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedStudent = await Student.remoteUpdate(
        state.docs[index].id,
        firstName,
        lastName,
        departmentId,
        gender,
        grade,
      );
      final updatedList = [...state.docs];
      updatedList[index] = updatedStudent;
      state = state.copyWith(students: updatedList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void removeStudent(int index) {
    _lastRemovedStudent = state.docs[index];
    _lastRemovedIndex = index;
    final updatedList = [...state.docs];
    updatedList.removeAt(index);
    state = state.copyWith(students: updatedList);
  }

  void undoRemoval() {
    if (_lastRemovedStudent != null && _lastRemovedIndex != null) {
      final updatedList = [...state.docs];
      updatedList.insert(_lastRemovedIndex!, _lastRemovedStudent!);
      state = state.copyWith(students: updatedList);
    }
  }

  Future<void> removeForewer() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (_lastRemovedStudent != null) {
        await Student.remoteDelete(_lastRemovedStudent!.id);
        _lastRemovedStudent = null;
        _lastRemovedIndex = null;
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, StudentsState>((ref) {
  final notifier = StudentsNotifier();
  notifier.loadStudents();
  return notifier;
});
