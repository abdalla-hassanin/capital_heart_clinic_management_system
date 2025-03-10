import '../repositories/caregiver_repository.dart';

class DeleteCaregiver {
  final CaregiverRepository repository;

  DeleteCaregiver(this.repository);

  Future<void> call(String id) async {
    await repository.deleteCaregiver(id);
  }
}