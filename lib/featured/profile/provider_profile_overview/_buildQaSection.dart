part of 'provider_profile_screen.dart';

Widget _buildQaSection({required _ProviderData mockProvider}) {
  final qaItems = [
    (
      'How much experience do you have as a carer of the elderly?',
      mockProvider.experience,
    ),
    (
      'Do you have a qualification, diploma or degree as a health worker?',
      mockProvider.isQualified ? '✓ Yes' : '✓ No',
    ),
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.h3('Some question about me'),
      12.verticalSpace,
      ...qaItems.map(
        (qa) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.labelLg(
                qa.$1,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              4.verticalSpace,
              AppText.bodyMd(qa.$2),
            ],
          ),
        ),
      ),
      4.verticalSpace,
      SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: AppText.labelLg('View all'),
        ),
      ),
    ],
  );
}
