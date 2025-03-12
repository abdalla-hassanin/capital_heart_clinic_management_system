import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/caregiver.dart';
import 'certification_model.dart';
import 'education_model.dart';
import 'reference_model.dart';
import 'work_history_model.dart';
import 'training_model.dart';

class CaregiverModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String country;
  final String address;
  final String professionalSummary;
  final String imageUrl;
  final List<WorkHistoryModel> workHistory;
  final List<EducationModel> education;
  final List<CertificationModel> certifications;
  final List<TrainingModel> trainings;
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
  final DateTime? birthdate;
  final String gender;
  final String maritalStatus;

  CaregiverModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.country,
    required this.address,
    required this.professionalSummary,
    required this.imageUrl,
    required this.workHistory,
    required this.education,
    required this.certifications,
    required this.trainings,
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
    this.birthdate,
    required this.gender,
    required this.maritalStatus,
  });

  factory CaregiverModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CaregiverModel(
      id: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      address: data['address'] ?? '',
      professionalSummary: data['professionalSummary'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      workHistory: List<WorkHistoryModel>.from(
        (data['workHistory'] as List? ?? []).map((job) => WorkHistoryModel.fromMap(job)),
      ),
      education: List<EducationModel>.from(
        (data['education'] as List? ?? []).map((edu) => EducationModel.fromMap(edu)),
      ),
      certifications: List<CertificationModel>.from(
        (data['certifications'] as List? ?? []).map((cert) => CertificationModel.fromMap(cert)),
      ),
      trainings: List<TrainingModel>.from(
        (data['trainings'] as List? ?? []).map((train) => TrainingModel.fromMap(train)),
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
      birthdate: (data['birthdate'] as Timestamp?)?.toDate(),
      gender: data['gender'] ?? '',
      maritalStatus: data['maritalStatus'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'city': city,
      'country': country,
      'address': address,
      'professionalSummary': professionalSummary,
      'imageUrl': imageUrl,
      'workHistory': workHistory.map((job) => job.toMap()).toList(),
      'education': education.map((edu) => edu.toMap()).toList(),
      'certifications': certifications.map((cert) => cert.toMap()).toList(),
      'trainings': trainings.map((train) => train.toMap()).toList(),
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
      'birthdate': birthdate != null ? Timestamp.fromDate(birthdate!) : null,
      'gender': gender,
      'maritalStatus': maritalStatus,
    };
  }

  Caregiver toEntity() {
    return Caregiver(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      city: city,
      country: country,
      address: address,
      professionalSummary: professionalSummary,
      imageUrl: imageUrl,
      workHistory: workHistory.map((job) => job.toEntity()).toList(),
      education: education.map((edu) => edu.toEntity()).toList(),
      certifications: certifications.map((cert) => cert.toEntity()).toList(),
      trainings: trainings.map((train) => train.toEntity()).toList(),
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
      birthdate: birthdate,
      gender: gender,
      maritalStatus: maritalStatus,
    );
  }

  factory CaregiverModel.fromEntity(Caregiver entity) {
    return CaregiverModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      city: entity.city,
      country: entity.country,
      address: entity.address,
      professionalSummary: entity.professionalSummary,
      imageUrl: entity.imageUrl,
      workHistory: entity.workHistory.map((job) => WorkHistoryModel.fromEntity(job)).toList(),
      education: entity.education.map((edu) => EducationModel.fromEntity(edu)).toList(),
      certifications: entity.certifications.map((cert) => CertificationModel.fromEntity(cert)).toList(),
      trainings: entity.trainings.map((train) => TrainingModel.fromEntity(train)).toList(),
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
      birthdate: entity.birthdate,
      gender: entity.gender,
      maritalStatus: entity.maritalStatus,
    );
  }
}