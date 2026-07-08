import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/communication_and_notification_screen/communication_and_notification_screen.dart';
import 'package:service_provider_umi/featured/service/screens/service_provider_home_screen.dart';

import '../l10n/app_localizations.dart';

class RootScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final AppRole role; // 👈 passed from shell builder, no provider watch needed

  const RootScreen({
    super.key,
    required this.navigationShell,
    required this.role,
  });

  void _onTap(int index, WidgetRef ref) {
    if (role == AppRole.provider && index == 2) {
      ref.read(providerHomeRefreshProvider.notifier).state++;
    }
    if ((role == AppRole.provider && index == 1) || (role == AppRole.user && index == 3)) {
      ref.read(inboxRefreshProvider.notifier).state++;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProvider = role == AppRole.provider;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: (kIsWeb)
          ? null
          : ConvexAppBar(
              style: TabStyle.fixedCircle,
              backgroundColor: AppColors.white,
              activeColor: AppColors.black,
              color: AppColors.grey500,
              height: 80,
              curveSize: 100,
              items: [
                TabItem(
                  icon: isProvider
                      ? Icons.calendar_month_outlined
                      : Icons.calendar_today_outlined,
                  title: isProvider ? "Calendar" : "Service",
                ),
                // index 1
                TabItem(
                  icon: isProvider
                      ? Icons.chat_bubble_outline
                      : Icons.favorite_border,
                  title: isProvider ? "Inbox" : "Favourites",
                ),
                TabItem(
                  icon: Container(
                    padding: navigationShell.currentIndex == 2
                        ? 8.paddingAll
                        : 2.paddingAll,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFor(role),

                      shape: BoxShape.circle,
                    ),

                    child: Image.asset(
                      role == AppRole.provider
                          ? Assets.icons.upcoming.keyName
                          : Assets.icons.home.keyName,
                      width: 32,
                    ),
                  ),
                  title: AppLocalizations.of(context)!.home,
                ),

                TabItem(
                  icon: isProvider
                      ? Icons.notifications_none
                      : Icons.chat_bubble_outline,
                  title: isProvider ? AppLocalizations.of(context)!.notification : AppLocalizations.of(context)!.inbox,
                ),
                // index 4
                TabItem(icon: Icons.person_outline, title: AppLocalizations.of(context)!.profile),
              ],
              onTap: (index) => _onTap(index, ref),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
