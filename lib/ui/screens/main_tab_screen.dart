import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/locale_provider.dart';
import 'home_screen.dart';
import 'downloads_screen.dart';
import 'settings_screen.dart';

class MainTabScreen extends ConsumerStatefulWidget {
  const MainTabScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends ConsumerState<MainTabScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const DownloadsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(ref.watch(localeProvider));
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ]
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          showUnselectedLabels: true,
          elevation: 0,
          backgroundColor: Theme.of(context).cardColor,
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: loc.get('home')),
            BottomNavigationBarItem(icon: const Icon(Icons.download_outlined), activeIcon: const Icon(Icons.download), label: loc.get('downloads')),
            BottomNavigationBarItem(icon: const Icon(Icons.settings_outlined), activeIcon: const Icon(Icons.settings), label: loc.get('settings')),
          ],
        ),
      ),
    );
  }
}
