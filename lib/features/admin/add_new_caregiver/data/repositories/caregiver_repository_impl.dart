import 'package:capital_heart_clinic_management_system/core/utils/firebase_end_points.dart';

import '../models/caregiver_model.dart';
import '../../domain/entities/caregiver.dart';
import '../../domain/repositories/caregiver_repository.dart';
import '../services/firebase_service.dart';

class CaregiverRepositoryImpl implements CaregiverRepository {
  final FirebaseService _firebaseService;
  static const String _collection = FireBaseEndPoints.caregivers;

  CaregiverRepositoryImpl(this._firebaseService);

  @override
  Stream<List<Caregiver>> getAllCaregivers() {
    return _firebaseService.firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CaregiverModel.fromFirestore(doc).toEntity())
        .toList());
  }

  @override
  Stream<Caregiver?> getCaregiverById(String id) {
    return _firebaseService.firestore
        .collection(_collection)
        .doc(id)
        .snapshots()
        .map((doc) => doc.exists ? CaregiverModel.fromFirestore(doc).toEntity() : null);
  }

  @override
  Future<String> addCaregiver(Caregiver caregiver) async {
    final docRef = await _firebaseService.firestore
        .collection(_collection)
        .add(CaregiverModel.fromEntity(caregiver).toFirestore());
    return docRef.id;
  }

  @override
  Future<void> updateCaregiver(String id, Caregiver caregiver) async {
    await _firebaseService.firestore
        .collection(_collection)
        .doc(id)
        .update(CaregiverModel.fromEntity(caregiver).toFirestore());
  }

  @override
  Future<void> deleteCaregiver(String id) async {
    await _firebaseService.firestore.collection(_collection).doc(id).delete();
  }
}