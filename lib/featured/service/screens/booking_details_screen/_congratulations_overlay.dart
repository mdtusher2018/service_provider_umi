part of 'booking_details_screen.dart';

// ─── Congratulations Overlay ──────────────────────────────────
class _CongratsDialog extends StatelessWidget {
  final Color primary;
  final VoidCallback onDone;

  const _CongratsDialog({required this.primary, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: 28.paddingH,
      child: Container(
        padding: 24.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: 24.circular,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ..._buildDots(),

                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3CD),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: Color(0xFFFFB300),
                        size: 52,
                      ),
                      Positioned(
                        bottom: 14,
                        child: Container(
                          width: 36,
                          height: 10,
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: 4.circular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            20.verticalSpace,

            AppText.h2('Congratulations'),

            10.verticalSpace,

            AppText(
              'Congratulations on achieving this milestone in your '
              'professional journey! Your dedication, expertise, and '
              'hard work are truly commendable.',
              style: AppTextStyles.bodySm.copyWith(height: 1.6),
              textAlign: TextAlign.center,
            ),

            24.verticalSpace,

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: 10.circular),
                ),
                child: AppText('Done', style: AppTextStyles.buttonMd),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    const items = [
      _Dot(top: 0, left: 20, color: Color(0xFFE91E63), size: 8),
      _Dot(top: 10, right: 10, color: Color(0xFF9C27B0), size: 6),
      _Dot(bottom: 5, left: 5, color: Color(0xFF2196F3), size: 6),
      _Dot(bottom: 0, right: 20, color: Color(0xFFFF5722), size: 8),
      _Dot(top: 30, left: 0, color: Color(0xFF4CAF50), size: 5),
      _Dot(top: 5, right: 35, color: Color(0xFFFFEB3B), size: 7),
    ];

    return items
        .map(
          (d) => Positioned(
            top: d.top,
            left: d.left,
            right: d.right,
            bottom: d.bottom,
            child: Container(
              width: d.size,
              height: d.size,
              decoration: BoxDecoration(color: d.color, shape: BoxShape.circle),
            ),
          ),
        )
        .toList();
  }
}

class _Dot {
  final double? top, left, right, bottom, size;
  final Color color;
  const _Dot({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.color,
    required this.size,
  });
}
