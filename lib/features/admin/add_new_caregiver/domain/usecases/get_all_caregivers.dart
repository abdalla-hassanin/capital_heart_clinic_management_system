import '../entities/caregiver.dart';
import '../repositories/caregiver_repository.dart';

class GetAllCaregivers {
  final CaregiverRepository repository;

  GetAllCaregivers(this.repository);

  Stream<List<Caregiver>> call() {
    return repository.getAllCaregivers();
  }
}