import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/services/network/dio_client.dart';
import 'package:service_provider_umi/data/data_source/remote/auth_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/service_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/notification_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/user_remote_data_source.dart';

part 'data_source_provider.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) =>
    UserRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

@riverpod
NotificationRemoteDataSource notificationRemoteDataSource(Ref ref) =>
    NotificationRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

@riverpod
ServiceRemoteDataSource serviceRemoteDataSource(Ref ref) =>
    ServiceRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

@riverpod
ContentRemoteDataSource contentRemoteDataSource(Ref ref) =>
    ContentRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));
