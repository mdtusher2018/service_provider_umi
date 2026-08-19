part of 'provider_profile_screen.dart';

Widget _buildQaSection(WidgetRef ref, UserProfile profileData) {
  final faqsState = ref.watch(providerFaqsProvider(profileData.id));

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
      final experience = profileData.serviceProviderInfo?.experience?.value;
      final otherTasks = profileData.serviceProviderInfo?.otherTasks ?? [];

      if (faqs.isEmpty && experience == null && otherTasks.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.bodyLg(
              'Some question about me',
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            if (faqs.isNotEmpty) ...[
              16.verticalSpace,
              ...faqs.map((faq) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bodyMd(
                      faq.question,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    4.verticalSpace,
                    AppText.bodyMd(
                      faq.answer,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              )),
            ],
            
            if (experience != null) ...[
              if (faqs.isNotEmpty) 8.verticalSpace else 16.verticalSpace,
              AppText.bodyMd(
                'How much experience do you have?',
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              4.verticalSpace,
              AppText.bodyMd(
                experience,
                color: AppColors.textSecondary,
              ),
              16.verticalSpace,
            ],

            if (otherTasks.isNotEmpty) ...[
              if (experience == null && faqs.isNotEmpty) 8.verticalSpace,
              AppText.bodyMd(
                'Other required tasks',
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              8.verticalSpace,
              ...otherTasks.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: AppText.bodyMd(
                        task.value,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )),
            ]
          ],
        ),
      );
    },
  );
}
