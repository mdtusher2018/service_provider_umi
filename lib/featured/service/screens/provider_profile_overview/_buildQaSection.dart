part of 'provider_profile_screen.dart';

Widget _buildQaSection({required ProviderProfile mockProvider}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.h3('Some question about me'),
      12.verticalSpace,
      ...mockProvider.questions.map(
        (qa) => Padding(
          padding: 14.paddingBottom,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.labelLg(
                qa.question,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              4.verticalSpace,
              AppText.bodyMd(qa.answer),
            ],
          ),
        ),
      ),
      4.verticalSpace,
      AppButton.outline(label: "View all"),
    ],
  );
}
