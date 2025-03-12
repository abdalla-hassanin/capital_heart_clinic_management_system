import 'certification.dart';
import 'education.dart';
import 'reference.dart';
import 'work_history.dart';
import 'training.dart';

class Caregiver {
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
  final List<WorkHistory> workHistory;
  final List<Education> education;
  final List<Certification> certifications;
  final List<Training> trainings;
  final List<Reference> references;
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

  Caregiver({
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
}