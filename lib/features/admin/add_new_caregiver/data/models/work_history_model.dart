import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/work_history.dart';

class WorkHistoryModel {
  final String jobTitle;
  final String employer;
  final DateTime? startDate;
  final DateTime? endDate;
  final String responsibilities;

  WorkHistoryModel({
    required this.jobTitle,
    required this.employer,
    this.startDate,
    this.endDate,
    required this.responsibilities,
  });

  factory WorkHistoryModel.fromMap(Map<String, dynamic> map) {
    return WorkHistoryModel(
      jobTitle: map['jobTitle'] ?? '',
      employer: map['employer'] ?? '',
      startDate: (map['startDate'] as Timestamp?)?.toDate(),
      endDate: (map['endDate'] as Timestamp?)?.toDate(),
      responsibilities: map['responsibilities'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobTitle': jobTitle,
      'employer': employer,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'responsibilities': responsibilities,
    };
  }

  WorkHistory toEntity() => WorkHistory(
    jobTitle: jobTitle,
    employer: employer,
    startDate: startDate,
    endDate: endDate,
    responsibilities: responsibilities,
  );

  factory WorkHistoryModel.fromEntity(WorkHistory entity) => WorkHistoryModel(
    jobTitle: entity.jobTitle,
    employer: entity.employer,
    startDate: entity.startDate,
    endDate: entity.endDate,
    responsibilities: entity.responsibilities,
  );
}