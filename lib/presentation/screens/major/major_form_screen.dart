import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/major_model.dart';
import '../../providers/major_provider.dart';

class MajorFormScreen extends StatefulWidget {
  final MajorModel? major; // null = Add, non-null = Edit

  const MajorFormScreen({super.key, this.major});

  @override
  State<MajorFormScreen> createState() => _MajorFormScreenState();
}

class _MajorFormScreenState extends State<MajorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;

  bool get isEdit => widget.major != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.major?.nameMajor ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Major' : 'Add Major'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Major Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(isEdit ? 'Update' : 'Add Major'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<MajorProvider>();
    bool success;

    if (isEdit) {
      success = await provider.updateMajor(
        widget.major!.copyWith(nameMajor: _nameCtrl.text.trim()),
      );
    } else {
      success = await provider.addMajor(
        MajorModel(nameMajor: _nameCtrl.text.trim()),
      );
    }

    if (success && mounted) Navigator.pop(context);
  }
}
