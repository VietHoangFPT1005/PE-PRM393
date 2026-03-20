import 'package:flutter/material.dart';
import '../../../data/models/student_model.dart';
import '../map/map_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  final StudentModel student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(student.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Name'),
            subtitle: Text(student.name),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Major'),
            subtitle: Text(student.major?.nameMajor ?? '-'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Date of Birth'),
            subtitle: Text(student.date ?? '-'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Gender'),
            subtitle: Text(student.gender ?? '-'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Email'),
            subtitle: Text(student.email ?? '-'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Phone'),
            subtitle: Text(student.phone ?? '-'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Address'),
            subtitle: Text(student.address ?? '-'),
          ),
          const Divider(height: 1),
          if (student.address != null && student.address!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapScreen(
                      address: student.address!,
                      name: student.name,
                    ),
                  ),
                ),
                child: const Text('View on Map'),
              ),
            ),
        ],
      ),
    );
  }
}
