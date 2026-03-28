import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/di/data_source_provider.dart';
import 'package:service_provider_umi/data/repository/auth_repository.dart';
import 'package:service_provider_umi/data/repository/service_repository.dart';
import 'package:service_provider_umi/data/repository/notification_repository.dart';
import 'package:service_provider_umi/data/repository/user_repository.dart';

part 'repository_providers.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(
  remote: ref.read(authRemoteDataSourceProvider),
  local: ref.read(localStorageProvider),
);

@riverpod
UserRepository userRepository(Ref ref) =>
    UserRepository(remote: ref.read(userRemoteDataSourceProvider));

@riverpod
NotificationRepository notificationRepository(Ref ref) =>
    NotificationRepository(
      remote: ref.read(notificationRemoteDataSourceProvider),
    );

@riverpod
ServiceRepository serviceRepository(Ref ref) =>
    ServiceRepository(remote: ref.read(serviceRemoteDataSourceProvider));

@riverpod
ContentRepository contentRepository(Ref ref) =>
    ContentRepository(remote: ref.read(contentRemoteDataSourceProvider));
