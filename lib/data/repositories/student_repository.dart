import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/student_model.dart';

class StudentRepository {
  final _client = Supabase.instance.client;

  // Lấy tất cả Student kèm thông tin Major (JOIN)
  Future<List<StudentModel>> getAll() async {
    final data = await _client
        .from(AppConstants.tableStudent)
        .select('*, ${AppConstants.tableMajor}(${AppConstants.majorId}, ${AppConstants.majorName})')
        .order(AppConstants.studentId);
    return (data as List).map((e) => StudentModel.fromJson(e)).toList();
  }

  Future<void> insert(StudentModel student) async {
    await _client.from(AppConstants.tableStudent).insert(student.toJson());
  }

  Future<void> update(StudentModel student) async {
    await _client
        .from(AppConstants.tableStudent)
        .update(student.toJson())
        .eq(AppConstants.studentId, student.id as Object);
  }

  Future<void> delete(int id) async {
    await _client
        .from(AppConstants.tableStudent)
        .delete()
        .eq(AppConstants.studentId, id);
  }
}
