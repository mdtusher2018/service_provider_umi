import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/payment_remote_data_source.dart';
import 'package:service_provider_umi/data/models/payment_card_model.dart';

class PaymentRepository with SafeCall {
  final PaymentRemoteDataSource _remote;

  PaymentRepository({required PaymentRemoteDataSource remote})
    : _remote = remote;

  Future<Result<List<PaymentCardModel>, Failure>> getMyCards() =>
      asyncGuard(() => _remote.getMyCards());

  Future<Result<void, Failure>> deleteCard(String paymentMethodId) =>
      asyncGuard(() => _remote.deleteCard(paymentMethodId));

  Future<Result<void, Failure>> setDefaultCard(String paymentMethodId) =>
      asyncGuard(() => _remote.setDefaultCard(paymentMethodId));

  Future<Result<String, Failure>> getAddCardLink() =>
      asyncGuard(() => _remote.getAddCardLink());
}
