import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/data/models/address_model.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part 'add_address_screen.dart';

class MyAddressesScreen extends StatefulWidget {
  const MyAddressesScreen({super.key});

  @override
  State<MyAddressesScreen> createState() => _MyAddressesScreenState();
}

class _MyAddressesScreenState extends State<MyAddressesScreen> {
  final List<AddressModel> _addresses = [
    const AddressModel(
      id: '1',
      address: '1901 Thorner Rd, Allentown, New Mexico 31134',
      lat: 45.5,
      lng: 90.5,
    ),
  ];

  void _openAddressPage({AddressModel? address}) async {
    final result =
        context.push(AppRoutes.addAddress, extra: address) as AddressModel?;

    if (result != null) {
      setState(() {
        if (address == null) {
          _addresses.add(result);
        } else {
          final idx = _addresses.indexWhere((a) => a.id == address.id);
          if (idx != -1) {
            _addresses[idx] = result;
          }
        }
      });
    }
  }

  void _confirmDelete(AddressModel address) {
    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (_, _, _) => _DeleteDialog(
        onYes: () {
          setState(() => _addresses.removeWhere((a) => a.id == address.id));
          context.pop();
        },
        onNo: () => context.pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: const AppText.h3('My Address'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: AppText.labelLg(
              'Your Addresses',
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: _addresses.isEmpty
                ? const AppEmptyState(
                    title: 'No addresses',
                    subtitle: 'Add your first address',
                  )
                : ListView.separated(
                    padding: 20.paddingH,
                    itemCount: _addresses.length,
                    separatorBuilder: (_, __) => 10.verticalSpace,
                    itemBuilder: (_, i) => _AddressTile(
                      address: _addresses[i],
                      onEdit: () => _openAddressPage(address: _addresses[i]),
                      onDelete: () => _confirmDelete(_addresses[i]),
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
              label: 'Add New Address',
              onPressed: () => _openAddressPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _AddressTile({
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 14.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: 14.circular,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.primary,
            size: 20,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelLg(address.address, fontWeight: FontWeight.w700),
                3.verticalSpace,
                // AppText.bodySm(address.street, color: AppColors.textSecondary),
                // AppText.bodySm(address.country, color: AppColors.textSecondary),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: AppText('Edit')),
              const PopupMenuItem(
                value: 'delete',
                child: AppText('Delete', color: Colors.red),
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
            const AppText.h3(
              'Are you sure you want to delete ?',
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            AppButton.primary(label: 'YES, DELETE', onPressed: onYes),
            10.verticalSpace,
            AppButton.outline(label: "NO, DON'T DELETE", onPressed: onNo),
          ],
        ),
      ),
    );
  }
}
