import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';

import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../../core/di/app_role_provider.dart';
import '../../../core/theme/app_colors.dart';

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
        onTap: () => context.push(AppRoutes.workAreas),
      ),

      _PrefItem(
        icon: Icons.access_time_rounded,
        label: 'My schedule',
        onTap: () => context.push(AppRoutes.workSchedule),
      ),

      _PrefItem(
        icon: Icons.attach_money_rounded,
        label: 'Minimum booking amount',
        onTap: () => context.push(AppRoutes.minimumPrice),
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
