
import '../../domain/entities/reference.dart';

class ReferenceModel {
  final String name;
  final String relationship;
  final String contactInfo;
  final String testimonial;

  ReferenceModel({
    required this.name,
    required this.relationship,
    required this.contactInfo,
    required this.testimonial,
  });

  factory ReferenceModel.fromMap(Map<String, dynamic> map) {
    return ReferenceModel(
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      contactInfo: map['contactInfo'] ?? '',
      testimonial: map['testimonial'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relationship': relationship,
      'contactInfo': contactInfo,
      'testimonial': testimonial,
    };
  }

  Reference toEntity() {
    return Reference(
      name: name,
      relationship: relationship,
      contactInfo: contactInfo,
      testimonial: testimonial,
    );
  }

  factory ReferenceModel.fromEntity(Reference entity) {
    return ReferenceModel(
      name: entity.name,
      relationship: entity.relationship,
      contactInfo: entity.contactInfo,
      testimonial: entity.testimonial,
    );
  }
}