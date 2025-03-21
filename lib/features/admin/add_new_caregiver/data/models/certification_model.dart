import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/certification.dart';

class CertificationModel {
  final String name;
  final String issuer;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String imageUrl;

  CertificationModel({
    required this.name,
    required this.issuer,
    this.issueDate,
    this.expiryDate,
    required this.imageUrl,
  });

  factory CertificationModel.fromMap(Map<String, dynamic> map) {
    return CertificationModel(
      name: map['name'] ?? '',
      issuer: map['issuer'] ?? '',
      issueDate: (map['issueDate'] as Timestamp?)?.toDate(),
      expiryDate: (map['expiryDate'] as Timestamp?)?.toDate(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'issuer': issuer,
      'issueDate': issueDate != null ? Timestamp.fromDate(issueDate!) : null,
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'imageUrl': imageUrl,
    };
  }

  Certification toEntity() => Certification(
    name: name,
    issuer: issuer,
    issueDate: issueDate,
    expiryDate: expiryDate,
    imageUrl: imageUrl,
  );

  factory CertificationModel.fromEntity(Certification entity) => CertificationModel(
    name: entity.name,
    issuer: entity.issuer,
    issueDate: entity.issueDate,
    expiryDate: entity.expiryDate,
    imageUrl: entity.imageUrl,
  );
}