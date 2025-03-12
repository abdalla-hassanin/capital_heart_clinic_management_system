import 'dart:io';
import 'dart:typed_data';

class Training {
  final String name;
  final String issuer;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String imageUrl;
  final File? imageFile;
  final Uint8List? imageBytes;

  Training({
    required this.name,
    required this.issuer,
    this.issueDate,
    this.expiryDate,
    required this.imageUrl,
    this.imageFile,
    this.imageBytes,
  });

  Training copyWith({
    String? name,
    String? issuer,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? imageUrl,
    File? imageFile,
    Uint8List? imageBytes,
  }) {
    return Training(
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFile: imageFile ?? this.imageFile,
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }
}