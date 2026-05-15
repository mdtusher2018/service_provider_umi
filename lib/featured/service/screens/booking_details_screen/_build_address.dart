part of 'booking_details_screen.dart';

// ─── Address ──────────────────────────────────────────────────────────────
Widget _buildAddress(BookingDetailModel data) {
  final coords = data.provider?.location?.coordinates;
  final addressText = (coords != null && coords.length >= 2)
      ? 'Lat: ${coords[1].toStringAsFixed(4)}, Lng: ${coords[0].toStringAsFixed(4)}'
      : 'Address not available';

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(
        Icons.location_on_outlined,
        size: 18,
        color: AppColors.grey400,
      ),
      8.horizontalSpace,
      Expanded(
        child: AppText.bodyMd(addressText, color: AppColors.textSecondary),
      ),
    ],
  );
}
