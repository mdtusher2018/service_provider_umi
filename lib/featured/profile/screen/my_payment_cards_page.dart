import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/data/models/payment_card_model.dart';
import 'package:service_provider_umi/featured/profile/riverpod/payment_cards_provider.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:service_provider_umi/l10n/app_localizations.dart';

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
        title: AppText.h3(AppLocalizations.of(context)!.myCards, fontWeight: FontWeight.w700),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 40),
        child: AppButton.primary(
          label: AppLocalizations.of(context)!.addNew,
          onPressed: () async {
            final clientSecret = await ref
                .read(paymentCardsProvider.notifier)
                .getAddCardLink();
            
            log("clientSecret: ${clientSecret}");

            if (clientSecret == null) {
              context.showSnackBar(AppLocalizations.of(context)!.failedToGetAddCardLink);
              return;
            }

            // Capture current cards to find the newly added one later
            final currentCards = ref.read(paymentCardsProvider).value ?? [];
            final currentCardIds = currentCards.map((c) => c.id).toSet();

            try {
              /// 2. Init PaymentSheet
              await Stripe.instance.initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                  setupIntentClientSecret: clientSecret,
                  merchantDisplayName: 'Paycron',
                  style: ThemeMode.light,
                ),
              );

              /// 3. Open Stripe UI
              await Stripe.instance.presentPaymentSheet();

              /// 4. IMPORTANT: Sync with backend (refresh cards)
              await ref.read(paymentCardsProvider.notifier).fetchCards();

              /// 5. Set the newly added card as default
              final newCards = ref.read(paymentCardsProvider).value ?? [];
              final newCardIds = newCards.map((c) => c.id).toSet();
              
              final addedCardIds = newCardIds.difference(currentCardIds);
              if (addedCardIds.isNotEmpty) {
                await ref
                    .read(paymentCardsProvider.notifier)
                    .setDefaultCard(addedCardIds.first);
              }
            } catch (e) {
              log("Stripe PaymentSheet Error: $e");
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
                child: ListView(
                  children: [
                    AppEmptyState(
                      title: AppLocalizations.of(context)!.noCardsFound,
                      icon: Icon(Icons.error),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.read(paymentCardsProvider.notifier).fetchCards();
              },
              child: ListView.separated(
                itemCount: cards.length,
                separatorBuilder: (_, __) => 10.verticalSpace,
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
    return Container(
      padding: 16.paddingAll,
      decoration: (card.isDefault)
          ? BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: 16.circular,
              border: Border.all(color: AppColors.primary),
            )
          : null,
      child: Row(
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
                final errorMsg = await ref
                    .read(paymentCardsProvider.notifier)
                    .deleteCard(card.id);

                if (context.mounted) {
                  context.showSnackBar(
                    errorMsg ?? AppLocalizations.of(context)!.cardDeletedSuccessfully,
                    isError: errorMsg != null,
                  );
                }
              }
              if (value == 'default') {
                final success = await ref
                    .read(paymentCardsProvider.notifier)
                    .setDefaultCard(card.id);

                if (context.mounted) {
                  context.showSnackBar(
                    success
                        ? AppLocalizations.of(context)!.setAsDefaultCardSuccessfully
                        : AppLocalizations.of(context)!.failedToSetDefaultCard,
                    isError: !success,
                  );
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'delete', child: AppText(AppLocalizations.of(context)!.delete)),
              PopupMenuItem(
                value: 'default',
                child: AppText(AppLocalizations.of(context)!.setAsDefaultCard),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
