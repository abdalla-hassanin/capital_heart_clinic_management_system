import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/caregiver_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SkillsForm extends ConsumerWidget {
  final GlobalKey<FormState> skillsFormKey;
  final TextEditingController languageController;

  const SkillsForm({super.key, required this.skillsFormKey, required this.languageController});

  static const List<String> softSkillsList = [
    'Patience',
    'Empathy',
    'Communication',
    'Problem-solving',
    'Time Management',
    'Adaptability',
    'Reliability',
    'Teamwork'
  ];

  static const List<String> hardSkillsList = [
    'Personal Hygiene & Grooming Assistance',
    'Meal Preparation & Nutrition Planning',
    'Mobility Assistance & Transfers',
    'Medication Reminders & Administration',
    'Vital Signs Monitoring',
    'First Aid',
    'Dementia Care',
    'Special Needs Care'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(caregiverFormProvider);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: skillsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.skills_competencies, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(localizations.soft_skills, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: softSkillsList.map((skill) {
              final isSelected = formState.softSkills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: isSelected,
                onSelected: (selected) => ref.read(caregiverFormProvider.notifier).toggleSoftSkill(skill),
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(localizations.hard_skills, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hardSkillsList.map((skill) {
              final isSelected = formState.hardSkills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: isSelected,
                onSelected: (selected) => ref.read(caregiverFormProvider.notifier).toggleHardSkill(skill),
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(localizations.language_proficiency, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: languageController,
            decoration: InputDecoration(
              labelText: localizations.languages_separated_by_commas,
              border: const OutlineInputBorder(),
              hintText: localizations.languages_hint,
            ),
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_language : null,
          ),
          const SizedBox(height: 24),
          Text(localizations.work_samples_optional, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement file upload with Firebase Storage
            },
            icon: Icon(Icons.upload_file, color: theme.colorScheme.primary),
            label: Text(localizations.upload_care_plans),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement file upload with Firebase Storage
            },
            icon: Icon(Icons.photo, color: theme.colorScheme.primary),
            label: Text(localizations.upload_activity_photos),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}