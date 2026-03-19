part of "search_results_screen.dart";

Widget _buildFaqOverlay({
  required Function()? show,
  required Function() hideBottomsheet,
}) {
  return Positioned.fill(
    child: GestureDetector(
      onTap: show,
      child: Container(
        color: Colors.black.withOpacity(0.45),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: _FaqSheet(onClose: hideBottomsheet),
          ),
        ),
      ),
    ),
  );
}

class _FaqSheet extends StatelessWidget {
  final VoidCallback onClose;
  const _FaqSheet({required this.onClose});

  static const _faqs = [
    (
      'How does it work?',
      'Our professionals are vetted and background-checked for your safety.Our professionals are vetted and background-checked for your safety.Our professionals are vetted and background-checked for your safety.Our professionals are vetted and background-checked for your safety.Our professionals are vetted and background-checked for your safety.',
    ),
    (
      'Can they perform other tasks besides caregiving?',
      'Yes, many providers offer additional household services.Yes, many providers offer additional household services.Yes, many providers offer additional household services.Yes, many providers offer additional household services.Yes, many providers offer additional household services.',
    ),
    (
      'Does it include care for people with medical conditions?',
      'Yes, filter by condition to find specialized care.',
    ),
    (
      'The person to be cared for is in the hospital',
      'Hospital-based care may be available. Check provider profiles.',
    ),
    (
      'Can I book the service on a weekly basis?',
      'Yes! Select "Weekly" frequency when booking.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.6),
      decoration: const BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText.h3('How does the Elderly care\nservice work?'),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            // Illustration
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset("assets/elderly_care.png", fit: BoxFit.cover),
            ),
            16.verticalSpace,
            ..._faqs.map((faq) => _FaqTile(question: faq.$1, answer: faq.$2)),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: AppText.labelLg(widget.question)),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_right_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
            if (_expanded) ...[
              8.verticalSpace,
              AppText.bodyMd(widget.answer, color: AppColors.textSecondary),
            ],
          ],
        ),
      ),
    );
  }
}
