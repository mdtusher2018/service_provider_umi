import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/string_ext.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/data/models/payment_card_model.dart';
import 'package:service_provider_umi/featured/profile/riverpod/payment_cards_provider.dart';
import 'package:service_provider_umi/featured/profile/riverpod/static_content_provider.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../../../../../../../core/di/app_role_provider.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/helpers/decode_helper.dart';
import '../../../../core/di/repository_providers.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';

part '_congratulations_overlay.dart';
part '_timeline_row.dart';
part '_payment_cards.dart';
part '_build_text_content_section.dart';
part '_build_address.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  void showCongratulations() {
    final role = ref.read(appRoleProvider);
    final primary = AppColors.primaryFor(role);

    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      barrierDismissible: false,
      pageBuilder: (_, _, _) => _CongratsDialog(
        primary: primary,
        onDone: () {
          context.pop();
          context.pop();
        },
      ),
    );
  }

  void _accept() async {
    await ref.read(acceptBookingProvider.notifier).accept(widget.bookingId);
    ref.invalidate(bookingDetailProvider(widget.bookingId));
  }

  void _cancel() async {
    await ref.read(rejectBookingProvider.notifier).reject(widget.bookingId);
    ref.invalidate(bookingDetailProvider(widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);
    final state = ref.watch(bookingDetailProvider(widget.bookingId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: AppLocalizations.of(context)!.details),
      body: state.when(
        error: (error, stackTrace) => AppEmptyState(
          title: error.toString(),
          icon: Icon(Icons.error, color: AppColors.error),
        ),
        loading: () => AppLoader(),
        data: (data) {
          if (data == null) {
            return AppEmptyState(title: AppLocalizations.of(context)!.noDataFound);
          }
          return _BookingDetailBody(
            data: data,
            primary: primary,
            onComplete: () async {
              await ref
                  .read(completeBookingProvider.notifier)
                  .complete(widget.bookingId);
              showCongratulations();
            },
            onAccept: _accept,
            onCancel: _cancel,
          );
        },
      ),
    );
  }
}

