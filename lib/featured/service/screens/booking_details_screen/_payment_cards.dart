part of 'booking_details_screen.dart';

/// ─────────────────────────────────────────────
/// Selected Card Provider
/// ─────────────────────────────────────────────
final selectedCardProvider = StateProvider<String?>((ref) => null);

/// ─────────────────────────────────────────────
/// Payment Section (FULL UI)
/// ─────────────────────────────────────────────
class PaymentMethodsSection extends ConsumerStatefulWidget {
  final String bookingId;
  const PaymentMethodsSection({super.key, required this.bookingId});

  @override
  ConsumerState<PaymentMethodsSection> createState() =>
      _PaymentMethodsSectionState();
}

class _PaymentMethodsSectionState extends ConsumerState<PaymentMethodsSection> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(staticContentProvider.notifier).fetch();
    });
    super.initState();
  }

  TextEditingController additionalCommentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cardsState = ref.watch(paymentCardsProvider);
    final staticState = ref.watch(staticContentProvider);
    final confrimPayment = ref.watch(confirmPaymentProvider);

    ref.listen(confirmPaymentProvider, (previous, next) {
      next.whenOrNull(
        error: (failure, _) {
          AppLogger.error(failure.toString());
          context.showErrorSnackBar(
            (failure is Failure) ? failure.message : failure.toString(),
          );
        },
      );
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ─── Cards List ─────────────────────────
        cardsState.when(
          loading: () => const AppLoader(),

          error: (e, _) => AppText.bodySm(e.toString()),

          data: (cards) {
            if (cards.isEmpty) {
              return const AppEmptyState(title: 'No cards found');
            }

            return Column(
              children: cards
                  .map(
                    (card) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SelectableCardTile(card: card),
                    ),
                  )
                  .toList(),
            );
          },
        ),

        20.verticalSpace,

        /// ─── Remember Section ──────────────────
        staticState.when(
          initial: () => Center(
            child: InkWell(
              onTap: () {
                ref.read(staticContentProvider.notifier).fetch();
              },
              child: AppText.bodyLg("Refresh"),
            ),
          ),
          loading: () => const AppLoader(),
          failure: (f) => AppEmptyState(title: f.message),
          success: (content) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ✅ Remember (Terms)
                if (content.shippingPolicy != null)
                  _buildTextContentSection(
                    "Remember that...",
                    content.shippingPolicy!,
                  ),

                20.verticalSpace,

                /// ─── Additional Comments ─────────
                _buildTextContentSection(
                  "Additional comments",
                  "Feel free to include any additional details if needed (please avoid contact details)",
                ),

                8.verticalSpace,
                AppTextField(
                  maxLines: 3,
                  borderRadious: 8,
                  controller: additionalCommentController,
                ),

                20.verticalSpace,

                /// ✅ Cancellation Policy
                if (content.refundPolicy != null)
                  _buildTextContentSection(
                    "Cancellation policy",
                    content.refundPolicy!,
                  ),
              ],
            );
          },
        ),
        20.verticalSpace,
        AppButton.primary(
          label: "Pay now",
          isLoading: confrimPayment.isLoading,
          onPressed: () async {
            await ref
                .read(confirmPaymentProvider.notifier)
                .confirm(widget.bookingId, additionalCommentController.text);
            ref.invalidate(bookingDetailProvider(widget.bookingId));
          },
        ),
      ],
    );
  }
}

class _SelectableCardTile extends ConsumerWidget {
  final PaymentCardModel card;

  const _SelectableCardTile({required this.card});

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
    final selectedCardId = ref.watch(selectedCardProvider);
    final isSelected = selectedCardId == card.id;

    return GestureDetector(
      onTap: () {
        ref.read(selectedCardProvider.notifier).state = card.id;
      },
      child: Container(
        padding: 16.paddingAll,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.white,
          borderRadius: 16.circular,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
          ),
        ),
        child: Row(
          children: [
            Image.asset(getCardImage(card.displayBrand), width: 42, height: 42),

            14.horizontalSpace,

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.bodyMd(
                    card.displayBrand.toUpperCase(),
                    fontWeight: FontWeight.w700,
                  ),
                  4.verticalSpace,
                  AppText.bodySm(
                    '**** **** **** ${card.last4digit}',
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            /// ✅ RADIO BUTTON
            _RadioIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool isSelected;

  const _RadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.grey300,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            )
          : null,
    );
  }
}
