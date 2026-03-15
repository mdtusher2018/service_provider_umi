import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/core/theme/app_theme.dart';
import 'package:service_provider_umi/featured/RootScreen.dart';
import 'package:service_provider_umi/featured/provider/upcoming_bookings_screen.dart';

import 'core/di/providers.dart';

// import 'core/localization/app_localizations.dart'; // Uncomment after generating

class App extends ConsumerWidget {
  final AppRole role;
  const App({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appRoleProvider.notifier).setRole(role);
    });

    final locale = ref.watch(localizationProvider);
    final currentRole = ref.watch(appRoleProvider); // reactive

    return MaterialApp(
      title: 'YourAppName',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.of(currentRole),
      themeMode: ThemeMode.system,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr')],
      localizationsDelegates: const [
        // AppLocalizations.delegate, // Uncomment after generating
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: UpcomingBookingsScreen(),
    );
  }
}
