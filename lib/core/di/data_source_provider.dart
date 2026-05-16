// ignore_for_file: unused_import

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/services/network/dio_client.dart';
import 'package:service_provider_umi/data/data_source/remote/address_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/auth_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/chat_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/payment_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/service_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/notification_and_history_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/static_content_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/user_remote_data_source.dart';

part 'data_source_provider.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) =>
    UserRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));
// MockUserDataSource();

@riverpod
NotificationAndHistoryRemoteDataSource notificationAndHistoryRemoteDataSource(
  Ref ref,
) => NotificationAndHistoryRemoteDataSourceImpl(
  apiService: ref.read(dioClientProvider),
);

@riverpod
ServiceRemoteDataSource serviceRemoteDataSource(Ref ref) =>
    ServiceRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));
// MockServiceDataSource();

@riverpod
StaticContentRemoteDataSource staticContentRemoteDataSource(Ref ref) =>
    StaticContentRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

@riverpod
PaymentRemoteDataSource paymentDataSource(Ref ref) =>
    PaymentRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

@riverpod
ChatRemoteDataSource chatRemoteDataSource(Ref ref) =>
    ChatRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

@riverpod
AddressRemoteDataSource addressRemoteDataSource(Ref ref) =>
    AddressRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));
