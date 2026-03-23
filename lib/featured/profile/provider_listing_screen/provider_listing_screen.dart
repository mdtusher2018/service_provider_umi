import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../../../core/di/app_role_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
part '_delete_dialog.dart';
part '_listing_card.dart';

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
          context.pop();
        },
        onNo: () => context.pop(),
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
                  separatorBuilder: (_, __) => 12.verticalSpace,
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
