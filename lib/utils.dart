  import '../models/department.dart';

  Department getDepartmentById(String id) {
    return predefinedDepartments.firstWhere(
      (department) => department.id == id,
      orElse: () => predefinedDepartments.first,
    );
  }
