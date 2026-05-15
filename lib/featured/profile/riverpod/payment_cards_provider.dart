import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/data/models/payment_card_model.dart';
import 'package:service_provider_umi/data/repository/payment_repository.dart';

part 'payment_cards_provider.g.dart';

@Riverpod(keepAlive: true)
class PaymentCardsNotifier extends _$PaymentCardsNotifier {
  @override
  AsyncValue<List<PaymentCardModel>> build() {
    fetchCards();
    return const AsyncLoading();
  }

  PaymentRepository get _repo => ref.read(paymentRepositoryProvider);

  Future<void> fetchCards() async {
    state = const AsyncLoading();

    final result = await _repo.getMyCards();

    state = result.when(
      success: (data) => AsyncData(data),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  /// DELETE CARD
  Future<bool> deleteCard(String paymentMethodId) async {
    final currentCards = state.value ?? [];

    final result = await _repo.deleteCard(paymentMethodId);

    return result.when(
      success: (_) {
        state = AsyncData(
          currentCards.where((e) => e.id != paymentMethodId).toList(),
        );

        return true;
      },
      failure: (e) {
        return false;
      },
    );
  }

  /// Set Default Card
  Future<bool> setDefaultCard(String paymentMethodId) async {
    final currentCards = state.value ?? [];

    final result = await _repo.setDefaultCard(paymentMethodId);

    return result.when(
      success: (_) {
        final updatedCards = currentCards.map((card) {
          return PaymentCardModel(
            id: card.id,
            type: card.type,
            displayBrand: card.displayBrand,
            last4digit: card.last4digit,
            expMonth: card.expMonth,
            expYear: card.expYear,
            funding: card.funding,
            country: card.country,
            fingerprint: card.fingerprint,
            isDefault: card.id == paymentMethodId, // ✅ key logic
          );
        }).toList();

        state = AsyncData(updatedCards);

        return true;
      },
      failure: (e) {
        return false;
      },
    );
  }

  /// GET ADD CARD LINK
  Future<String?> getAddCardLink() async {
    final result = await _repo.getAddCardLink();

    return result.when(success: (url) => url, failure: (e) => null);
  }
}
