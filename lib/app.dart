import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/featured/provider/provider_onboarding.dart';
import 'core/di/providers.dart';
import 'core/theme/app_theme.dart';

// import 'core/localization/app_localizations.dart'; // Uncomment after generating

class App extends ConsumerWidget {
  final AppRole role;
  const App({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localizationProvider);

    return MaterialApp(
      title: 'YourAppName',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,

      themeMode: ThemeMode.system,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr')],
      localizationsDelegates: const [
        // AppLocalizations.delegate, // Uncomment after generating
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: ServiceProviderOnboardingScreen(),
    );
    //  MaterialApp.router(
    //   title: 'YourAppName',
    //   debugShowCheckedModeBanner: false,
    //   theme: AppTheme.light,

    //   themeMode: ThemeMode.system,
    //   locale: locale,
    //   supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr')],
    //   localizationsDelegates: const [
    //     // AppLocalizations.delegate, // Uncomment after generating
    //     GlobalMaterialLocalizations.delegate,
    //     GlobalWidgetsLocalizations.delegate,
    //     GlobalCupertinoLocalizations.delegate,
    //   ],
    //   routerConfig: router,
    // );
  }
}
