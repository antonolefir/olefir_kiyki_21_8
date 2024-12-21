import 'package:flutter/material.dart';

class Department {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const Department({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

const predefinedDepartments = [
  Department(
    id: 'finance',
    name: 'Фінанси',
    icon: Icons.monetization_on_outlined,
    color: Colors.green,
  ),
  Department(
    id: 'law',
    name: 'Право',
    icon: Icons.balance,
    color: Colors.blue,
  ),
  Department(
    id: 'it',
    name: 'Інформаційні Технології',
    icon: Icons.laptop_mac,
    color: Colors.indigo,
  ),
  Department(
    id: 'medical',
    name: 'Медицина',
    icon: Icons.medical_services_outlined,
    color: Colors.redAccent,
  ),
];
