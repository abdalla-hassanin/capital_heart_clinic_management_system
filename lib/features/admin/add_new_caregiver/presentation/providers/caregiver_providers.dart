import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/firebase_end_points.dart';
import '../../data/services/firebase_service.dart';
import '../../data/repositories/caregiver_repository_impl.dart';
import '../../domain/entities/caregiver.dart';
import '../../domain/entities/work_history.dart';
import '../../domain/entities/education.dart';
import '../../domain/entities/certification.dart';
import '../../domain/entities/training.dart';
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
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String country;
  final String address;
  final String professionalSummary;
  final File? imageFile;
  final Uint8List? imageBytes;
  final String imageUrl;
  final List<WorkHistory> workHistory;
  final List<Education> education;
  final List<Certification> certifications;
  final List<Training> trainings;
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
  final DateTime? birthdate;
  final String gender;
  final String maritalStatus;

  CaregiverFormState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.city = '',
    this.country = '',
    this.address = '',
    this.professionalSummary = '',
    this.imageFile,
    this.imageBytes,
    this.imageUrl = '',
    List<WorkHistory>? workHistory,
    List<Education>? education,
    List<Certification>? certifications,
    List<Training>? trainings,
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
    this.birthdate,
    this.gender = '',
    this.maritalStatus = '',
  })  : workHistory = workHistory ??
      [
        WorkHistory(
          jobTitle: '',
          employer: '',
          startDate: null,
          endDate: null,
          responsibilities: '',
        )
      ],
        education = education ??
            [
              Education(
                degree: '',
                institution: '',
                completionDate: null,
              )
            ],
        certifications = certifications ??
            [
              Certification(
                name: '',
                issuer: '',
                issueDate: null,
                expiryDate: null,
                imageUrl: '',
                imageFile: null,
                imageBytes: null,
              )
            ],
        trainings = trainings ??
            [
              Training(
                name: '',
                issuer: '',
                issueDate: null,
                expiryDate: null,
                imageUrl: '',
                imageFile: null,
                imageBytes: null,
              )
            ],
        references = references ??
            [
              Reference(
                name: '',
                relationship: '',
                contactInfo: '',
                testimonial: '',
              )
            ],
        softSkills = softSkills ?? [],
        hardSkills = hardSkills ?? [];

  int? get age {
    if (birthdate == null) return null;
    final today = DateTime.now();
    int age = today.year - birthdate!.year;
    if (today.month < birthdate!.month ||
        (today.month == birthdate!.month && today.day < birthdate!.day)) {
      age--;
    }
    return age;
  }

  CaregiverFormState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? city,
    String? country,
    String? address,
    String? professionalSummary,
    File? imageFile,
    Uint8List? imageBytes,
    String? imageUrl,
    List<WorkHistory>? workHistory,
    List<Education>? education,
    List<Certification>? certifications,
    List<Training>? trainings,
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
    DateTime? birthdate,
    String? gender,
    String? maritalStatus,
  }) {
    return CaregiverFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      country: country ?? this.country,
      address: address ?? this.address,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      imageFile: imageFile ?? this.imageFile,
      imageBytes: imageBytes ?? this.imageBytes,
      imageUrl: imageUrl ?? this.imageUrl,
      workHistory: workHistory ?? this.workHistory,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      trainings: trainings ?? this.trainings,
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
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      maritalStatus: maritalStatus ?? this.maritalStatus,
    );
  }

  Caregiver toModel({String id = ''}) {
    return Caregiver(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      city: city,
      country: country,
      address: address,
      professionalSummary: professionalSummary,
      imageUrl: imageUrl,
      workHistory: workHistory,
      education: education,
      certifications: certifications,
      trainings: trainings,
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
      birthdate: birthdate,
      gender: gender,
      maritalStatus: maritalStatus,
    );
  }
}

class CaregiverFormNotifier extends StateNotifier<CaregiverFormState> {
  final AddCaregiver _addCaregiver;
  final UpdateCaregiver _updateCaregiver;
  final FirebaseService _firebaseService;

  CaregiverFormNotifier(this._addCaregiver, this._updateCaregiver, this._firebaseService)
      : super(CaregiverFormState());

