import 'package:flutter/material.dart';
import '../../data/models/student_model.dart';
import '../../data/repositories/student_repository.dart';

class StudentProvider extends ChangeNotifier {
  final _repo = StudentRepository();

  List<StudentModel> _students = [];
  List<StudentModel> get students => _students;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchAll() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _students = await _repo.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addStudent(StudentModel student) async {
    try {
      await _repo.insert(student);
      await fetchAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStudent(StudentModel student) async {
    try {
      await _repo.update(student);
      await fetchAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteStudent(int id) async {
    try {
      await _repo.delete(id);
      await fetchAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
