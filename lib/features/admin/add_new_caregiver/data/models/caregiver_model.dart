import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/caregiver.dart';
import 'certification_model.dart';
import 'education_model.dart';
import 'reference_model.dart';
import 'work_history_model.dart';

class CaregiverModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String professionalSummary;
  final List<WorkHistoryModel> workHistory;
  final List<EducationModel> education;
  final List<CertificationModel> certifications;
  final List<ReferenceModel> references;
  final List<String> softSkills;
  final List<String> hardSkills;
  final String languages;
  final bool hasBackgroundCheck;
  final bool hasHealthCheckup;
  final bool hasWorkAuthorization;
  final String memberships;
  final String achievements;
  final DateTime createdAt;

  CaregiverModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.professionalSummary,
    required this.workHistory,
    required this.education,
    required this.certifications,
    required this.references,
    required this.softSkills,
    required this.hardSkills,
    required this.languages,
    required this.hasBackgroundCheck,
    required this.hasHealthCheckup,
    required this.hasWorkAuthorization,
    required this.memberships,
    required this.achievements,
    required this.createdAt,
  });

  factory CaregiverModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CaregiverModel(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      professionalSummary: data['professionalSummary'] ?? '',
      workHistory: List<WorkHistoryModel>.from(
        (data['workHistory'] as List? ?? []).map((job) => WorkHistoryModel.fromMap(job)),
      ),
      education: List<EducationModel>.from(
        (data['education'] as List? ?? []).map((edu) => EducationModel.fromMap(edu)),
      ),
      certifications: List<CertificationModel>.from(
        (data['certifications'] as List? ?? []).map((cert) => CertificationModel.fromMap(cert)),
      ),
      references: List<ReferenceModel>.from(
        (data['references'] as List? ?? []).map((ref) => ReferenceModel.fromMap(ref)),
      ),
      softSkills: List<String>.from(data['softSkills'] ?? []),
      hardSkills: List<String>.from(data['hardSkills'] ?? []),
      languages: data['languages'] ?? '',
      hasBackgroundCheck: data['hasBackgroundCheck'] ?? false,
      hasHealthCheckup: data['hasHealthCheckup'] ?? false,
      hasWorkAuthorization: data['hasWorkAuthorization'] ?? false,
      memberships: data['memberships'] ?? '',
      achievements: data['achievements'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'professionalSummary': professionalSummary,
      'workHistory': workHistory.map((job) => job.toMap()).toList(),
      'education': education.map((edu) => edu.toMap()).toList(),
      'certifications': certifications.map((cert) => cert.toMap()).toList(),
      'references': references.map((ref) => ref.toMap()).toList(),
      'softSkills': softSkills,
      'hardSkills': hardSkills,
      'languages': languages,
      'hasBackgroundCheck': hasBackgroundCheck,
      'hasHealthCheckup': hasHealthCheckup,
      'hasWorkAuthorization': hasWorkAuthorization,
      'memberships': memberships,
      'achievements': achievements,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Convert to domain entity
  Caregiver toEntity() {
    return Caregiver(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      address: address,
      professionalSummary: professionalSummary,
      workHistory: workHistory.map((job) => job.toEntity()).toList(),
      education: education.map((edu) => edu.toEntity()).toList(),
      certifications: certifications.map((cert) => cert.toEntity()).toList(),
      references: references.map((ref) => ref.toEntity()).toList(),
      softSkills: softSkills,
      hardSkills: hardSkills,
      languages: languages,
      hasBackgroundCheck: hasBackgroundCheck,
      hasHealthCheckup: hasHealthCheckup,
      hasWorkAuthorization: hasWorkAuthorization,
      memberships: memberships,
      achievements: achievements,
      createdAt: createdAt,
    );
  }

  // Convert from domain entity
  factory CaregiverModel.fromEntity(Caregiver entity) {
    return CaregiverModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      professionalSummary: entity.professionalSummary,
      workHistory: entity.workHistory.map((job) => WorkHistoryModel.fromEntity(job)).toList(),
      education: entity.education.map((edu) => EducationModel.fromEntity(edu)).toList(),
      certifications: entity.certifications.map((cert) => CertificationModel.fromEntity(cert)).toList(),
      references: entity.references.map((ref) => ReferenceModel.fromEntity(ref)).toList(),
      softSkills: entity.softSkills,
      hardSkills: entity.hardSkills,
      languages: entity.languages,
      hasBackgroundCheck: entity.hasBackgroundCheck,
      hasHealthCheckup: entity.hasHealthCheckup,
      hasWorkAuthorization: entity.hasWorkAuthorization,
      memberships: entity.memberships,
      achievements: entity.achievements,
      createdAt: entity.createdAt,
    );
  }
}