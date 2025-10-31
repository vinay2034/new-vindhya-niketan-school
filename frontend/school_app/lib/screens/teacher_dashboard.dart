import 'package:flutter/material.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Class Schedule'),
              subtitle: const Text('View and manage your class schedule'),
              onTap: () {
                // TODO: Implement schedule view
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Student List'),
              subtitle: const Text('View and manage students'),
              onTap: () {
                // TODO: Implement student list
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Attendance'),
              subtitle: const Text('Mark and view attendance'),
              onTap: () {
                // TODO: Implement attendance
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.grade),
              title: const Text('Grades'),
              subtitle: const Text('Manage student grades'),
              onTap: () {
                // TODO: Implement grades
              },
            ),
          ),
        ],
      ),
    );
  }
}