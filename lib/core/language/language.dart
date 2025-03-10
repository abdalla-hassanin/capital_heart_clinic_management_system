import 'package:flutter/material.dart';

enum Language {
  english(Locale('en'), "🇺🇸", 'English'),
  arabic(Locale('ar'), "🇸🇦", 'اَلْعَرَبِيَّةُ');

  final Locale value;
  final String flag;
  final String text;

  const Language(this.value, this.flag, this.text);
}