import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/services/network/dio_client.dart';
import 'package:service_provider_umi/data/data_source/local/service_local_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/auth_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/service_remote_data_source.dart';

part 'data_source_provider.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    // MockAuthRemoteDataSource();
    // 👇 Swap with mock while API is not ready:
    AuthRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

@riverpod
ServiceRemoteDataSource serviceRemoteDataSource(Ref ref) =>
    ServiceRemoteDataSourceImpl(apiService: ref.read(dioClientProvider));

// 👇 Swap with mock while API is not ready:
// ServiceMockDataSource();

@riverpod
ServiceLocalDataSource serviceLocalDataSource(Ref ref) =>
    ServiceLocalDataSource(hiveService: ref.read(hiveStorageProvider));
