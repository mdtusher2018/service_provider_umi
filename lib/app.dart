import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/localization/locale_provider.dart';
import 'package:service_provider_umi/core/router/app_router.dart';
import 'package:service_provider_umi/core/theme/app_theme.dart';
import 'package:service_provider_umi/web_app_shell.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localizationProvider);
    final currentRole = ref.watch(appRoleProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'iUmi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.of(currentRole),
      themeMode: ThemeMode.system,
      locale: locale.value,
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr')],

      builder: (context, child) {
        if (kIsWeb) {
          return WebAppShell(child: child!);
        }
        return child!;
      },

      routerConfig: router,
    );
  }
}
