import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';

import 'package:service_provider_umi/data/models/payment_card_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentCardModel>> getMyCards();
  Future<void> deleteCard(String paymentMethodId);
  Future<void> setDefaultCard(String paymentMethodId);

  Future<String> getAddCardLink();
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  @override
  Future<List<PaymentCardModel>> getMyCards() async {
    final response = await _dio.get(ApiEndpoints.getMyPaymentCards);

    final apiResponse = ApiResponse<List<PaymentCardModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => PaymentCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return apiResponse.data ?? [];
  }

  @override
  Future<void> deleteCard(String paymentMethodId) async {
    final response = await _dio.delete(
      ApiEndpoints.deletePaymentCard(paymentMethodId),
    );

    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to delete card');
    }
  }

  @override
  Future<void> setDefaultCard(String paymentMethodId) async {
    final response = await _dio.post(
      ApiEndpoints.setDefaultPaymentCard(paymentMethodId),
    );

    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to delete card');
    }
  }

  @override
  Future<String> getAddCardLink() async {
    final response = await _dio.get(ApiEndpoints.getAddCardLink);

    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to get link');
    }

    return response.data['data']['secret'];
  }
}
