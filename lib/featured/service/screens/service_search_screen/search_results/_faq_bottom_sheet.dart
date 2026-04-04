part of "service_search_results_screen.dart";

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

class _FaqSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  const _FaqSheet({required this.onClose});

  @override
  ConsumerState<_FaqSheet> createState() => _FaqSheetState();
}

class _FaqSheetState extends ConsumerState<_FaqSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(faqProvider.notifier).fetch("elderly_care");
    });
  }

  @override
  Widget build(BuildContext context) {
    final faqState = ref.watch(faqProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.8),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: faqState.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: AppText.bodyMd(e.toString())),

        data: (faqs) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ─── Header ───
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText.h3(
                        'How does the Elderly care\nservice work?',
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onClose,
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                16.verticalSpace,

                // ─── Illustration ───
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: 16.circular,
                  ),
                  child: Image.asset(
                    "assets/elderly_care.png",
                    fit: BoxFit.cover,
                  ),
                ),

                16.verticalSpace,

                // ─── FAQ LIST FROM API ───
                if (faqs.isEmpty)
                  const AppText.bodyMd("No FAQs available")
                else
                  ...faqs.map(
                    (faq) =>
                        _FaqTile(question: faq.question, answer: faq.answer),
                  ),
              ],
            ),
          );
        },
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
        padding: 12.paddingV,
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
