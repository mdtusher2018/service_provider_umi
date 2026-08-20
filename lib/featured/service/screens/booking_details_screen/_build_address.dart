part of 'booking_details_screen.dart';

// ─── Address ──────────────────────────────────────────────────────────────
Widget _buildAddress(BookingDetailModel data, BuildContext context) {
  final addressModel = data.address;
  final coords = data.provider?.location?.coordinates;

  final addressText = addressModel != null
      ? addressModel.displayAddress
      : (coords != null && coords.length >= 2)
          ? AppLocalizations.of(context)!.addressCoordsLabel(coords[1].toStringAsFixed(4), coords[0].toStringAsFixed(4))
          : AppLocalizations.of(context)!.addressNotAvailable;

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
