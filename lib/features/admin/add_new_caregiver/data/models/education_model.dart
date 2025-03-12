import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/education.dart';

class EducationModel {
  final String degree;
  final String institution;
  final DateTime? completionDate;

  EducationModel({
    required this.degree,
    required this.institution,
    this.completionDate,
  });

  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      degree: map['degree'] ?? '',
      institution: map['institution'] ?? '',
      completionDate: (map['completionDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'degree': degree,
      'institution': institution,
      'completionDate': completionDate != null ? Timestamp.fromDate(completionDate!) : null,
    };
  }

  Education toEntity() => Education(
    degree: degree,
    institution: institution,
    completionDate: completionDate,
  );

  factory EducationModel.fromEntity(Education entity) => EducationModel(
    degree: entity.degree,
    institution: entity.institution,
    completionDate: entity.completionDate,
  );
}