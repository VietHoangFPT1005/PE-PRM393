import 'package:flutter/material.dart';
import '../../data/models/major_model.dart';
import '../../data/repositories/major_repository.dart';

class MajorProvider extends ChangeNotifier {
  final _repo = MajorRepository();

  List<MajorModel> _majors = [];
  List<MajorModel> get majors => _majors;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchAll() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _majors = await _repo.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMajor(MajorModel major) async {
    try {
      await _repo.insert(major);
      await fetchAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateMajor(MajorModel major) async {
    try {
      await _repo.update(major);
      await fetchAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteMajor(int id) async {
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