  void updatePersonalInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? city,
    String? country,
    String? address,
    String? professionalSummary,
    File? imageFile,
    Uint8List? imageBytes,
  }) {
    state = state.copyWith(
      firstName: firstName ?? state.firstName,
      lastName: lastName ?? state.lastName,
      email: email ?? state.email,
      phone: phone ?? state.phone,
      city: city ?? state.city,
      country: country ?? state.country,
      address: address ?? state.address,
      professionalSummary: professionalSummary ?? state.professionalSummary,
      imageFile: imageFile ?? state.imageFile,
      imageBytes: imageBytes ?? state.imageBytes,
    );
  }

  void updateBirthdate(DateTime? birthdate) {
    state = state.copyWith(
        birthdate: birthdate != null ? DateTime(birthdate.year, birthdate.month, birthdate.day) : null);
  }

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void updateMaritalStatus(String maritalStatus) {
    state = state.copyWith(maritalStatus: maritalStatus);
  }

  void updateWorkHistory(int index, WorkHistory workHistory) {
    final updatedWorkHistory = List<WorkHistory>.from(state.workHistory);
    if (index < updatedWorkHistory.length) {
      updatedWorkHistory[index] = WorkHistory(
        jobTitle: workHistory.jobTitle,
        employer: workHistory.employer,
        startDate: workHistory.startDate != null
            ? DateTime(workHistory.startDate!.year, workHistory.startDate!.month,
            workHistory.startDate!.day)
            : null,
        endDate: workHistory.endDate != null
            ? DateTime(workHistory.endDate!.year, workHistory.endDate!.month,
            workHistory.endDate!.day)
            : null,
        responsibilities: workHistory.responsibilities,
      );
      state = state.copyWith(workHistory: updatedWorkHistory);
    }
  }

  void addWorkHistory() {
    final updatedWorkHistory = List<WorkHistory>.from(state.workHistory)
      ..add(WorkHistory(
          jobTitle: '',
          employer: '',
          startDate: null,
          endDate: null,
          responsibilities: ''));
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
      updatedEducation[index] = Education(
        degree: education.degree,
        institution: education.institution,
        completionDate: education.completionDate != null
            ? DateTime(education.completionDate!.year, education.completionDate!.month,
            education.completionDate!.day)
            : null,
      );
      state = state.copyWith(education: updatedEducation);
    }
  }

  void addEducation() {
    final updatedEducation = List<Education>.from(state.education)
      ..add(Education(degree: '', institution: '', completionDate: null));
    state = state.copyWith(education: updatedEducation);
  }

  void removeEducation(int index) {
    if (state.education.length > 1) {
      final updatedEducation = List<Education>.from(state.education)..removeAt(index);
      state = state.copyWith(education: updatedEducation);
    }
  }

  void updateCertification(int index, Certification certification, {File? imageFile, Uint8List? imageBytes}) {
    final updatedCertifications = List<Certification>.from(state.certifications);
    if (index < updatedCertifications.length) {
      updatedCertifications[index] = Certification(
        name: certification.name,
        issuer: certification.issuer,
        issueDate: certification.issueDate != null
            ? DateTime(certification.issueDate!.year, certification.issueDate!.month,
            certification.issueDate!.day)
            : null,
        expiryDate: certification.expiryDate != null
            ? DateTime(certification.expiryDate!.year, certification.expiryDate!.month,
            certification.expiryDate!.day)
            : null,
        imageUrl: certification.imageUrl,
        imageFile: imageFile ?? certification.imageFile,
        imageBytes: imageBytes ?? certification.imageBytes,
      );
      state = state.copyWith(certifications: updatedCertifications);
    }
  }

  void addCertification() {
    final updatedCertifications = List<Certification>.from(state.certifications)
      ..add(Certification(
          name: '',
          issuer: '',
          issueDate: null,
          expiryDate: null,
          imageUrl: '',
          imageFile: null,
          imageBytes: null));
    state = state.copyWith(certifications: updatedCertifications);
  }

  void removeCertification(int index) {
    if (state.certifications.length > 1) {
      final updatedCertifications = List<Certification>.from(state.certifications)..removeAt(index);
      state = state.copyWith(certifications: updatedCertifications);
    }
  }

  void updateTraining(int index, Training training, {File? imageFile, Uint8List? imageBytes}) {
    final updatedTrainings = List<Training>.from(state.trainings);
    if (index < updatedTrainings.length) {
      updatedTrainings[index] = Training(
        name: training.name,
        issuer: training.issuer,
        issueDate: training.issueDate != null
            ? DateTime(training.issueDate!.year, training.issueDate!.month,
            training.issueDate!.day)
            : null,
        expiryDate: training.expiryDate != null
            ? DateTime(training.expiryDate!.year, training.expiryDate!.month,
            training.expiryDate!.day)
            : null,
        imageUrl: training.imageUrl,
        imageFile: imageFile ?? training.imageFile,
        imageBytes: imageBytes ?? training.imageBytes,
      );
      state = state.copyWith(trainings: updatedTrainings);
    }
  }

  void addTraining() {
    final updatedTrainings = List<Training>.from(state.trainings)
      ..add(Training(
          name: '',
          issuer: '',
          issueDate: null,
          expiryDate: null,
          imageUrl: '',
          imageFile: null,
          imageBytes: null));
    state = state.copyWith(trainings: updatedTrainings);
  }

  void removeTraining(int index) {
    if (state.trainings.length > 1) {
      final updatedTrainings = List<Training>.from(state.trainings)..removeAt(index);
      state = state.copyWith(trainings: updatedTrainings);
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

      // Upload personal image
      String? personalImageUrl = state.imageUrl;
      if (state.imageFile != null) {
        personalImageUrl = await _firebaseService.uploadImage(
          state.imageFile,
          '${FireBaseEndPoints.caregivers}/${state.email.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : state.email}/profile.jpg',
        );
      } else if (state.imageBytes != null) {
        personalImageUrl = await _firebaseService.uploadImage(
          state.imageBytes,
          '${FireBaseEndPoints.caregivers}/${state.email.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : state.email}/profile.jpg',
        );
      }
      state = state.copyWith(imageUrl: personalImageUrl ?? state.imageUrl);

      // Upload certification images
      final updatedCertifications = List<Certification>.from(state.certifications);
      for (int i = 0; i < updatedCertifications.length; i++) {
        if (updatedCertifications[i].imageFile != null) {
          final certImageUrl = await _firebaseService.uploadImage(
            updatedCertifications[i].imageFile,
            '${FireBaseEndPoints.caregivers}/${state.email}/${FireBaseEndPoints.certifications}/cert_$i.jpg',
          );
          updatedCertifications[i] = updatedCertifications[i].copyWith(imageUrl: certImageUrl ?? '');
        } else if (updatedCertifications[i].imageBytes != null) {
          final certImageUrl = await _firebaseService.uploadImage(
            updatedCertifications[i].imageBytes,
            '${FireBaseEndPoints.caregivers}/${state.email}/${FireBaseEndPoints.certifications}/cert_$i.jpg',
          );
          updatedCertifications[i] = updatedCertifications[i].copyWith(imageUrl: certImageUrl ?? '');
        }
      }

      // Upload training images
      final updatedTrainings = List<Training>.from(state.trainings);
      for (int i = 0; i < updatedTrainings.length; i++) {
        if (updatedTrainings[i].imageFile != null) {
          final trainImageUrl = await _firebaseService.uploadImage(
            updatedTrainings[i].imageFile,
            '${FireBaseEndPoints.caregivers}/${state.email}/${FireBaseEndPoints.trainings}/train_$i.jpg',
          );
          updatedTrainings[i] = updatedTrainings[i].copyWith(imageUrl: trainImageUrl ?? '');
        } else if (updatedTrainings[i].imageBytes != null) {
          final trainImageUrl = await _firebaseService.uploadImage(
            updatedTrainings[i].imageBytes,
            '${FireBaseEndPoints.caregivers}/${state.email}/${FireBaseEndPoints.trainings}/train_$i.jpg',
          );
          updatedTrainings[i] = updatedTrainings[i].copyWith(imageUrl: trainImageUrl ?? '');
        }
      }

      // Create caregiver with updated data
      final caregiver = state.copyWith(
        imageUrl: personalImageUrl ?? state.imageUrl,
        certifications: updatedCertifications,
        trainings: updatedTrainings,
      ).toModel();

      // Add caregiver to Firestore
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
      firstName: caregiver.firstName,
      lastName: caregiver.lastName,
      email: caregiver.email,
      phone: caregiver.phone,
      city: caregiver.city,
      country: caregiver.country,
      address: caregiver.address,
      professionalSummary: caregiver.professionalSummary,
      imageUrl: caregiver.imageUrl ?? '',
      workHistory: caregiver.workHistory,
      education: caregiver.education,
      certifications: caregiver.certifications,
      trainings: caregiver.trainings,
      references: caregiver.references,
      softSkills: caregiver.softSkills,
      hardSkills: caregiver.hardSkills,
      languages: caregiver.languages,
      hasBackgroundCheck: caregiver.hasBackgroundCheck,
      hasHealthCheckup: caregiver.hasHealthCheckup,
      hasWorkAuthorization: caregiver.hasWorkAuthorization,
      memberships: caregiver.memberships,
      achievements: caregiver.achievements,
      birthdate: caregiver.birthdate,
      gender: caregiver.gender,
      maritalStatus: caregiver.maritalStatus,
    );
  }
}

final caregiverFormProvider = StateNotifierProvider<CaregiverFormNotifier, CaregiverFormState>((ref) {
  final addCaregiver = ref.watch(addCaregiverProvider);
  final updateCaregiver = ref.watch(updateCaregiverProvider);
  final firebaseService = ref.watch(firebaseServiceProvider);
  return CaregiverFormNotifier(addCaregiver, updateCaregiver, firebaseService);
});