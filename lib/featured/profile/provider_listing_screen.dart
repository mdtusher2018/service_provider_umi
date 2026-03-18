import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../../core/di/app_role_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// ─── Model ────────────────────────────────────────────────────
class ServiceListing {
  final String id;
  final String title;
  final String imageUrl;
  final double pricePerHour;
  final bool hasClientProtection;

  const ServiceListing({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.pricePerHour,
    this.hasClientProtection = true,
  });
}

// ─── Screen ───────────────────────────────────────────────────
class ProviderListingScreen extends ConsumerStatefulWidget {
  const ProviderListingScreen({super.key});

  @override
  ConsumerState<ProviderListingScreen> createState() => _MyListingScreenState();
}

class _MyListingScreenState extends ConsumerState<ProviderListingScreen> {
  final List<ServiceListing> _listings = [
    const ServiceListing(
      id: '1',
      title: 'Elderly Care',
      imageUrl:
          'https://tse1.mm.bing.net/th/id/OIP.eAOT-GTYD5Lwsvpc-n7ZyAHaFW?rs=1&pid=ImgDetMain&o=7&rm=3',
      pricePerHour: 10.00,
    ),
  ];

  void _confirmDelete(ServiceListing listing) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => _DeleteDialog(
        onYes: () {
          setState(() => _listings.removeWhere((l) => l.id == listing.id));
          Navigator.of(context).pop();
        },
        onNo: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _addListing() {
    // TODO: navigate to create listing screen
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryFor(ref.watch(appRoleProvider));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: "My listing"),
      body: Stack(
        children: [
          _listings.isEmpty
              ? AppEmptyState(
                  title: "No listings yet",
                  subtitle: "Tap + to add a service",
                  icon: Icon(Icons.list_alt_rounded, size: 56),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  itemCount: _listings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _ListingCard(
                    listing: _listings[i],
                    primary: primary,
                    onDelete: () => _confirmDelete(_listings[i]),
                    onEdit: () {},
                  ),
                ),

          // ─── FAB ─────────────────────────────────────
          Positioned(
            bottom: 24,
            right: 20,
            child: GestureDetector(
              onTap: _addListing,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Listing Card ─────────────────────────────────────────────
class _ListingCard extends StatelessWidget {
  final ServiceListing listing;
  final Color primary;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ListingCard({
    required this.listing,
    required this.primary,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primary, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 90,
                height: 80,

                color: AppColors.primaryLight,
                child: listing.imageUrl.isEmpty
                    ? const Icon(Icons.elderly_outlined, size: 36)
                    : Image.network(listing.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  style: AppTextStyles.labelLg.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '\$${listing.pricePerHour.toStringAsFixed(2)} hrs',
                  style: AppTextStyles.labelMd.copyWith(color: primary),
                ),
                if (listing.hasClientProtection)
                  Text('Client protection Free', style: AppTextStyles.bodyXs),
              ],
            ),
          ),

          // Menu
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'delete') onDelete();
              if (v == 'edit') onEdit();
            },
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.grey400),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Delete Dialog ────────────────────────────────────────────
class _DeleteDialog extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  const _DeleteDialog({required this.onYes, required this.onNo});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to delete ?',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onYes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryProvider,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'YES, DELETE',
                  style: AppTextStyles.buttonMd.copyWith(letterSpacing: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: onNo,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.grey300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "NO, DON'T DELETE",
                  style: AppTextStyles.buttonMd.copyWith(
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
