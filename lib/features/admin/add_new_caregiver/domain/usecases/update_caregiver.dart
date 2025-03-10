import '../entities/caregiver.dart';
import '../repositories/caregiver_repository.dart';

class UpdateCaregiver {
  final CaregiverRepository repository;

  UpdateCaregiver(this.repository);

  Future<void> call(String id, Caregiver caregiver) async {
    await repository.updateCaregiver(id, caregiver);
  }
}