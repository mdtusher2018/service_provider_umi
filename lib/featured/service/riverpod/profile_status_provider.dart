import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/data/repository/user_repository.dart';
part 'profile_status_provider.g.dart';

@riverpod
class MyProfileStatusNotifier extends _$MyProfileStatusNotifier {
  @override
  FutureOr<bool?> build() async {
    return fetch(); // 👈 auto load on first use
  }

  UserRepository get _repo => ref.read(userRepositoryProvider);

  Future<bool?> fetch() async {
    state = const AsyncLoading();

    final result = await _repo.profileVerified();

    return result.when(
      success: (data) {
        state = AsyncData(data);
        return data;
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
        return null;
      },
    );
  }
}
