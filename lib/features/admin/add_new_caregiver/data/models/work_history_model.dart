
import '../../domain/entities/work_history.dart';

class WorkHistoryModel {
  final String jobTitle;
  final String employer;
  final String startYear;
  final String endYear;
  final String responsibilities;

  WorkHistoryModel({
    required this.jobTitle,
    required this.employer,
    required this.startYear,
    required this.endYear,
    required this.responsibilities,
  });

  factory WorkHistoryModel.fromMap(Map<String, dynamic> map) {
    return WorkHistoryModel(
      jobTitle: map['jobTitle'] ?? '',
      employer: map['employer'] ?? '',
      startYear: map['startYear'] ?? '',
      endYear: map['endYear'] ?? '',
      responsibilities: map['responsibilities'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobTitle': jobTitle,
      'employer': employer,
      'startYear': startYear,
      'endYear': endYear,
      'responsibilities': responsibilities,
    };
  }

  WorkHistory toEntity() {
    return WorkHistory(
      jobTitle: jobTitle,
      employer: employer,
      startYear: startYear,
      endYear: endYear,
      responsibilities: responsibilities,
    );
  }

  factory WorkHistoryModel.fromEntity(WorkHistory entity) {
    return WorkHistoryModel(
      jobTitle: entity.jobTitle,
      employer: entity.employer,
      startYear: entity.startYear,
      endYear: entity.endYear,
      responsibilities: entity.responsibilities,
    );
  }
}