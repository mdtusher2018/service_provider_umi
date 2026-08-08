part of 'welcome_screen.dart';

Future<bool?> _showPrivacyPolicyBottomSheet(WidgetRef ref) async {
  if (kIsWeb) {
    return true;
  } else {
    return showModalBottomSheet(
      context: ref.context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return _buildPrivacyPolicyContent(ref);
      },
    );
  }
}

Widget _buildPrivacyPolicyContent(WidgetRef ref, {VoidCallback? onAccept}) {
  return Padding(
    padding: 24.paddingAll,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: const Icon(
            Icons.privacy_tip,
            size: 60,
            color: AppColors.primary,
          ),
        ),

        16.verticalSpace,

        AppText.h3(AppLocalizations.of(ref.context)!.weValueYourPrivacy),

        8.verticalSpace,

        AppText.bodySm(
          AppLocalizations.of(ref.context)!.cookiePolicyMsg,
        ),

        20.verticalSpace,

        AppButton.primary(
          label: AppLocalizations.of(ref.context)!.accept,
          onPressed: onAccept ?? () => Navigator.pop(ref.context, true),
        ),

        10.verticalSpace,
      ],
    ),
  );
}