// ─── Body extracted so `data` is always in scope ─────────────────────────────
class _BookingDetailBody extends ConsumerWidget {
  final BookingDetailModel data;
  final Color primary;
  final VoidCallback onComplete;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  const _BookingDetailBody({
    required this.data,
    required this.primary,
    required this.onComplete,
    required this.onAccept,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(appRoleProvider);
    final bookingStatus = BookingStatus.fromString(data.status);
    final acceptState = ref.watch(acceptBookingProvider);
    final rejectState = ref.watch(rejectBookingProvider);

    ref.listen(bookingDetailProvider(data.id), (previous, next) {
      next.whenOrNull(
        error: (failure, _) {
          context.showErrorSnackBar(failure.toString());
        },
      );
    });
    ref.listen(acceptBookingProvider, (previous, next) {
      next.whenOrNull(
        error: (failure, _) {
          context.showErrorSnackBar(failure.toString());
        },
        data: (_) async {
          if (previous is AsyncLoading) {

            // refresh the relevant bookings list(s) before navigating
            // await ref
            //     .read(bookingsNotifierProvider(BookingStatus.pending).notifier)
            //     .fetch(initial: true);

            if (context.mounted) {
              context.showSuccessSnackBar(AppLocalizations.of(context)!.bookingAccepted);
              context.go(AppRoutes.providerHome);
            }
          }
        },
      );
    });
    ref.listen(rejectBookingProvider, (previous, next) {
      next.whenOrNull(
        error: (failure, _) {
          context.showErrorSnackBar(failure.toString());
        },
      );
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProviderRow(context, ref, role, bookingStatus),
          16.verticalSpace,
          _buildTextContentSection(
            AppLocalizations.of(context)!.comment,
            AppLocalizations.of(context)!.serviceBookedSuccess,
          ),
          16.verticalSpace,
          _buildSection(AppLocalizations.of(context)!.dateAndTime, _buildDateTime(data)),
          16.verticalSpace,
          _buildSection(AppLocalizations.of(context)!.address, _buildAddress(data, context)),
          16.verticalSpace,
          _buildSection(AppLocalizations.of(context)!.servicePrice, _buildPrice(context)),
          40.verticalSpace,

          // ── Action buttons driven by real status ──────────────────
          if (bookingStatus == BookingStatus.pending &&
              ref.read(appRoleProvider) == AppRole.user)
            PaymentMethodsSection(bookingId: data.id),

          if (bookingStatus == BookingStatus.requested &&
              ref.read(appRoleProvider) == AppRole.provider)
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: AppButton.primary(
                    label: AppLocalizations.of(context)!.accept,
                    onPressed: onAccept,
                    isLoading: acceptState.isLoading,
                  ),
                ),
                Expanded(
                  child: AppButton.outline(
                    label: AppLocalizations.of(context)!.cancel,
                    onPressed: onCancel,
                    isLoading: rejectState.isLoading,
                  ),
                ),
              ],
            ),

          if (bookingStatus == BookingStatus.ongoing)
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: AppButton.primary(
                    label: AppLocalizations.of(context)!.complete,
                    onPressed: onComplete,
                    isLoading: ref.watch(completeBookingProvider).isLoading,
                  ),
                ),
                Expanded(
                  child: AppButton.outline(
                    label: AppLocalizations.of(context)!.cancel,
                    onPressed: onCancel,
                    isLoading: rejectState.isLoading,
                  ),
                ),
              ],
            ),

          if (bookingStatus == BookingStatus.complete)
            AppText.bodyLg(AppLocalizations.of(context)!.bookingHasBeenCompleted),
        ],
      ),
    );
  }

  // ─── Provider row ─────────────────────────────────────────────────────────
  Widget _buildProviderRow(BuildContext context, WidgetRef ref, AppRole role, BookingStatus bookingStatus) {
    // Show the other party: if viewing as provider → show user, else → show provider
    final name = (role == AppRole.provider)
        ? data.user?.name ?? '—'
        : data.provider?.name ?? '—';
    final phone = (role == AppRole.provider)
        ? data.user?.phoneNumber ?? '—'
        : data.provider?.phoneNumber ?? '—';
    final profileUrl = (role == AppRole.provider)
        ? data.user?.profile
        : data.provider?.profile;

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
          AppText.h4(role == AppRole.provider ? AppLocalizations.of(context)!.customer : AppLocalizations.of(context)!.provider, color: AppColors.textPrimary),
          16.verticalSpace,
          Row(
            children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: profileUrl != null && profileUrl.isNotEmpty
              ? NetworkImage(profileUrl)
              : null,
          child: profileUrl == null || profileUrl.isEmpty
              ? const Icon(Icons.person, size: 36)
              : null,
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [AppText.h4(name), AppText.bodySm(phone)],
          ),
        ),
        GestureDetector(
          onTap: () async {
            if (bookingStatus == BookingStatus.pending || bookingStatus == BookingStatus.requested) {
              final action = role == AppRole.user ? AppLocalizations.of(context)!.accepting : AppLocalizations.of(context)!.creating;
              context.showSnackBar(AppLocalizations.of(context)!.cantChatBeforeAction(action), showAtTop: true);
              return;
            }

            final myUserId = await getMyUserId(ref);

            final otherUserId = (role == AppRole.provider)
                ? data.user?.id
                : data.provider?.id;

            if (otherUserId == null) return;

            if (!context.mounted) return;
            context.showLoader();

            final chatRepo = ref.read(chatRepositoryProvider);
            final result = await chatRepo.getChatId(otherUserId);

            if (!context.mounted) return;
            context.hideLoader();

            result.when(
              success: (chatId) {
                context.push(
                  AppRoutes.chatPath(chatId.isEmpty ? otherUserId : chatId),
                  extra: {
                    'otherUserId': otherUserId,
                    'name': name,
                    'myId': myUserId,
                    'imageUrl': profileUrl ?? "",
                  },
                );
              },
              failure: (e) {
                context.showSnackBar(AppLocalizations.of(context)!.failedToLoadChat(e.message));
              },
            );
          },
          child: AppAvatar(
            imageUrl: Assets.icons.chatIcon.keyName,
            size: AvatarSize.md,
            backgroundColor: AppColors.primaryFor(role),
          ),
        ),
      ],
    ),
  ],
),
    );
  }

  // ─── Price breakdown ──────────────────────────────────────────────────────
  Widget _buildPrice(BuildContext context) {
    final rows = [
      ('${data.bookingType.titleCase} ${AppLocalizations.of(context)!.serviceText.toLowerCase()}', '\$${data.price.toStringAsFixed(2)}', false),
      (AppLocalizations.of(context)!.bookingHours, '${data.totalHours}h', false),
      (AppLocalizations.of(context)!.subtotal, '\$${data.price.toStringAsFixed(2)}', false),
      (AppLocalizations.of(context)!.clientProtection, AppLocalizations.of(context)!.free, false),
    ];

    return Column(
      children: [
        ...rows.map(
          (r) => Padding(
            padding: 6.paddingBottom,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.bodyMd(r.$1),
                AppText.bodyMd(r.$2, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
        const Divider(height: 16, color: AppColors.grey500),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.bodyMd(AppLocalizations.of(context)!.total),
            AppText(
              '\$${data.price.toStringAsFixed(2)}',
              style: AppTextStyles.labelLg.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Section wrapper ──────────────────────────────────────────────────────
  Widget _buildSection(String title, Widget child) {
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
          child,
        ],
      ),
    );
  }
}
