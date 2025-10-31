import 'package:flutter/material.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Child\'s Progress'),
              subtitle: const Text('View academic progress'),
              onTap: () {
                // TODO: Implement progress view
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Attendance'),
              subtitle: const Text('View attendance records'),
              onTap: () {
                // TODO: Implement attendance view
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.announcement),
              title: const Text('Announcements'),
              subtitle: const Text('View school announcements'),
              onTap: () {
                // TODO: Implement announcements
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              subtitle: const Text('Communicate with teachers'),
              onTap: () {
                // TODO: Implement messaging
              },
            ),
          ),
        ],
      ),
    );
  }
}