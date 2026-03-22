part of 'profile_picture_screen.dart';

// ─── Tips card ────────────────────────────────────────────────
class _TipsCard extends StatelessWidget {
  final Color primary;
  const _TipsCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    const tips = ['Good lighting', 'Good resolution', 'Visible face', 'Smile'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What makes a good profile picture?',
            style: AppTextStyles.labelLg.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          24.verticalSpace,

          // Example avatars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ExampleAvatar(
                assetOrEmoji: 'assets/service_provider_images/right_image.png',
                isGood: true,
                primary: primary,
              ),
              12.horizontalSpace,
              _ExampleAvatar(
                assetOrEmoji: 'assets/service_provider_images/wrong_image.png',
                isGood: false,
                primary: primary,
              ),
            ],
          ),
          24.verticalSpace,

          // Checklist
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_rounded, color: primary, size: 18),
                  8.horizontalSpace,
                  Text(tip, style: AppTextStyles.bodyMd),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleAvatar extends StatelessWidget {
  final String assetOrEmoji;
  final bool isGood;
  final Color primary;

  const _ExampleAvatar({
    required this.assetOrEmoji,
    required this.isGood,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.grey100,
          ),
          child: Center(child: Image.asset(assetOrEmoji)),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isGood ? primary : AppColors.error,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: Icon(
              isGood ? Icons.check_rounded : Icons.close_rounded,
              color: AppColors.white,
              size: 10,
            ),
          ),
        ),
      ],
    );
  }
}
