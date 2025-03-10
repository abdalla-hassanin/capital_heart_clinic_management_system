
import '../../domain/entities/certification.dart';

class CertificationModel {
  final String name;
  final String issuer;
  final String issueDate;
  final String expiryDate;

  CertificationModel({
    required this.name,
    required this.issuer,
    required this.issueDate,
    required this.expiryDate,
  });

  factory CertificationModel.fromMap(Map<String, dynamic> map) {
    return CertificationModel(
      name: map['name'] ?? '',
      issuer: map['issuer'] ?? '',
      issueDate: map['issueDate'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'issuer': issuer,
      'issueDate': issueDate,
      'expiryDate': expiryDate,
    };
  }

  Certification toEntity() {
    return Certification(
      name: name,
      issuer: issuer,
      issueDate: issueDate,
      expiryDate: expiryDate,
    );
  }

  factory CertificationModel.fromEntity(Certification entity) {
    return CertificationModel(
      name: entity.name,
      issuer: entity.issuer,
      issueDate: entity.issueDate,
      expiryDate: entity.expiryDate,
    );
  }
}