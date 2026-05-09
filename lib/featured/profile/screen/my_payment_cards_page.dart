import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/data/models/payment_card_model.dart';
import 'package:service_provider_umi/featured/profile/riverpod/payment_cards_provider.dart';
import 'package:service_provider_umi/featured/profile/screen/payment_webview.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

class MyPaymentCardsPage extends ConsumerWidget {
  const MyPaymentCardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsState = ref.watch(paymentCardsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const AppText.h3('My Cards', fontWeight: FontWeight.w700),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 40),
        child: AppButton.primary(
          label: "Add New",
          onPressed: () async {
            final url = await ref
                .read(paymentCardsProvider.notifier)
                .getAddCardLink();

            if (url == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to get add card link')),
              );
              return;
            }

            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentWebViewScreen(url: url),
                ),
              ).then((_) {
                /// refresh cards after returning
                ref.read(paymentCardsProvider.notifier).fetchCards();
              });
            }
          },
        ),
      ),

      body: Container(
        margin: 16.paddingAll,
        padding: 14.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: 16.circular,
        ),

        child: cardsState.when(
          loading: () => AppLoader(),

          error: (e, _) => RefreshIndicator(
            onRefresh: () async {
              ref.read(paymentCardsProvider.notifier).fetchCards();
            },
            child: ListView(
              children: [
                Padding(
                  padding: 40.paddingAll,
                  child: AppText.bodyMd(
                    e.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          data: (cards) {
            if (cards.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  ref.read(paymentCardsProvider.notifier).fetchCards();
                },
                child: ListView(children: [AppText.bodyMd('No cards found')]),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.read(paymentCardsProvider.notifier).fetchCards();
              },
              child: ListView.separated(
                itemCount: cards.length,
                separatorBuilder: (_, __) => 20.verticalSpace,
                itemBuilder: (context, index) {
                  final card = cards[index];

                  return _CardTile(card: card);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CardTile extends ConsumerWidget {
  final PaymentCardModel card;

  const _CardTile({required this.card});

  String getCardImage(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return Assets.cards.visa.keyName;

      case 'mastercard':
        return Assets.cards.mastercard.keyName;

      case 'paypal':
        return Assets.cards.paypal.keyName;

      default:
        return Assets.cards.visa.keyName;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Image.asset(getCardImage(card.displayBrand), width: 42, height: 42),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bodyMd(
                card.displayBrand.toUpperCase(),
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 4),

              AppText.bodySm(
                '**** **** **** ${card.last4digit}',
                color: Colors.grey,
              ),
            ],
          ),
        ),

        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'delete') {
              final success = await ref
                  .read(paymentCardsProvider.notifier)
                  .deleteCard(card.id);

              if (context.mounted) {
                context.showSnackBar(
                  success
                      ? 'Card deleted successfully'
                      : 'Failed to delete card',
                  isError: !success,
                );
              }
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'delete', child: AppText('Delete')),
          ],
        ),
      ],
    );
  }
}
