import '../../core/constants/app_constants.dart';
import 'major_model.dart';

class StudentModel {
  final int? id;
  final String name;
  final String? date;
  final String? gender;
  final String? email;
  final String? address;
  final String? phone;
  final int? idMajor;
  final MajorModel? major;

  StudentModel({
    this.id,
    required this.name,
    this.date,
    this.gender,
    this.email,
    this.address,
    this.phone,
    this.idMajor,
    this.major,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id:      json[AppConstants.studentId],
      name:    json[AppConstants.studentName]    ?? '',
      date:    json[AppConstants.studentDate],
      gender:  json[AppConstants.studentGender],
      email:   json[AppConstants.studentEmail],
      address: json[AppConstants.studentAddress],
      phone:   json[AppConstants.studentPhone],
      idMajor: json[AppConstants.studentMajorId],
      major: json[AppConstants.tableMajor] != null
          ? MajorModel.fromJson(json[AppConstants.tableMajor])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    AppConstants.studentName:    name,
    AppConstants.studentDate:    date,
    AppConstants.studentGender:  gender,
    AppConstants.studentEmail:   email,
    AppConstants.studentAddress: address,
    AppConstants.studentPhone:   phone,
    AppConstants.studentMajorId: idMajor,
  };

  StudentModel copyWith({
    int? id, String? name, String? date, String? gender,
    String? email, String? address, String? phone,
    int? idMajor, MajorModel? major,
  }) {
    return StudentModel(
      id: id ?? this.id, name: name ?? this.name,
      date: date ?? this.date, gender: gender ?? this.gender,
      email: email ?? this.email, address: address ?? this.address,
      phone: phone ?? this.phone, idMajor: idMajor ?? this.idMajor,
      major: major ?? this.major,
    );
  }
}
