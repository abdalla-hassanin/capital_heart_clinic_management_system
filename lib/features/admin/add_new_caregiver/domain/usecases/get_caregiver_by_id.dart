import '../entities/caregiver.dart';
import '../repositories/caregiver_repository.dart';

class GetCaregiverById {
  final CaregiverRepository repository;

  GetCaregiverById(this.repository);

  Stream<Caregiver?> call(String id) {
    return repository.getCaregiverById(id);
  }
}