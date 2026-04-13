import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';

Future<String> getMyUserId(WidgetRef ref) async {
  final String token =
      await ref.read(localStorageProvider).read(StorageKey.accessToken) ?? "";
  try {
    final parts = token.split('.');
    if (parts.length != 3) return "";

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final payloadBytes = base64Url.decode(normalized);
    final payloadString = utf8.decode(payloadBytes);

    return (json.decode(payloadString) as Map<String, dynamic>)['userId'];
  } catch (e) {
    return "";
  }
}
