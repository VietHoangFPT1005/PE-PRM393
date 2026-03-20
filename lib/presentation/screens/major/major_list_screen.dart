import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/major_provider.dart';
import '../../providers/student_provider.dart';
import '../../../data/models/major_model.dart';
import 'major_form_screen.dart';

class MajorListScreen extends StatefulWidget {
  const MajorListScreen({super.key});

  @override
  State<MajorListScreen> createState() => _MajorListScreenState();
}

class _MajorListScreenState extends State<MajorListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MajorProvider>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MajorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Majors')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context, null),
        child: const Icon(Icons.add),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.majors.isEmpty
              ? const Center(child: Text('No majors found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: provider.majors.length,
                  itemBuilder: (context, index) {
                    final major = provider.majors[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${major.idMajor}'),
                        ),
                        title: Text(major.nameMajor),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _openForm(context, major),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, major),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _openForm(BuildContext context, MajorModel? major) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MajorFormScreen(major: major)),
    ).then((_) => context.read<MajorProvider>().fetchAll());
  }

  void _confirmDelete(BuildContext context, MajorModel major) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Major'),
        content: Text('Delete "${major.nameMajor}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<MajorProvider>().deleteMajor(major.idMajor!);
              if (context.mounted) {
                context.read<StudentProvider>().fetchAll();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
