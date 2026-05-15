part of 'booking_details_screen.dart';

Widget _buildTextContentSection(String title, String content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [AppText.h3(title)]),
      10.verticalSpace,

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
  );
}
