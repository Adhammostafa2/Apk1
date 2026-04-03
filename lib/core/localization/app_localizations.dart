import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'ADownloader',
      'home': 'Home',
      'downloads': 'Downloads',
      'settings': 'Settings',
      'paste_link': 'Paste video link here...',
      'download_btn': 'Analyze Video',
      'downloading': 'Downloading...',
      'completed': 'Completed',
      'failed': 'Failed',
      'language': 'Language',
      'theme': 'Dark Mode',
      'invalid_url': 'Invalid URL',
      'analyze': 'Analyzing...',
      'preview': 'Preview',
      'download': 'Download',
      'quality': 'Quality',
    },
    'ar': {
      'app_name': 'إي داونلودر',
      'home': 'الرئيسية',
      'downloads': 'التنزيلات',
      'settings': 'الإعدادات',
      'paste_link': 'الصق رابط الفيديو هنا...',
      'download_btn': 'تحليل الفيديو',
      'downloading': 'جاري التنزيل...',
      'completed': 'مكتمل',
      'failed': 'فشل',
      'language': 'اللغة',
      'theme': 'الوضع الليلي',
      'invalid_url': 'رابط غير صالح',
      'analyze': 'جاري التحليل...',
      'preview': 'معاينة',
      'download': 'تحميل',
      'quality': 'الجودة',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}
