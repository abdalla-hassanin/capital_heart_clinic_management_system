import '../entities/caregiver.dart';
import '../repositories/caregiver_repository.dart';

class AddCaregiver {
  final CaregiverRepository repository;

  AddCaregiver(this.repository);

  Future<String> call(Caregiver caregiver) async {
    return await repository.addCaregiver(caregiver);
  }
}