import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/entities/work_history.dart';
import '../providers/caregiver_providers.dart';

class WorkHistoryForm extends ConsumerWidget {
  final GlobalKey<FormState> workHistoryFormKey;

  const WorkHistoryForm({super.key, required this.workHistoryFormKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(caregiverFormProvider);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: workHistoryFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.work_history, style: theme.textTheme.headlineSmall),
              TextButton.icon(
                onPressed: () => ref.read(caregiverFormProvider.notifier).addWorkHistory(),
                icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
                label: Text(localizations.add_more,
                    style: TextStyle(color: theme.colorScheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...formState.workHistory.asMap().entries.map((entry) {
            final index = entry.key;
            final job = entry.value;

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
                        Text('${localizations.work_experience} ${index + 1}',
                            style: theme.textTheme.titleMedium),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.delete, color: theme.colorScheme.error),
                            onPressed: () =>
                                ref.read(caregiverFormProvider.notifier).removeWorkHistory(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: job.jobTitle,
                      decoration: InputDecoration(
                        labelText: localizations.job_title,
                        border: const OutlineInputBorder(),
                      ),
                        keyboardType: TextInputType.text,
                      validator: (value) =>
                      value?.isEmpty ?? true ? localizations.please_enter_job_title : null,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateWorkHistory(
                        index,
                        WorkHistory(
                          jobTitle: value,
                          employer: job.employer,
                          startDate: job.startDate,
                          endDate: job.endDate,
                          responsibilities: job.responsibilities,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: job.employer,
                      decoration: InputDecoration(
                        labelText: localizations.employer_name,
                        border: const OutlineInputBorder(),
                      ),
                        keyboardType: TextInputType.text,
                      validator: (value) =>
                      value?.isEmpty ?? true ? localizations.please_enter_employer_name : null,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateWorkHistory(
                        index,
                        WorkHistory(
                          jobTitle: job.jobTitle,
                          employer: value,
                          startDate: job.startDate,
                          endDate: job.endDate,
                          responsibilities: job.responsibilities,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: localizations.start_date,
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: job.startDate ?? DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    ref.read(caregiverFormProvider.notifier).updateWorkHistory(
                                      index,
                                      WorkHistory(
                                        jobTitle: job.jobTitle,
                                        employer: job.employer,
                                        startDate:
                                        DateTime(date.year, date.month, date.day),
                                        endDate: job.endDate,
                                        responsibilities: job.responsibilities,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            controller: TextEditingController(
                              text: job.startDate != null
                                  ? DateFormat('yyyy-MM-dd').format(job.startDate!)
                                  : '',
                            ),
                            validator: (value) =>
                            job.startDate == null ? localizations.required : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: localizations.end_date_or_present,
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: job.endDate ?? DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    ref.read(caregiverFormProvider.notifier).updateWorkHistory(
                                      index,
                                      WorkHistory(
                                        jobTitle: job.jobTitle,
                                        employer: job.employer,
                                        startDate: job.startDate,
                                        endDate: DateTime(date.year, date.month, date.day),
                                        responsibilities: job.responsibilities,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            controller: TextEditingController(
                              text: job.endDate != null
                                  ? DateFormat('yyyy-MM-dd').format(job.endDate!)
                                  : '',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: job.responsibilities,
                      decoration: InputDecoration(
                        labelText: localizations.key_responsibilities,
                        border: const OutlineInputBorder(),
                        hintText: localizations.key_responsibilities_hint,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) => value?.isEmpty ?? true
                          ? localizations.please_enter_responsibilities
                          : null,
                      onChanged: (value) => ref.read(caregiverFormProvider.notifier).updateWorkHistory(
                        index,
                        WorkHistory(
                          jobTitle: job.jobTitle,
                          employer: job.employer,
                          startDate: job.startDate,
                          endDate: job.endDate,
                          responsibilities: value,
                        ),
                      ),
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