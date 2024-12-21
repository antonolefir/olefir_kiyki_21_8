import 'package:flutter/material.dart';
import 'departments_screen.dart';
import 'students_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DepartmentsScreen(),
    const StudentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Факультети',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Студенти',
          ),
        ],
      ),
    );
  }
}
