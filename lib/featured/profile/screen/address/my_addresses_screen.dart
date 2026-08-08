import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:service_provider_umi/core/config/app_config.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/core/services/network/dio_client.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/data/models/address_model.dart';
import 'package:service_provider_umi/featured/profile/riverpod/address_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';

import '../../../../shared/widgets/app_button.dart';

part 'add_address_screen.dart';

class MyAddressesScreen extends ConsumerWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        title: AppText.h3(AppLocalizations.of(context)!.myAddress),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: AppText.labelLg(
              AppLocalizations.of(context)!.yourAddresses,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: addressState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => AppErrorWidget(
                error: e,
                onRetry: () => ref.read(addressProvider.notifier).fetch(),
              ),
              data: (addresses) => addresses.isEmpty
                  ? AppEmptyState(
                      title: AppLocalizations.of(context)!.noAddresses,
                      subtitle: AppLocalizations.of(context)!.addYourFirstAddressBelow,
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        context.bottomPadding + 100,
                      ),
                      itemCount: addresses.length,
                      separatorBuilder: (_, __) => 10.verticalSpace,
                      itemBuilder: (_, i) => _AddressTile(
                        address: addresses[i],
                        onEdit: () => _openAddressPage(
                          context,
                          ref,
                          address: addresses[i],
                        ),
                        onDelete: () =>
                            _confirmDelete(context, ref, addresses[i]),
                        onSetDefault: () =>
                            _setDefault(context, ref, addresses[i]),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              context.bottomPadding + 20,
            ),
            child: AppButton.primary(
              label: AppLocalizations.of(context)!.addNewAddress,
              onPressed: () => _openAddressPage(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  void _openAddressPage(
    BuildContext context,
    WidgetRef ref, {
    AddressModel? address,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddAddressScreen(existingAddress: address),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AddressModel address,
  ) {
    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (_, __, ___) => _DeleteDialog(
        onYes: () async {
          context.pop();
          final error = await ref
              .read(addressProvider.notifier)
              .deleteAddress(address.id);
          if (error != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );
          }
        },
        onNo: () => context.pop(),
      ),
    );
  }

  void _setDefault(
    BuildContext context,
    WidgetRef ref,
    AddressModel address,
  ) async {
    if (address.isDefault) return; // already default
    final error = await ref.read(addressProvider.notifier).setDefault(address);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.defaultAddressUpdated),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

// ── Address Tile ──────────────────────────────────────────────────────────────

class _AddressTile extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressTile({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 14.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: 14.circular,
        border: Border.all(
          color: address.isDefault ? AppColors.primary : AppColors.border,
          width: address.isDefault ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on_outlined,
            color: address.isDefault ? AppColors.primary : AppColors.grey400,
            size: 20,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Default badge
                if (address.isDefault) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText.bodySm(AppLocalizations.of(context)!.defaultString, color: AppColors.primary),
                  ),
                  4.verticalSpace,
                ],
                AppText.labelLg(
                  AppLocalizations.of(context)!.addressLabel(address.addressLine1),
                  fontWeight: FontWeight.w700,
                ),
                if (address.addressLine2 != null &&
                    address.addressLine2!.isNotEmpty) ...[
                  3.verticalSpace,
                  AppText.bodySm(
                    address.addressLine2!,
                    color: AppColors.textSecondary,
                  ),
                ],
                if (address.city != null || address.country != null) ...[
                  3.verticalSpace,
                  AppText.bodySm(
                    [
                      if (address.city != null) address.city!,
                      if (address.state != null) address.state!,
                      if (address.country != null) address.country!,
                    ].join(', '),
                    color: AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') {
                onEdit();
              } else if (v == 'delete') {
                onDelete();
              } else if (v == 'default') {
                onSetDefault();
              }
            },
            itemBuilder: (_) => [
              if (!address.isDefault)
                PopupMenuItem(
                  value: 'default',
                  child: Row(
                    children: [
                      const Icon(Icons.star_outline, size: 18),
                      const SizedBox(width: 8),
                      AppText(AppLocalizations.of(context)!.setAsDefault),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit_outlined, size: 18),
                    const SizedBox(width: 8),
                    AppText(AppLocalizations.of(context)!.edit),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    const SizedBox(width: 8),
                    AppText(AppLocalizations.of(context)!.delete, color: Colors.red),
                  ],
                ),
              ),
            ],
            child: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.grey400,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Delete Dialog ─────────────────────────────────────────────────────────────

class _DeleteDialog extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  const _DeleteDialog({required this.onYes, required this.onNo});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: 20.circular),
      insetPadding: 32.paddingH,
      child: Padding(
        padding: 24.paddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.h3(
              AppLocalizations.of(context)!.areYouSureToDelete,
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            AppText.bodySm(
              AppLocalizations.of(context)!.thisAddressWillBeRemoved,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            AppButton.primary(label: AppLocalizations.of(context)!.yesDelete, onPressed: onYes),
            10.verticalSpace,
            AppButton.outline(label: AppLocalizations.of(context)!.noDontDelete, onPressed: onNo),
          ],
        ),
      ),
    );
  }
}
