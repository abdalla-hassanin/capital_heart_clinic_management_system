
import 'certification.dart';
import 'education.dart';
import 'reference.dart';
import 'work_history.dart';

class Caregiver {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String professionalSummary;
  final List<WorkHistory> workHistory;
  final List<Education> education;
  final List<Certification> certifications;
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

  Caregiver({
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
}