import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../language/language.dart';
import 'core_state.dart';

enum SharedKeys { language, themeMode }

final coreNotifierProvider =
    StateNotifierProvider<CoreNotifier, CoreState>((ref) {
  return CoreNotifier();
});

class CoreNotifier extends StateNotifier<CoreState> {
  CoreNotifier() : super(CoreState(Language.english, ThemeMode.system)) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final languagePref = prefs.getString(SharedKeys.language.name);
    final themePref = prefs.getString(SharedKeys.themeMode.name);

    Language language = Language.english;
    // ThemeMode themeMode = ThemeMode.system;
    ThemeMode themeMode = ThemeMode.light;

    if (languagePref != null) {
      language = Language.values.firstWhere(
        (item) => item.value.languageCode == languagePref,
        orElse: () => Language.english,
      );
    }

    if (themePref != null) {
      themeMode =
          themePref == ThemeMode.light.name ? ThemeMode.light : ThemeMode.dark;
    }

    state = CoreState(language, themeMode);
  }

  Future<void> setCoreSettings(
      {Language? language, ThemeMode? themeMode}) async {
    final prefs = await SharedPreferences.getInstance();
    final newLanguage = language ?? state.language;
    final newTheme = themeMode ?? state.themeMode;

    await prefs.setString(
        SharedKeys.language.name, newLanguage.value.languageCode);
    await prefs.setString(SharedKeys.themeMode.name, newTheme.name);

    state = CoreState(newLanguage, newTheme);
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newTheme =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await prefs.setString(SharedKeys.themeMode.name, newTheme.name);
    state = CoreState(state.language, newTheme);
  }

  Future<void> toggleLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final newLanguage =
        state.language == Language.english ? Language.arabic : Language.english;

    await prefs.setString(
        SharedKeys.language.name, newLanguage.value.languageCode);
    state = CoreState(newLanguage, state.themeMode);
  }
}
