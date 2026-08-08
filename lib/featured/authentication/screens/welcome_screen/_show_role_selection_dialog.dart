part of 'welcome_screen.dart';

void _showRoleSelectionDialog(WidgetRef ref) {
  if (kIsWeb) {
    if (kIsWeb) {
      showWebOverlay(ref, _showRoleSelectionWidget(ref));
    }
  } else {
    showGeneralDialog(
      context: ref.context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: 20.circular),
          insetPadding: 20.paddingH,
          child: _showRoleSelectionWidget(ref),
        );
      },
    );
  }
}

Widget _showRoleSelectionWidget(WidgetRef ref) {
  return Padding(
    padding: 20.paddingAll,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentGeometry.topLeft,
          child: InkWell(
            onTap: () async {
              await _close(ref);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        AppText.h2(
          AppLocalizations.of(ref.context)!.whatWillYouDoOnIumi,
          color: AppColors.textSecondary,
        ),

        10.verticalSpace,

        AppText.bodySm(
          AppLocalizations.of(ref.context)!.roleDecisionNotFinal,
          textAlign: TextAlign.center,
        ),

        20.verticalSpace,

        InkWell(
          onTap: () async {
            await _close(ref);
            showAuthUI(ref, isLogin: false, role: AppRole.user);
          },
          child: _categoryCard(
            AppLocalizations.of(ref.context)!.bookAService,
            AppLocalizations.of(ref.context)!.iAmAClient,
            Assets.welcome.bookService.keyName,
          ),
        ),

        12.verticalSpace,

        InkWell(
          onTap: () async {
            await _close(ref);
            showAuthUI(ref, isLogin: false, role: AppRole.provider);
          },
          child: _categoryCard(
            AppLocalizations.of(ref.context)!.offerServices,
            AppLocalizations.of(ref.context)!.iAmAProfessional,
            Assets.welcome.offerService.keyName,
          ),
        ),
      ],
    ),
  );
}

Widget _categoryCard(String title, String subtitle, String image) {
  return Container(
    padding: 12.paddingAll,
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.border),
      borderRadius: 12.circular,
    ),
    child: Row(
      children: [
        SizedBox(
          width: 60,
          child: ClipRRect(
            borderRadius: 8.circular,
            child: Image.asset(image, width: 60, height: 60),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bodyLg(
                title,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
              AppText.bodyMd(subtitle),
            ],
          ),
        ),
      ],
    ),
  );
}
