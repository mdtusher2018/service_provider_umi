part of '../welcome_screen.dart';

void _showRoleSelectionDialog(WidgetRef ref) {
  showDialog(
    context: ref.context,
    builder: (_) {
      return Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: 20.paddingH,
        child: Padding(
          padding: 20.paddingAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: InkWell(
                  onTap: () {
                    ref.context.pop();
                  },
                  child: Icon(Icons.arrow_back),
                ),
              ),
              const AppText.h2(
                "What will you do on iumi?",
                color: AppColors.textSecondary,
              ),

              10.verticalSpace,

              const AppText.bodySm(
                "This decision is not final. You can later be both a client\nand a professional from the account if you wish.",
                textAlign: TextAlign.center,
              ),

              20.verticalSpace,

              InkWell(
                onTap: () {
                  ref.context.pop();
                  _showAuthBottomSheet(
                    ref,
                    isLogin: false,
                    role: AppRole.provider,
                  );
                },
                child: _categoryCard(
                  "Book a service",
                  "I am a Client",
                  "assets/book_service.png",
                ),
              ),

              12.verticalSpace,

              InkWell(
                onTap: () {
                  ref.context.pop();
                  _showAuthBottomSheet(ref, isLogin: false, role: AppRole.user);
                },
                child: _categoryCard(
                  "Offer services",
                  "I am a Professional",
                  "assets/offer_service.png",
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _categoryCard(String title, String subtitle, String image) {
  return Container(
    padding: 12.paddingAll,
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
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
