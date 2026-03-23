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

  @override
  Widget build(BuildContext context) {
    // final primary = AppColors.primaryFor(ref.watch(appRoleProvider));

    return Scaffold(
      appBar: AppAppBar(),
      body: Center(child: AppText.h1("Map will be their on intregration")),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
