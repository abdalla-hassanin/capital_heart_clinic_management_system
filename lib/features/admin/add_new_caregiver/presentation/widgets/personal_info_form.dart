import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalInfoForm extends StatelessWidget {
  final GlobalKey<FormState> personalInfoFormKey;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController professionalSummaryController;

  const PersonalInfoForm({
    super.key,
    required this.personalInfoFormKey,
    required this.fullNameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.professionalSummaryController,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: personalInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.personal_information, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextFormField(
            controller: fullNameController,
            decoration: InputDecoration(
              labelText: localizations.full_name,
              border: const OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_full_name : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: localizations.phone_number,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_phone_number : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: localizations.email_address,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return localizations.please_enter_email_address;
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) return localizations.please_enter_valid_email;
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: localizations.address,
              border: const OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_address : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: professionalSummaryController,
            decoration: InputDecoration(
              labelText: localizations.professional_summary,
              border: const OutlineInputBorder(),
              hintText: localizations.professional_summary_hint,
            ),
            maxLines: 3,
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_professional_summary : null,
          ),
        ],
      ),
    );
  }
}