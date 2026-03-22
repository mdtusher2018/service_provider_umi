import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

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
      //             12.horizontalSpace,
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
      //             4.horizontalSpace,
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
