import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/education.dart';
import '../../domain/entities/certification.dart';
import '../providers/caregiver_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EducationCertificationForm extends ConsumerWidget {
  final GlobalKey<FormState> educationFormKey;

  const EducationCertificationForm({super.key, required this.educationFormKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(caregiverFormProvider);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: educationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.education_certifications, style: theme.textTheme.headlineSmall),
              TextButton.icon(
                onPressed: () => ref.read(caregiverFormProvider.notifier).addEducation(),
                icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
                label: Text(localizations.add_more, style: TextStyle(color: theme.colorScheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...formState.education.asMap().entries.map((entry) {
            final index = entry.key;
            final edu = entry.value;

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
                        Text('${localizations.education} ${index + 1}', style: theme.textTheme.titleMedium),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.delete, color: theme.colorScheme.error),
                            onPressed: () => ref.read(caregiverFormProvider.notifier).removeEducation(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: edu.degree,
                      decoration: InputDecoration(
                        labelText: localizations.degree_certification,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_degree : null,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateEducation(
                        index,
                        Education(degree: value, institution: edu.institution, year: edu.year),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: edu.institution,
                      decoration: InputDecoration(
                        labelText: localizations.institution_name,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_institution : null,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateEducation(
                        index,
                        Education(degree: edu.degree, institution: value, year: edu.year),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: edu.year,
                      decoration: InputDecoration(
                        labelText: localizations.year,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_year : null,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateEducation(
                        index,
                        Education(degree: edu.degree, institution: edu.institution, year: value),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.certifications_training, style: theme.textTheme.headlineSmall),
              TextButton.icon(
                onPressed: () => ref.read(caregiverFormProvider.notifier).addCertification(),
                icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
                label: Text(localizations.add_more, style: TextStyle(color: theme.colorScheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...formState.certifications.asMap().entries.map((entry) {
            final index = entry.key;
            final cert = entry.value;

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
                        Text('${localizations.certification} ${index + 1}', style: theme.textTheme.titleMedium),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.delete, color: theme.colorScheme.error),
                            onPressed: () => ref.read(caregiverFormProvider.notifier).removeCertification(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: cert.name,
                      decoration: InputDecoration(
                        labelText: localizations.certification_name,
                        border: const OutlineInputBorder(),
                        hintText: localizations.certification_name_hint,
                      ),
                      validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_certification_name : null,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateCertification(
                        index,
                        Certification(
                          name: value,
                          issuer: cert.issuer,
                          issueDate: cert.issueDate,
                          expiryDate: cert.expiryDate,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: cert.issuer,
                      decoration: InputDecoration(
                        labelText: localizations.issuing_organization,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateCertification(
                        index,
                        Certification(
                          name: cert.name,
                          issuer: value,
                          issueDate: cert.issueDate,
                          expiryDate: cert.expiryDate,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: cert.issueDate,
                            decoration: InputDecoration(
                              labelText: localizations.issue_date,
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateCertification(
                              index,
                              Certification(
                                name: cert.name,
                                issuer: cert.issuer,
                                issueDate: value,
                                expiryDate: cert.expiryDate,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: cert.expiryDate,
                            decoration: InputDecoration(
                              labelText: localizations.expiry_date_if_any,
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateCertification(
                              index,
                              Certification(
                                name: cert.name,
                                issuer: cert.issuer,
                                issueDate: cert.issueDate,
                                expiryDate: value,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}