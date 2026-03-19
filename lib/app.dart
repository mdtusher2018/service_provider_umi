import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_theme.dart';
import 'package:service_provider_umi/featured/authentication/welcome_screen.dart';
import 'core/di/providers.dart';

// import 'core/localization/app_localizations.dart'; // Uncomment after generating

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localizationProvider);
    final currentRole = ref.watch(appRoleProvider);

    return MaterialApp(
      title: 'YourAppName',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.of(currentRole),
      themeMode: ThemeMode.system,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: WelcomeScreen(),
    );
  }
}
