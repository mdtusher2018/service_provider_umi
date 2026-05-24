import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/di/data_source_provider.dart';
import 'package:service_provider_umi/data/repository/address_repository.dart';
import 'package:service_provider_umi/data/repository/auth_repository.dart';
import 'package:service_provider_umi/data/repository/chat_repository.dart';
import 'package:service_provider_umi/data/repository/payment_repository.dart';
import 'package:service_provider_umi/data/repository/service_repository.dart';
import 'package:service_provider_umi/data/repository/notification_and_history_repositiry.dart';
import 'package:service_provider_umi/data/repository/static_content_repository.dart';
import 'package:service_provider_umi/data/repository/user_repository.dart';
import 'package:service_provider_umi/data/repository/website_repository.dart';

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
NotificationAndHistoryRepositiry notificationAndHistoryRepositiry(Ref ref) =>
    NotificationAndHistoryRepositiry(
      remote: ref.read(notificationAndHistoryRemoteDataSourceProvider),
    );

@riverpod
ServiceRepository serviceRepository(Ref ref) =>
    ServiceRepository(remote: ref.read(serviceRemoteDataSourceProvider));

@riverpod
StaticContentRepository staticContentRepository(Ref ref) =>
    StaticContentRepository(
      remote: ref.read(staticContentRemoteDataSourceProvider),
    );

@riverpod
PaymentRepository paymentRepository(Ref ref) =>
    PaymentRepository(remote: ref.read(paymentDataSourceProvider));

@riverpod
ChatRepository chatRepository(Ref ref) =>
    ChatRepository(remote: ref.read(chatRemoteDataSourceProvider));

@riverpod
AddressRepository addressRepository(Ref ref) {
  return AddressRepository(remote: ref.read(addressRemoteDataSourceProvider));
}

@riverpod
WebsiteRepository websiteRepository(Ref ref) {
  return WebsiteRepository(remote: ref.read(websiteRemoteDataSourceProvider));
}
