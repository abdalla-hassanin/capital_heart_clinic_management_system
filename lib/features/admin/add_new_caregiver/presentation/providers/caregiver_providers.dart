import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/firebase_service.dart';
import '../../data/repositories/caregiver_repository_impl.dart';
import '../../domain/entities/caregiver.dart';
import '../../domain/entities/work_history.dart';
import '../../domain/entities/education.dart';
import '../../domain/entities/certification.dart';
import '../../domain/entities/reference.dart';
import '../../domain/repositories/caregiver_repository.dart';
import '../../domain/usecases/add_caregiver.dart';
import '../../domain/usecases/get_all_caregivers.dart';
import '../../domain/usecases/get_caregiver_by_id.dart';
import '../../domain/usecases/update_caregiver.dart';
import '../../domain/usecases/delete_caregiver.dart';

// Firebase Service Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

// Repository Provider
final caregiverRepositoryProvider = Provider<CaregiverRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return CaregiverRepositoryImpl(firebaseService);
});

// Use Case Providers
final addCaregiverProvider = Provider<AddCaregiver>((ref) {
  return AddCaregiver(ref.watch(caregiverRepositoryProvider));
});

final getAllCaregiversProvider = Provider<GetAllCaregivers>((ref) {
  return GetAllCaregivers(ref.watch(caregiverRepositoryProvider));
});

final getCaregiverByIdProvider = Provider<GetCaregiverById>((ref) {
  return GetCaregiverById(ref.watch(caregiverRepositoryProvider));
});

final updateCaregiverProvider = Provider<UpdateCaregiver>((ref) {
  return UpdateCaregiver(ref.watch(caregiverRepositoryProvider));
});

final deleteCaregiverProvider = Provider<DeleteCaregiver>((ref) {
  return DeleteCaregiver(ref.watch(caregiverRepositoryProvider));
});

// Stream Providers for UI
final caregiversListProvider = StreamProvider<List<Caregiver>>((ref) {
  return ref.watch(getAllCaregiversProvider).call();
});

final caregiverByIdProvider = StreamProvider.family<Caregiver?, String>((ref, id) {
  return ref.watch(getCaregiverByIdProvider).call(id);
});

// Caregiver Form State
class CaregiverFormState {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String professionalSummary;
  final List<WorkHistory> workHistory;
  final List<Education> education;
  final List<Certification> certifications;
  final List<Reference> references;
  final List<String> softSkills;
  final List<String> hardSkills;
  final String languages;
  final bool hasBackgroundCheck;
  final bool hasHealthCheckup;
  final bool hasWorkAuthorization;
  final String memberships;
  final String achievements;
  final bool isLoading;
  final String? error;

