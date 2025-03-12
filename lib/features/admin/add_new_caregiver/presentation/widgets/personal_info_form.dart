import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../providers/caregiver_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalInfoForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> personalInfoFormKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final TextEditingController countryController;
  final TextEditingController addressController;
  final TextEditingController professionalSummaryController;

  const PersonalInfoForm({
    super.key,
    required this.personalInfoFormKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.cityController,
    required this.countryController,
    required this.addressController,
    required this.professionalSummaryController,
  });

  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends ConsumerState<PersonalInfoForm> {
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        ref.read(caregiverFormProvider.notifier).updatePersonalInfo(imageBytes: bytes);
      } else {
        final imageFile = File(pickedFile.path);
        ref.read(caregiverFormProvider.notifier).updatePersonalInfo(imageFile: imageFile);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final formState = ref.read(caregiverFormProvider);
    widget.firstNameController.text = formState.firstName;
    widget.lastNameController.text = formState.lastName;
    widget.phoneController.text = formState.phone;
    widget.emailController.text = formState.email;
    widget.cityController.text = formState.city;
    widget.countryController.text = formState.country;
    widget.addressController.text = formState.address;
    widget.professionalSummaryController.text = formState.professionalSummary;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final formState = ref.watch(caregiverFormProvider);

    return Form(
      key: widget.personalInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.personal_information, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.firstNameController,
            decoration: InputDecoration(
              labelText: localizations.first_name,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_first_name : null,
            onChanged: (value) => ref.read(caregiverFormProvider.notifier).updatePersonalInfo(firstName: value),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.lastNameController,
            decoration: InputDecoration(
              labelText: localizations.last_name,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_last_name : null,
            onChanged: (value) => ref.read(caregiverFormProvider.notifier).updatePersonalInfo(lastName: value),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.phoneController,
            decoration: InputDecoration(
              labelText: localizations.phone_number,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_phone_number : null,
            onChanged: (value) => ref.read(caregiverFormProvider.notifier).updatePersonalInfo(phone: value),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.emailController,
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
            onChanged: (value) => ref.read(caregiverFormProvider.notifier).updatePersonalInfo(email: value),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.cityController,
            decoration: InputDecoration(
              labelText: localizations.city,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_city : null,
            onChanged: (value) => ref.read(caregiverFormProvider.notifier).updatePersonalInfo(city: value),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.countryController,
            decoration: InputDecoration(
              labelText: localizations.country,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_country : null,
            onChanged: (value) => ref.read(caregiverFormProvider.notifier).updatePersonalInfo(country: value),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.addressController,
            decoration: InputDecoration(
              labelText: localizations.address_details,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_address_details : null,
            onChanged: (value) => ref.read(caregiverFormProvider.notifier).updatePersonalInfo(address: value),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.professionalSummaryController,
            decoration: InputDecoration(
              labelText: localizations.professional_summary,
              border: const OutlineInputBorder(),
              hintText: localizations.professional_summary_hint,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            validator: (value) => value?.isEmpty ?? true ? localizations.please_enter_professional_summary : null,
            onChanged: (value) => ref.read(caregiverFormProvider.notifier).updatePersonalInfo(professionalSummary: value),
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              labelText: localizations.birthdate,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: formState.birthdate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    ref.read(caregiverFormProvider.notifier).updateBirthdate(pickedDate);
                  }
                },
              ),
            ),
            keyboardType: TextInputType.datetime,
            readOnly: true,
            controller: TextEditingController(
              text: formState.birthdate != null
                  ? DateFormat('yyyy-MM-dd').format(formState.birthdate!)
                  : '',
            ),
            validator: (value) => formState.birthdate == null ? localizations.please_select_birthdate : null,
          ),
          const SizedBox(height: 12),
          Text('${localizations.age}: ${formState.age ?? "Not calculated"}', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: localizations.gender,
              border: const OutlineInputBorder(),
            ),
            value: formState.gender.isEmpty ? null : formState.gender,
            items: [
              DropdownMenuItem(value: 'Male', child: Text(localizations.male)),
              DropdownMenuItem(value: 'Female', child: Text(localizations.female)),
              DropdownMenuItem(value: 'Other', child: Text(localizations.other)),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(caregiverFormProvider.notifier).updateGender(value);
              }
            },
            validator: (value) => value == null ? localizations.please_select_gender : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: localizations.marital_status,
              border: const OutlineInputBorder(),
            ),
            value: formState.maritalStatus.isEmpty ? null : formState.maritalStatus,
            items: [
              DropdownMenuItem(value: 'Single', child: Text(localizations.single)),
              DropdownMenuItem(value: 'Married', child: Text(localizations.married)),
              DropdownMenuItem(value: 'Divorced', child: Text(localizations.divorced)),
              DropdownMenuItem(value: 'Widowed', child: Text(localizations.widowed)),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(caregiverFormProvider.notifier).updateMaritalStatus(value);
              }
            },
            validator: (value) => value == null ? localizations.please_select_marital_status : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (formState.imageFile != null && !kIsWeb)
                Image.file(formState.imageFile!, height: 100, width: 100, fit: BoxFit.cover),
              if (formState.imageBytes != null && kIsWeb)
                Image.memory(formState.imageBytes!, height: 100, width: 100, fit: BoxFit.cover),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: formState.isLoading ? null : _pickImage,
                icon: const Icon(Icons.upload),
                label: Text(localizations.upload_image),
              ),
            ],
          ),
          if (formState.imageUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Uploaded Image URL: ${formState.imageUrl}', style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}