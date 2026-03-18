import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/work_schedule_screen.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import '../../core/di/app_role_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// ════════════════════════════════════════════════════════════
//  1. Preferences Screen
// ════════════════════════════════════════════════════════════
class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = AppColors.primaryFor(ref.watch(appRoleProvider));

    final items = [
      _PrefItem(
        icon: Icons.location_on_outlined,
        label: 'My work areas',
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const WorkAreasScreen())),
      ),
      _PrefItem(
        icon: Icons.access_time_rounded,
        label: 'My schedule',
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => WorkScheduleScreen())),
      ),
      _PrefItem(
        icon: Icons.attach_money_rounded,
        label: 'Minimum booking amount',
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MinimumPriceScreen())),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: "Preferences"),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: AppColors.grey200),
        itemBuilder: (_, i) => _PrefTile(item: items[i], primary: primary),
      ),
    );
  }
}

class _PrefItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PrefItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _PrefTile extends StatelessWidget {
  final _PrefItem item;
  final Color primary;
  const _PrefTile({required this.item, required this.primary});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(item.icon, color: primary, size: 24),
      ),
      title: AppText.bodyMd(item.label),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
      onTap: item.onTap,
    );
  }
}

// ════════════════════════════════════════════════════════════
//  2. Work Areas Screen (Google Maps + radius)
// ════════════════════════════════════════════════════════════
class WorkAreasScreen extends ConsumerStatefulWidget {
  const WorkAreasScreen({super.key});

  @override
  ConsumerState<WorkAreasScreen> createState() => _WorkAreasScreenState();
}

class _WorkAreasScreenState extends ConsumerState<WorkAreasScreen> {
  GoogleMapController? _mapController;
  // static const _paris = LatLng(48.8566, 2.3522);
  // static const _providerLoc = LatLng(48.847, 2.338);
  // static const _initialCamera = CameraPosition(target: _paris, zoom: 12.5);
  // Set<Marker> get _markers => {
  //   Marker(
  //     markerId: const MarkerId('provider'),
  //     position: _providerLoc,
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   ),
  //   Marker(
  //     markerId: const MarkerId('client'),
  //     position: _paris,
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //   ),
  // };
  // Set<Polyline> get _polylines => {
  //   Polyline(
  //     polylineId: PolylineId('route'),
  //     color: Color(0xFF0084BF),
  //     width: 2,
  //     points: [_providerLoc, _paris],
  //     patterns: [PatternItem.dash(12), PatternItem.gap(6)],
  //   ),
  // };

  @override
  Widget build(BuildContext context) {
    // final primary = AppColors.primaryFor(ref.watch(appRoleProvider));

    return Scaffold(
      appBar: AppAppBar(),
      body: Center(child: AppText.h1("Map will be their on intregration")),
      // body: Stack(
      //   children: [
      //     // ─── Full-screen map ─────────────────────────
      //     GoogleMap(
      //       initialCameraPosition: _initialCamera,
      //       onMapCreated: (c) => _mapController = c,
      //       markers: _markers,
      //       polylines: _polylines,
      //       myLocationButtonEnabled: false,
      //       zoomControlsEnabled: false,
      //       mapToolbarEnabled: false,
      //     ),
      //     // ─── Top bar ─────────────────────────────────
      //     SafeArea(
      //       child: Padding(
      //         padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      //         child: Row(
      //           children: [
      //             GestureDetector(
      //               onTap: () => Navigator.of(context).pop(),
      //               child: Container(
      //                 width: 36,
      //                 height: 36,
      //                 decoration: BoxDecoration(
      //                   color: AppColors.white,
      //                   shape: BoxShape.circle,
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: Colors.black.withOpacity(0.1),
      //                       blurRadius: 8,
      //                     ),
      //                   ],
      //                 ),
      //                 child: Icon(
      //                   Icons.arrow_back_ios_rounded,
      //                   color: primary,
      //                   size: 16,
      //                 ),
      //               ),
      //             ),
      //             const SizedBox(width: 12),
      //             AppText(
      //               'Work areas',
      //               style: AppTextStyles.h2.copyWith(color: primary),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     // ─── Distance badge ───────────────────────────
      //     Positioned(
      //       top: MediaQuery.of(context).padding.top + 70,
      //       right: 20,
      //       child: Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      //         decoration: BoxDecoration(
      //           color: AppColors.white,
      //           borderRadius: BorderRadius.circular(20),
      //           boxShadow: [
      //             BoxShadow(
      //               color: Colors.black.withOpacity(0.1),
      //               blurRadius: 8,
      //             ),
      //           ],
      //         ),
      //         child: Row(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Icon(Icons.near_me_rounded, color: primary, size: 14),
      //             const SizedBox(width: 4),
      //             Text(
      //               '8 KM',
      //               style: AppTextStyles.labelMd.copyWith(
      //                 color: AppColors.textPrimary,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     // ─── Start Service button ─────────────────────
      //     Positioned(
      //       bottom: 0,
      //       left: 0,
      //       right: 0,
      //       child: Container(
      //         padding: EdgeInsets.fromLTRB(
      //           20,
      //           12,
      //           20,
      //           MediaQuery.of(context).padding.bottom + 12,
      //         ),
      //         child: SizedBox(
      //           width: double.infinity,
      //           height: 52,
      //           child: ElevatedButton(
      //             onPressed: () {},
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: primary,
      //               foregroundColor: AppColors.white,
      //               elevation: 0,
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(12),
      //               ),
      //             ),
      //             child: Text('Start Service', style: AppTextStyles.buttonLg),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

// ════════════════════════════════════════════════════════════
//  3. Minimum Price Screen
// ════════════════════════════════════════════════════════════
class MinimumPriceScreen extends ConsumerStatefulWidget {
  const MinimumPriceScreen({super.key});

  @override
  ConsumerState<MinimumPriceScreen> createState() => _MinimumPriceScreenState();
}

class _MinimumPriceScreenState extends ConsumerState<MinimumPriceScreen> {
  double _price = 15;
  bool _isSaving = false;

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: AppText('Minimum price saved successfully')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryFor(ref.watch(appRoleProvider));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: primary, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.h1('Minimum price'),
            const SizedBox(height: 8),
            AppLinkText(
              "What is the minimum price a client must pay to book your service?  +info",
              links: [AppTextLink(label: "+info", onTap: () {})],
              linkColor: AppColors.primaryFor(AppRole.provider),
            ),

            const SizedBox(height: 32),

            // ─── Price input box ──────────────────────
            Center(
              child: Container(
                width: 180,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primary, width: 1.5),
                ),
                child: Column(
                  children: [
                    AppText.bodyMd('Minimum price:'),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: AppTextField()),
                        // Stepper controls
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _price += 1),
                              child: Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: AppColors.grey400,
                                size: 22,
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.textPrimary,
                                  width: 1.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '\$',
                                  style: AppTextStyles.labelLg.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                if (_price > 1) _price -= 1;
                              }),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.grey400,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─── Tip banner ──────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "This will avoid being booked for a price so low that it's "
                      'not worth your time to commute to the service',
                      style: AppTextStyles.bodySm,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ─── Save button ─────────────────────────
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text('Save', style: AppTextStyles.buttonLg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
