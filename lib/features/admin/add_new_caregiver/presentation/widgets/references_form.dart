import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/reference.dart';
import '../providers/caregiver_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReferencesForm extends ConsumerWidget {
  final GlobalKey<FormState> referenceFormKey;

  const ReferencesForm({super.key, required this.referenceFormKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(caregiverFormProvider);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: referenceFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.references_testimonials, style: theme.textTheme.headlineSmall),
              TextButton.icon(
                onPressed: () => ref.read(caregiverFormProvider.notifier).addReference(),
                icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
                label: Text(localizations.add_more, style: TextStyle(color: theme.colorScheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...formState.references.asMap().entries.map((entry) {
            final index = entry.key;
            final refData = entry.value;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${localizations.reference} ${index + 1}', style: theme.textTheme.titleMedium),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.delete, color: theme.colorScheme.error),
                            onPressed: () => ref.read(caregiverFormProvider.notifier).removeReference(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: refData.name,
                      decoration: InputDecoration(
                        labelText: localizations.reference_name,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_reference_name : null,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateReference(
                        index,
                        Reference(
                          name: value,
                          relationship: refData.relationship,
                          contactInfo: refData.contactInfo,
                          testimonial: refData.testimonial,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: refData.relationship,
                      decoration: InputDecoration(
                        labelText: localizations.relationship,
                        border: const OutlineInputBorder(),
                        hintText: localizations.relationship_hint,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_relationship : null,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateReference(
                        index,
                        Reference(
                          name: refData.name,
                          relationship: value,
                          contactInfo: refData.contactInfo,
                          testimonial: refData.testimonial,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: refData.contactInfo,
                      decoration: InputDecoration(
                        labelText: localizations.contact_information,
                        border: const OutlineInputBorder(),
                        hintText: localizations.contact_information_hint,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_contact_information : null,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateReference(
                        index,
                        Reference(
                          name: refData.name,
                          relationship: refData.relationship,
                          contactInfo: value,
                          testimonial: refData.testimonial,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: refData.testimonial,
                      decoration: InputDecoration(
                        labelText: localizations.testimonial_recommendation_if_available,
                        border: const OutlineInputBorder(),
                        hintText: localizations.testimonial_hint,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateReference(
                        index,
                        Reference(
                          name: refData.name,
                          relationship: refData.relationship,
                          contactInfo: refData.contactInfo,
                          testimonial: value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Text(localizations.upload_recommendation_letters_optional, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement file upload with Firebase Storage
            },
            icon: Icon(Icons.upload_file, color: theme.colorScheme.primary),
            label: Text(localizations.upload_documents),
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