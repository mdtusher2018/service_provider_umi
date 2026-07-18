part of 'booking_details_screen.dart';

Widget _buildTextContentSection(String title, String content) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h4(title, color: AppColors.textPrimary),
        16.verticalSpace,

        ReadMoreText(
        content,
        trimMode: TrimMode.Line,
        trimLines: 2,
        colorClickableText: AppColors.primary,

        trimCollapsedText: '+View more',
        trimExpandedText: ' View less',
        moreStyle: AppTextStyles.bodyMd.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
        lessStyle: AppTextStyles.bodyMd.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
  );
}
