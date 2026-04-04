part of 'provider_listing_screen.dart';

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
        borderRadius: 14.circular,
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
            padding: 8.paddingAll,
            child: ClipRRect(
              borderRadius: 8.circular,
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
          12.horizontalSpace,

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelLg(listing.title, fontWeight: FontWeight.w700),
                3.verticalSpace,
                AppText.labelMd(
                  '\$${listing.pricePerHour.toStringAsFixed(2)} hrs',
                  color: primary,
                ),
                if (listing.hasClientProtection)
                  AppText.bodyXs('Client protection Free'),
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
              const PopupMenuItem(value: 'edit', child: AppText('Edit')),
              const PopupMenuItem(
                value: 'delete',
                child: AppText('Delete', color: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
