import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'teacher_dashboard.dart';
import 'parent_dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Your Role',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildRoleButton(
              context,
              'Admin',
              Icons.admin_panel_settings,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminDashboard()),
              ),
            ),
            const SizedBox(height: 16),
            _buildRoleButton(
              context,
              'Teacher',
              Icons.school,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeacherDashboard()),
              ),
            ),
            const SizedBox(height: 16),
            _buildRoleButton(
              context,
              'Parent',
              Icons.family_restroom,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParentDashboard()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(
    BuildContext context,
    String role,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        'Continue as $role',
        style: const TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}