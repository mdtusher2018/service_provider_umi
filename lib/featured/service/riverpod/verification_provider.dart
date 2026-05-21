import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/data/repository/user_repository.dart';
part 'verification_provider.g.dart';

class VerificationRequest {
  final File? palliativeCare;
  final File? drivingLicense;
  final File? businessProfilesOnly;
  final File? qualifiedOnly;

  const VerificationRequest({
    this.palliativeCare,
    this.drivingLicense,
    this.businessProfilesOnly,
    this.qualifiedOnly,
  });
}

@riverpod
class Verification extends _$Verification {
  @override
  FutureOr<bool?> build() => null;

  UserRepository get _repo => ref.read(userRepositoryProvider);

  Future<void> create(VerificationRequest request) async {
    state = const AsyncLoading();

    final result = await _repo.submitVerification(request);

    state = result.when(
      failure: (failure) => AsyncError(failure.message, StackTrace.current),
      success: (success) => AsyncData(success),
    );
  }
}
