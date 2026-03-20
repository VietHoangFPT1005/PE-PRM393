import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../../data/models/student_model.dart';
import '../../widgets/student_card.dart';
import 'student_form_screen.dart';
import 'student_detail_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context, null),
        child: const Icon(Icons.add),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.students.isEmpty
              ? const Center(child: Text('No students found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: provider.students.length,
                  itemBuilder: (context, index) {
                    final student = provider.students[index];
                    return StudentCard(
                      student: student,
                      onTap: () => _openDetail(context, student),
                      onEdit: () => _openForm(context, student),
                      onDelete: () => _confirmDelete(context, student),
                    );
                  },
                ),
    );
  }

  void _openDetail(BuildContext context, StudentModel student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StudentDetailScreen(student: student)),
    );
  }

  void _openForm(BuildContext context, StudentModel? student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StudentFormScreen(student: student)),
    ).then((_) => context.read<StudentProvider>().fetchAll());
  }

  void _confirmDelete(BuildContext context, StudentModel student) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Delete "${student.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context
                  .read<StudentProvider>()
                  .deleteStudent(student.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
