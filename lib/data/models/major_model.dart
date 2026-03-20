import '../../core/constants/app_constants.dart';

class MajorModel {
  final int? idMajor;
  final String nameMajor;

  MajorModel({this.idMajor, required this.nameMajor});

  factory MajorModel.fromJson(Map<String, dynamic> json) {
    return MajorModel(
      idMajor:   json[AppConstants.majorId],
      nameMajor: json[AppConstants.majorName] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    AppConstants.majorName: nameMajor,
  };

  MajorModel copyWith({int? idMajor, String? nameMajor}) {
    return MajorModel(
      idMajor:   idMajor   ?? this.idMajor,
      nameMajor: nameMajor ?? this.nameMajor,
    );
  }
}
