import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../core/localization/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final loc = AppLocalizations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.get('settings'), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Theme.of(context).primaryColor),
              title: Text(loc.get('theme'), style: const TextStyle(fontWeight: FontWeight.bold)),
              value: isDark,
              onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: Icon(Icons.language, color: Theme.of(context).primaryColor),
              title: Text(loc.get('language'), style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: DropdownButton<String>(
                value: locale.languageCode,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'ar', child: Text('العربية')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    ref.read(localeProvider.notifier).setLocale(Locale(val));
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
