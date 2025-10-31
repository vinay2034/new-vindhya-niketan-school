import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/stat_card.dart';
import '../widgets/line_chart_widget.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: MediaQuery.of(context).size.width < 600 ? 1.8 : 1.6,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Row 1
                StatCard(
                  title: "Total Students",
                  value: '450',
                  subValue: '50 new this month',
                  icon: Icons.people,
                ),
                StatCard(
                  title: 'Total Teachers',
                  value: '30',
                  subValue: '5 new this month',
                  icon: Icons.school,
                ),
                StatCard(
                  title: 'Revenue',
                  value: '\$45,500',
                  subValue: '+12% this month',
                  icon: Icons.payments,
                ),
                StatCard(
                  title: 'Attendance',
                  value: '95%',
                  subValue: 'Average this week',
                  icon: Icons.calendar_today,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Charts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            LineChartWidget(
              title: 'Student Enrollment',
              lineColor: Colors.purple,
              spots: [
                const FlSpot(0, 4),
                const FlSpot(1, 3.5),
                const FlSpot(2, 4.5),
                const FlSpot(3, 4),
              ],
            ),
            const SizedBox(height: 16),
            LineChartWidget(
              title: 'Attendance Rate',
              lineColor: Colors.blue,
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 4),
                const FlSpot(2, 3.5),
                const FlSpot(3, 5),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Teachers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}