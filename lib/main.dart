import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';

import 'app.dart';

Future<void> main() async {
  runApp(
    ProviderScope(
      overrides: [
        appRoleProvider.overrideWith(() => AppRoleNotifier(AppRole.guest)),
      ],
      child: const App(),
    ),
  );
}
