import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/education.dart';
import '../providers/caregiver_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EducationCertificationForm extends ConsumerWidget {
  final GlobalKey<FormState> educationFormKey;
  final GlobalKey<FormState> certificationFormKey;
  final GlobalKey<FormState> trainingFormKey;

  const EducationCertificationForm({
    super.key,
    required this.educationFormKey,
    required this.certificationFormKey,
    required this.trainingFormKey,
  });

  Future<void> _pickImage(WidgetRef ref, int index, String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        if (type == 'certification') {
          ref.read(caregiverFormProvider.notifier).updateCertification(
              index, ref.read(caregiverFormProvider).certifications[index],
              imageBytes: bytes);
        } else if (type == 'training') {
          ref.read(caregiverFormProvider.notifier).updateTraining(
              index, ref.read(caregiverFormProvider).trainings[index],
              imageBytes: bytes);
        }
      } else {
        final file = File(pickedFile.path);
        if (type == 'certification') {
          ref.read(caregiverFormProvider.notifier).updateCertification(
              index, ref.read(caregiverFormProvider).certifications[index],
              imageFile: file);
        } else if (type == 'training') {
          ref.read(caregiverFormProvider.notifier).updateTraining(
              index, ref.read(caregiverFormProvider).trainings[index],
              imageFile: file);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(caregiverFormProvider);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Education Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.education, style: theme.textTheme.headlineSmall),
              TextButton.icon(
                onPressed: () => ref.read(caregiverFormProvider.notifier).addEducation(),
                icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
                label: Text(localizations.add_more,
                    style: TextStyle(color: theme.colorScheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Form(
            key: educationFormKey,
            child: Column(
              children: formState.education.asMap().entries.map((entry) {
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
                            Text('${localizations.education} ${index + 1}',
                                style: theme.textTheme.titleMedium),
                            if (index > 0 && formState.education.length > 1)
                              IconButton(
                                icon: Icon(Icons.delete, color: theme.colorScheme.error),
                                onPressed: () =>
                                    ref.read(caregiverFormProvider.notifier).removeEducation(index),
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
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                          value?.isEmpty ?? true ? localizations.please_enter_degree : null,
                          onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateEducation(
                            index,
                            Education(
                              degree: value,
                              institution: edu.institution,
                              completionDate: edu.completionDate,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: edu.institution,
                          decoration: InputDecoration(
                            labelText: localizations.institution_name,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                          value?.isEmpty ?? true ? localizations.please_enter_institution : null,
                          onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateEducation(
                            index,
                            Education(
                              degree: edu.degree,
                              institution: value,
                              completionDate: edu.completionDate,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: localizations.completion_date,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: edu.completionDate ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  ref.read(caregiverFormProvider.notifier).updateEducation(
                                    index,
                                    Education(
                                      degree: edu.degree,
                                      institution: edu.institution,
                                      completionDate:
                                      DateTime(date.year, date.month, date.day),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          controller: TextEditingController(
                            text: edu.completionDate != null
                                ? DateFormat('yyyy-MM-dd').format(edu.completionDate!)
                                : '',
                          ),
                          validator: (value) =>
                          edu.completionDate == null ? localizations.please_enter_year : null,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Certifications Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.certifications, style: theme.textTheme.headlineSmall),
              TextButton.icon(
                onPressed: () => ref.read(caregiverFormProvider.notifier).addCertification(),
                icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
                label: Text(localizations.add_more,
                    style: TextStyle(color: theme.colorScheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Form(
            key: certificationFormKey,
            child: Column(
              children: formState.certifications.asMap().entries.map((entry) {
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
                            Text('${localizations.certification} ${index + 1}',
                                style: theme.textTheme.titleMedium),
                            if (index > 0 && formState.certifications.length > 1)
                              IconButton(
                                icon: Icon(Icons.delete, color: theme.colorScheme.error),
                                onPressed: () => ref
                                    .read(caregiverFormProvider.notifier)
                                    .removeCertification(index),
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
                          keyboardType: TextInputType.text,
                          validator: (value) => value?.isEmpty ?? true
                              ? localizations.please_enter_certification_name
                              : null,
                          onChanged: (value) => ref
                              .read(caregiverFormProvider.notifier)
                              .updateCertification(index, cert.copyWith(name: value)),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: cert.issuer,
                          decoration: InputDecoration(
                            labelText: localizations.issuing_organization,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                          value?.isEmpty ?? true ? localizations.required : null,
                          onChanged: (value) => ref
                              .read(caregiverFormProvider.notifier)
                              .updateCertification(index, cert.copyWith(issuer: value)),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: localizations.issue_date,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: cert.issueDate ?? DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (date != null) {
                                        ref.read(caregiverFormProvider.notifier).updateCertification(
                                          index,
                                          cert.copyWith(
                                              issueDate:
                                              DateTime(date.year, date.month, date.day)),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                controller: TextEditingController(
                                  text: cert.issueDate != null
                                      ? DateFormat('yyyy-MM-dd').format(cert.issueDate!)
                                      : '',
                                ),
                                validator: (value) =>
                                cert.issueDate == null ? localizations.required : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: localizations.expiry_date_if_any,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: cert.expiryDate ?? DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (date != null) {
                                        ref.read(caregiverFormProvider.notifier).updateCertification(
                                          index,
                                          cert.copyWith(
                                              expiryDate:
                                              DateTime(date.year, date.month, date.day)),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                controller: TextEditingController(
                                  text: cert.expiryDate != null
                                      ? DateFormat('yyyy-MM-dd').format(cert.expiryDate!)
                                      : '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: cert.imageUrl.isNotEmpty
                                  ? Image.network(cert.imageUrl, height: 100, fit: BoxFit.cover)
                                  : cert.imageFile != null
                                  ? Image.file(cert.imageFile!, height: 100, fit: BoxFit.cover)
                                  : cert.imageBytes != null
                                  ? Image.memory(cert.imageBytes!, height: 100, fit: BoxFit.cover)
                                  : const Text('No image selected'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () => _pickImage(ref, index, 'certification'),
                              icon: const Icon(Icons.upload),
                              label: Text(localizations.upload_image),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Trainings Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.trainings, style: theme.textTheme.headlineSmall),
              TextButton.icon(
                onPressed: () => ref.read(caregiverFormProvider.notifier).addTraining(),
                icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
                label: Text(localizations.add_more,
                    style: TextStyle(color: theme.colorScheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Form(
            key: trainingFormKey,
            child: Column(
              children: formState.trainings.asMap().entries.map((entry) {
                final index = entry.key;
                final train = entry.value;

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
                            Text('${localizations.training} ${index + 1}',
                                style: theme.textTheme.titleMedium),
                            if (index > 0 && formState.trainings.length > 1)
                              IconButton(
                                icon: Icon(Icons.delete, color: theme.colorScheme.error),
                                onPressed: () =>
                                    ref.read(caregiverFormProvider.notifier).removeTraining(index),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: train.name,
                          decoration: InputDecoration(
                            labelText: localizations.training_name,
                            border: const OutlineInputBorder(),
                            hintText: localizations.training_name_hint,
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) => value?.isEmpty ?? true
                              ? localizations.please_enter_training_name
                              : null,
                          onChanged: (value) => ref
                              .read(caregiverFormProvider.notifier)
                              .updateTraining(index, train.copyWith(name: value)),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: train.issuer,
                          decoration: InputDecoration(
                            labelText: localizations.issuing_organization,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                          value?.isEmpty ?? true ? localizations.required : null,
                          onChanged: (value) => ref
                              .read(caregiverFormProvider.notifier)
                              .updateTraining(index, train.copyWith(issuer: value)),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: localizations.issue_date,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: train.issueDate ?? DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (date != null) {
                                        ref.read(caregiverFormProvider.notifier).updateTraining(
                                          index,
                                          train.copyWith(
                                              issueDate:
                                              DateTime(date.year, date.month, date.day)),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                controller: TextEditingController(
                                  text: train.issueDate != null
                                      ? DateFormat('yyyy-MM-dd').format(train.issueDate!)
                                      : '',
                                ),
                                validator: (value) =>
                                train.issueDate == null ? localizations.required : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: localizations.expiry_date_if_any,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: train.expiryDate ?? DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (date != null) {
                                        ref.read(caregiverFormProvider.notifier).updateTraining(
                                          index,
                                          train.copyWith(
                                              expiryDate:
                                              DateTime(date.year, date.month, date.day)),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                controller: TextEditingController(
                                  text: train.expiryDate != null
                                      ? DateFormat('yyyy-MM-dd').format(train.expiryDate!)
                                      : '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: train.imageUrl.isNotEmpty
                                  ? Image.network(train.imageUrl, height: 100, fit: BoxFit.cover)
                                  : train.imageFile != null
                                  ? Image.file(train.imageFile!, height: 100, fit: BoxFit.cover)
                                  : train.imageBytes != null
                                  ? Image.memory(train.imageBytes!, height: 100, fit: BoxFit.cover)
                                  : const Text('No image selected'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () => _pickImage(ref, index, 'training'),
                              icon: const Icon(Icons.upload),
                              label: Text(localizations.upload_image),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}