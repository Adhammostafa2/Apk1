import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_provider.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return Locale(prefs.getString('lang') ?? 'en');
  }

  void setLocale(Locale locale) {
    final prefs = ref.read(sharedPreferencesProvider);
    state = locale;
    prefs.setString('lang', locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
