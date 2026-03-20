import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/major_model.dart';

class MajorRepository {
  final _client = Supabase.instance.client;

  Future<List<MajorModel>> getAll() async {
    final data = await _client
        .from(AppConstants.tableMajor)
        .select()
        .order(AppConstants.majorId);
    return (data as List).map((e) => MajorModel.fromJson(e)).toList();
  }

  Future<void> insert(MajorModel major) async {
    await _client.from(AppConstants.tableMajor).insert(major.toJson());
  }

  Future<void> update(MajorModel major) async {
    await _client
        .from(AppConstants.tableMajor)
        .update(major.toJson())
        .eq(AppConstants.majorId, major.idMajor as Object);
  }

  Future<void> delete(int id) async {
    await _client
        .from(AppConstants.tableMajor)
        .delete()
        .eq(AppConstants.majorId, id);
  }
}