  CaregiverFormState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.professionalSummary = '',
    List<WorkHistory>? workHistory,
    List<Education>? education,
    List<Certification>? certifications,
    List<Reference>? references,
    List<String>? softSkills,
    List<String>? hardSkills,
    this.languages = '',
    this.hasBackgroundCheck = false,
    this.hasHealthCheckup = false,
    this.hasWorkAuthorization = false,
    this.memberships = '',
    this.achievements = '',
    this.isLoading = false,
    this.error,
  })  : workHistory = workHistory ?? [WorkHistory(jobTitle: '', employer: '', startYear: '', endYear: '', responsibilities: '')],
        education = education ?? [Education(degree: '', institution: '', year: '')],
        certifications = certifications ?? [Certification(name: '', issuer: '', issueDate: '', expiryDate: '')],
        references = references ?? [Reference(name: '', relationship: '', contactInfo: '', testimonial: '')],
        softSkills = softSkills ?? [],
        hardSkills = hardSkills ?? [];

  CaregiverFormState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? professionalSummary,
    List<WorkHistory>? workHistory,
    List<Education>? education,
    List<Certification>? certifications,
    List<Reference>? references,
    List<String>? softSkills,
    List<String>? hardSkills,
    String? languages,
    bool? hasBackgroundCheck,
    bool? hasHealthCheckup,
    bool? hasWorkAuthorization,
    String? memberships,
    String? achievements,
    bool? isLoading,
    String? error,
  }) {
    return CaregiverFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      workHistory: workHistory ?? this.workHistory,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      references: references ?? this.references,
      softSkills: softSkills ?? this.softSkills,
      hardSkills: hardSkills ?? this.hardSkills,
      languages: languages ?? this.languages,
      hasBackgroundCheck: hasBackgroundCheck ?? this.hasBackgroundCheck,
      hasHealthCheckup: hasHealthCheckup ?? this.hasHealthCheckup,
      hasWorkAuthorization: hasWorkAuthorization ?? this.hasWorkAuthorization,
      memberships: memberships ?? this.memberships,
      achievements: achievements ?? this.achievements,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  Caregiver toModel({String id = ''}) {
    return Caregiver(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      address: address,
      professionalSummary: professionalSummary,
      workHistory: workHistory,
      education: education,
      certifications: certifications,
      references: references,
      softSkills: softSkills,
      hardSkills: hardSkills,
      languages: languages,
      hasBackgroundCheck: hasBackgroundCheck,
      hasHealthCheckup: hasHealthCheckup,
      hasWorkAuthorization: hasWorkAuthorization,
      memberships: memberships,
      achievements: achievements,
      createdAt: DateTime.now(),
    );
  }
}

class CaregiverFormNotifier extends StateNotifier<CaregiverFormState> {
  final AddCaregiver _addCaregiver;
  final UpdateCaregiver _updateCaregiver;

  CaregiverFormNotifier(this._addCaregiver, this._updateCaregiver) : super(CaregiverFormState());

  void updatePersonalInfo({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? professionalSummary,
  }) {
    state = state.copyWith(
      fullName: fullName ?? state.fullName,
      email: email ?? state.email,
      phone: phone ?? state.phone,
      address: address ?? state.address,
      professionalSummary: professionalSummary ?? state.professionalSummary,
    );
  }

  void updateWorkHistory(int index, WorkHistory workHistory) {
    final updatedWorkHistory = List<WorkHistory>.from(state.workHistory);
    if (index < updatedWorkHistory.length) {
      updatedWorkHistory[index] = workHistory;
      state = state.copyWith(workHistory: updatedWorkHistory);
    }
  }

  void addWorkHistory() {
    final updatedWorkHistory = List<WorkHistory>.from(state.workHistory)
      ..add(WorkHistory(jobTitle: '', employer: '', startYear: '', endYear: '', responsibilities: ''));
    state = state.copyWith(workHistory: updatedWorkHistory);
  }

  void removeWorkHistory(int index) {
    if (state.workHistory.length > 1) {
      final updatedWorkHistory = List<WorkHistory>.from(state.workHistory)..removeAt(index);
      state = state.copyWith(workHistory: updatedWorkHistory);
    }
  }

  void updateEducation(int index, Education education) {
    final updatedEducation = List<Education>.from(state.education);
    if (index < updatedEducation.length) {
      updatedEducation[index] = education;
      state = state.copyWith(education: updatedEducation);
    }
  }

  void addEducation() {
    final updatedEducation = List<Education>.from(state.education)
      ..add(Education(degree: '', institution: '', year: ''));
    state = state.copyWith(education: updatedEducation);
  }

  void removeEducation(int index) {
    if (state.education.length > 1) {
      final updatedEducation = List<Education>.from(state.education)..removeAt(index);
      state = state.copyWith(education: updatedEducation);
    }
  }

  void updateCertification(int index, Certification certification) {
    final updatedCertifications = List<Certification>.from(state.certifications);
    if (index < updatedCertifications.length) {
      updatedCertifications[index] = certification;
      state = state.copyWith(certifications: updatedCertifications);
    }
  }

