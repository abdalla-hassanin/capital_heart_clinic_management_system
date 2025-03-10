import 'package:capital_heart_clinic_management_system/core/core_provider/core_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/language/language.dart';
import '../widgets/personal_info_form.dart';
import '../widgets/work_history_form.dart';
import '../widgets/education_certification_form.dart';
import '../widgets/references_form.dart';
import '../widgets/skills_form.dart';
import '../widgets/documents_form.dart';
import '../providers/caregiver_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCaregiverScreen extends ConsumerStatefulWidget {
  const AddCaregiverScreen({super.key});

  @override
  ConsumerState<AddCaregiverScreen> createState() => _AddCaregiverScreenState();
}

class _AddCaregiverScreenState extends ConsumerState<AddCaregiverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _workHistoryFormKey = GlobalKey<FormState>();
  final _educationFormKey = GlobalKey<FormState>();
  final _referenceFormKey = GlobalKey<FormState>();
  final _skillsFormKey = GlobalKey<FormState>();
  int _currentStep = 0;

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _professionalSummaryController;
  late final TextEditingController _languageController;
  late final TextEditingController _membershipController;
  late final TextEditingController _achievementsController;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(caregiverFormProvider);
    _fullNameController = TextEditingController(text: initialState.fullName);
    _phoneController = TextEditingController(text: initialState.phone);
    _emailController = TextEditingController(text: initialState.email);
    _addressController = TextEditingController(text: initialState.address);
    _professionalSummaryController = TextEditingController(text: initialState.professionalSummary);
    _languageController = TextEditingController(text: initialState.languages);
    _membershipController = TextEditingController(text: initialState.memberships);
    _achievementsController = TextEditingController(text: initialState.achievements);

    _fullNameController.addListener(() {
      ref.read(caregiverFormProvider.notifier).updatePersonalInfo(fullName: _fullNameController.text);
    });
    _phoneController.addListener(() {
      ref.read(caregiverFormProvider.notifier).updatePersonalInfo(phone: _phoneController.text);
    });
    _emailController.addListener(() {
      ref.read(caregiverFormProvider.notifier).updatePersonalInfo(email: _emailController.text);
    });
    _addressController.addListener(() {
      ref.read(caregiverFormProvider.notifier).updatePersonalInfo(address: _addressController.text);
    });
    _professionalSummaryController.addListener(() {
      ref.read(caregiverFormProvider.notifier).updatePersonalInfo(professionalSummary: _professionalSummaryController.text);
    });
    _languageController.addListener(() {
      ref.read(caregiverFormProvider.notifier).updateLanguages(_languageController.text);
    });
    _membershipController.addListener(() {
      ref.read(caregiverFormProvider.notifier).updateMemberships(_membershipController.text);
    });
    _achievementsController.addListener(() {
      ref.read(caregiverFormProvider.notifier).updateAchievements(_achievementsController.text);
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _professionalSummaryController.dispose();
    _languageController.dispose();
    _membershipController.dispose();
    _achievementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(caregiverFormProvider);
    final coreState = ref.watch(coreNotifierProvider);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.add_new_caregiver),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              coreState.language == Language.english ? Icons.language : Icons.translate,
              color: theme.appBarTheme.actionsIconTheme?.color,
            ),
            tooltip: coreState.language == Language.english ? localizations.switch_to_arabic : localizations.switch_to_english,
            onPressed: () {
              ref.read(coreNotifierProvider.notifier).toggleLanguage();
            },
          ),
          IconButton(
            icon: Icon(
              coreState.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
              color: theme.appBarTheme.actionsIconTheme?.color,
            ),
            tooltip: coreState.themeMode == ThemeMode.light ? localizations.switch_to_dark_mode : localizations.switch_to_light_mode,
            onPressed: () {
              ref.read(coreNotifierProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () async {
            bool isLastStep = _currentStep == 5;
            if (isLastStep) {
              await _submitForm();
            } else {
              if (_validateCurrentStep()) {
                setState(() => _currentStep += 1);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.please_fill_all_required_fields),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              }
            }
          },
          onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
          onStepTapped: null,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: formState.isLoading ? null : details.onStepContinue,
                    child: formState.isLoading
                        ? CircularProgressIndicator(
                      color: theme.colorScheme.onPrimary,
                    )
                        : Text(_currentStep == 5 ? localizations.submit : localizations.next),
                  ),
                  const SizedBox(width: 12),
                  if (_currentStep != 0)
                    TextButton(
                      onPressed: formState.isLoading ? null : details.onStepCancel,
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      child: Text(localizations.back),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text(localizations.personal_information),
              content: PersonalInfoForm(
                personalInfoFormKey: _personalInfoFormKey,
                fullNameController: _fullNameController,
                phoneController: _phoneController,
                emailController: _emailController,
                addressController: _addressController,
                professionalSummaryController: _professionalSummaryController,
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 && (_personalInfoFormKey.currentState?.validate() ?? false)
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: Text(localizations.work_history),
              content: WorkHistoryForm(workHistoryFormKey: _workHistoryFormKey),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 && (_workHistoryFormKey.currentState?.validate() ?? false)
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: Text(localizations.education_certifications),
              content: EducationCertificationForm(educationFormKey: _educationFormKey),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 && (_educationFormKey.currentState?.validate() ?? false)
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: Text(localizations.references_testimonials),
              content: ReferencesForm(referenceFormKey: _referenceFormKey),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 && (_referenceFormKey.currentState?.validate() ?? false)
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: Text(localizations.skills_competencies),
              content: SkillsForm(skillsFormKey: _skillsFormKey, languageController: _languageController),
              isActive: _currentStep >= 4,
              state: _currentStep > 4 && (_skillsFormKey.currentState?.validate() ?? false)
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: Text(localizations.documents_memberships),
              content: DocumentsForm(
                membershipController: _membershipController,
                achievementsController: _achievementsController,
              ),
              isActive: _currentStep >= 5,
              state: _currentStep > 5 ? StepState.complete : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _personalInfoFormKey.currentState?.validate() ?? false;
      case 1:
        return _workHistoryFormKey.currentState?.validate() ?? false;
      case 2:
        return _educationFormKey.currentState?.validate() ?? false;
      case 3:
        return _referenceFormKey.currentState?.validate() ?? false;
      case 4:
        return _skillsFormKey.currentState?.validate() ?? false;
      default:
        return true;
    }
  }

  bool _validateAllSteps() {
    return (_personalInfoFormKey.currentState?.validate() ?? false) &&
        (_workHistoryFormKey.currentState?.validate() ?? false) &&
        (_educationFormKey.currentState?.validate() ?? false) &&
        (_referenceFormKey.currentState?.validate() ?? false) &&
        (_skillsFormKey.currentState?.validate() ?? false);
  }

  Future<void> _submitForm() async {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (_validateAllSteps()) {
      final success = await ref.read(caregiverFormProvider.notifier).submitForm();
      if (success && mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(localizations.success),
            content: Text(localizations.caregiver_added_successfully),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(localizations.ok),
              ),
            ],
          ),
        );
      } else if (mounted) {
        final error = ref.read(caregiverFormProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${localizations.error}: ${error ?? localizations.failed_to_add_caregiver}'),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.please_fill_all_steps),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        setState(() {
          _currentStep = _findFirstInvalidStep();
        });
      }
    }
  }

  int _findFirstInvalidStep() {
    if (!(_personalInfoFormKey.currentState?.validate() ?? false)) return 0;
    if (!(_workHistoryFormKey.currentState?.validate() ?? false)) return 1;
    if (!(_educationFormKey.currentState?.validate() ?? false)) return 2;
    if (!(_referenceFormKey.currentState?.validate() ?? false)) return 3;
    if (!(_skillsFormKey.currentState?.validate() ?? false)) return 4;
    return 5;
  }
}