
import '../../domain/entities/education.dart';

class EducationModel {
  final String degree;
  final String institution;
  final String year;

  EducationModel({
    required this.degree,
    required this.institution,
    required this.year,
  });

  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      degree: map['degree'] ?? '',
      institution: map['institution'] ?? '',
      year: map['year'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'degree': degree,
      'institution': institution,
      'year': year,
    };
  }

  Education toEntity() {
    return Education(
      degree: degree,
      institution: institution,
      year: year,
    );
  }

  factory EducationModel.fromEntity(Education entity) {
    return EducationModel(
      degree: entity.degree,
      institution: entity.institution,
      year: entity.year,
    );
  }
}