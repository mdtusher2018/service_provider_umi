import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/chat_remote_data_source.dart';

class ChatRepository with SafeCall {
  final ChatRemoteDataSource _remote;

  ChatRepository({
    required ChatRemoteDataSource remote,
  }) : _remote = remote;

  Future<Result<String, Failure>> getChatId(String reciverId) async {
    final result = await asyncGuard(
      () => _remote.getChatId(reciverId: reciverId),
    );
    return result.when(
      success: (id) async {
        return Success(id);
      },
      failure: (f) async => Error(f),
    );
  }
}
