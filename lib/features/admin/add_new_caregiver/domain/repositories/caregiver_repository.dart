import '../entities/caregiver.dart';

abstract class CaregiverRepository {
  Stream<List<Caregiver>> getAllCaregivers();
  Stream<Caregiver?> getCaregiverById(String id);
  Future<String> addCaregiver(Caregiver caregiver);
  Future<void> updateCaregiver(String id, Caregiver caregiver);
  Future<void> deleteCaregiver(String id);
}