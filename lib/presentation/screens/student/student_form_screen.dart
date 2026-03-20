import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/major_model.dart';
import '../../providers/student_provider.dart';
import '../../providers/major_provider.dart';

class StudentFormScreen extends StatefulWidget {
  final StudentModel? student;

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _dateCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;

  String? _selectedGender;
  MajorModel? _selectedMajor;

  final _genders = ['Male', 'Female', 'Other'];

  bool get isEdit => widget.student != null;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _dateCtrl = TextEditingController(text: s?.date ?? '');
    _emailCtrl = TextEditingController(text: s?.email ?? '');
    _addressCtrl = TextEditingController(text: s?.address ?? '');
    _phoneCtrl = TextEditingController(text: s?.phone ?? '');
    _selectedGender = s?.gender;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<MajorProvider>().fetchAll();
      if (isEdit && mounted) {
        final majors = context.read<MajorProvider>().majors;
        setState(() {
          _selectedMajor = majors.firstWhere(
            (m) => m.idMajor == widget.student!.idMajor,
            orElse: () => majors.isNotEmpty ? majors.first : MajorModel(nameMajor: ''),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dateCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final majors = context.watch<MajorProvider>().majors;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Student' : 'Add Student')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_nameCtrl, 'Full Name', required: true),
              const SizedBox(height: 12),
              // Date picker
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1980),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _dateCtrl.text =
                        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              const SizedBox(height: 12),
              // Gender dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: _genders
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedGender = v),
              ),
              const SizedBox(height: 12),
              _field(_emailCtrl, 'Email'),
              const SizedBox(height: 12),
              _field(_addressCtrl, 'Address'),
              const SizedBox(height: 12),
              _field(_phoneCtrl, 'Phone'),
              const SizedBox(height: 12),
              // Major dropdown
              DropdownButtonFormField<MajorModel>(
                value: _selectedMajor,
                decoration: const InputDecoration(
                  labelText: 'Major',
                  border: OutlineInputBorder(),
                ),
                items: majors
                    .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(m.nameMajor),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedMajor = v),
                validator: (v) => v == null ? 'Select a major' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(isEdit ? 'Update' : 'Add Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      {bool required = false}) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: required
          ? (v) => v == null || v.isEmpty ? 'Required' : null
          : null,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<StudentProvider>();
    final student = StudentModel(
      id: widget.student?.id,
      name: _nameCtrl.text.trim(),
      date: _dateCtrl.text.isEmpty ? null : _dateCtrl.text,
      gender: _selectedGender,
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      address: _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      idMajor: _selectedMajor?.idMajor,
    );

    final success = isEdit
        ? await provider.updateStudent(student)
        : await provider.addStudent(student);

    if (success && mounted) Navigator.pop(context);
  }
}
