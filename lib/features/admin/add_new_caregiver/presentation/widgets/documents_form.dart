import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/caregiver_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DocumentsForm extends ConsumerWidget {
  final TextEditingController membershipController;
  final TextEditingController achievementsController;

  const DocumentsForm({
    super.key,
    required this.membershipController,
    required this.achievementsController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(caregiverFormProvider);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.documents_memberships, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: Text(localizations.criminal_background_check_clearance),
          value: formState.hasBackgroundCheck,
          onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateDocuments(hasBackgroundCheck: value),
          activeColor: theme.colorScheme.primary,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          title: Text(localizations.health_checkup_report),
          value: formState.hasHealthCheckup,
          onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateDocuments(hasHealthCheckup: value),
          activeColor: theme.colorScheme.primary,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          title: Text(localizations.work_authorization),
          value: formState.hasWorkAuthorization,
          onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateDocuments(hasWorkAuthorization: value),
          activeColor: theme.colorScheme.primary,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Implement document upload with Firebase Storage
          },
          icon: Icon(Icons.upload_file, color: theme.colorScheme.primary),
          label: Text(localizations.upload_documents),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            foregroundColor: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(localizations.professional_memberships_achievements, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextFormField(
          controller: membershipController,
          decoration: InputDecoration(
            labelText: localizations.professional_memberships,
            border: const OutlineInputBorder(),
            hintText: localizations.professional_memberships_hint,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: achievementsController,
          decoration: InputDecoration(
            labelText: localizations.awards_achievements,
            border: const OutlineInputBorder(),
            hintText: localizations.awards_achievements_hint,
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}