  void addCertification() {
    final updatedCertifications = List<Certification>.from(state.certifications)
      ..add(Certification(name: '', issuer: '', issueDate: '', expiryDate: ''));
    state = state.copyWith(certifications: updatedCertifications);
  }

  void removeCertification(int index) {
    if (state.certifications.length > 1) {
      final updatedCertifications = List<Certification>.from(state.certifications)..removeAt(index);
      state = state.copyWith(certifications: updatedCertifications);
    }
  }

  void updateReference(int index, Reference reference) {
    final updatedReferences = List<Reference>.from(state.references);
    if (index < updatedReferences.length) {
      updatedReferences[index] = reference;
      state = state.copyWith(references: updatedReferences);
    }
  }

  void addReference() {
    final updatedReferences = List<Reference>.from(state.references)
      ..add(Reference(name: '', relationship: '', contactInfo: '', testimonial: ''));
    state = state.copyWith(references: updatedReferences);
  }

  void removeReference(int index) {
    if (state.references.length > 1) {
      final updatedReferences = List<Reference>.from(state.references)..removeAt(index);
      state = state.copyWith(references: updatedReferences);
    }
  }

  void toggleSoftSkill(String skill) {
    final updatedSoftSkills = List<String>.from(state.softSkills);
    if (updatedSoftSkills.contains(skill)) {
      updatedSoftSkills.remove(skill);
    } else {
      updatedSoftSkills.add(skill);
    }
    state = state.copyWith(softSkills: updatedSoftSkills);
  }

  void toggleHardSkill(String skill) {
    final updatedHardSkills = List<String>.from(state.hardSkills);
    if (updatedHardSkills.contains(skill)) {
      updatedHardSkills.remove(skill);
    } else {
      updatedHardSkills.add(skill);
    }
    state = state.copyWith(hardSkills: updatedHardSkills);
  }

  void updateLanguages(String languages) {
    state = state.copyWith(languages: languages);
  }

  void updateDocuments({bool? hasBackgroundCheck, bool? hasHealthCheckup, bool? hasWorkAuthorization}) {
    state = state.copyWith(
      hasBackgroundCheck: hasBackgroundCheck ?? state.hasBackgroundCheck,
      hasHealthCheckup: hasHealthCheckup ?? state.hasHealthCheckup,
      hasWorkAuthorization: hasWorkAuthorization ?? state.hasWorkAuthorization,
    );
  }

  void updateMemberships(String memberships) {
    state = state.copyWith(memberships: memberships);
  }

  void updateAchievements(String achievements) {
    state = state.copyWith(achievements: achievements);
  }

  Future<bool> submitForm() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final caregiver = state.toModel();
      await _addCaregiver(caregiver);
      state = CaregiverFormState();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateExistingCaregiver(String id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final caregiver = state.toModel(id: id);
      await _updateCaregiver(id, caregiver);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void loadCaregiverData(Caregiver caregiver) {
    state = CaregiverFormState(
      fullName: caregiver.fullName,
      email: caregiver.email,
      phone: caregiver.phone,
      address: caregiver.address,
      professionalSummary: caregiver.professionalSummary,
      workHistory: caregiver.workHistory,
      education: caregiver.education,
      certifications: caregiver.certifications,
      references: caregiver.references,
      softSkills: caregiver.softSkills,
      hardSkills: caregiver.hardSkills,
      languages: caregiver.languages,
      hasBackgroundCheck: caregiver.hasBackgroundCheck,
      hasHealthCheckup: caregiver.hasHealthCheckup,
      hasWorkAuthorization: caregiver.hasWorkAuthorization,
      memberships: caregiver.memberships,
      achievements: caregiver.achievements,
    );
  }
}

final caregiverFormProvider = StateNotifierProvider<CaregiverFormNotifier, CaregiverFormState>((ref) {
  final addCaregiver = ref.watch(addCaregiverProvider);
  final updateCaregiver = ref.watch(updateCaregiverProvider);
  return CaregiverFormNotifier(addCaregiver, updateCaregiver);
});