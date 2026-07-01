part of 'provider_profile_screen.dart';

Widget _buildQaSection(WidgetRef ref, String userId) {
  final faqsState = ref.watch(providerFaqsProvider(userId));

  return faqsState.when(
    loading: () => const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: CircularProgressIndicator(),
      ),
    ),
    error: (e, _) => Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: AppText.bodyMd(
          'Failed to load FAQs',
          color: AppColors.error,
        ),
      ),
    ),
    data: (faqs) {
      if (faqs.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppText.h3('Frequently Asked Questions'),
            ],
          ),
          12.verticalSpace,
          ...faqs.map(
            (faq) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Theme(
                data: Theme.of(ref.context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: AppText.bodyMd(
                    faq.question,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  iconColor: AppColors.primary,
                  collapsedIconColor: AppColors.textSecondary,
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bodyMd(
                      faq.answer,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
