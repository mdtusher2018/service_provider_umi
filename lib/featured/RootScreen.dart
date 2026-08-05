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
import 'package:service_provider_umi/core/services/socket/socket_service.dart';
import 'package:service_provider_umi/core/utils/helpers/decode_helper.dart';
import 'package:service_provider_umi/featured/service/screens/user_service_screen/user_service_screen.dart';
import 'package:service_provider_umi/featured/communication_and_notification/riverpod/socket_signaling_provider.dart';
import 'dart:convert';

class RootScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  final AppRole role; // 👈 passed from shell builder, no provider watch needed

  const RootScreen({
    super.key,
    required this.navigationShell,
    required this.role,
  });

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initSocketListener();
  }

  Future<void> _initSocketListener() async {
    _userId = await getMyUserId(ref);
    if (_userId != null) {
      if (widget.role == AppRole.user) {
        SocketService.instance.on('bookingComplete::$_userId', _onBookingComplete);
      }
      
      // Initialize global call listeners
      ref.read(socketSignalingProvider).init(_userId!);
    }
  }

  void _onBookingComplete(dynamic data) {
    if (!mounted) return;
    try {
      final payload = data is Map ? data : (data is String ? jsonDecode(data) : null);
      if (payload != null) {
        final providerId = payload['provider']?['_id'] ?? 
                           payload['provider']?['id'] ?? 
                           payload['providerId'] ?? 
                           payload['provider'];
        
        if (providerId != null && providerId is String) {
          showDialog(
            context: context,
            builder: (_) => RatingDialog(
              providerId: providerId,
              onSubmit: () {
                Navigator.of(context).pop();
              },
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error parsing bookingComplete payload: $e");
    }
  }

  @override
  void dispose() {
    if (_userId != null) {
      SocketService.instance.off('bookingComplete::$_userId', _onBookingComplete);
    }
    super.dispose();
  }

  void _onTap(int index, WidgetRef ref) {
    if (widget.role == AppRole.provider && index == 0) {
      ref.read(providerHomeRefreshProvider.notifier).state++;
    }
    if ((widget.role == AppRole.provider && index == 1) || (widget.role == AppRole.user && index == 3)) {
      ref.read(inboxRefreshProvider.notifier).state++;
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isProvider = widget.role == AppRole.provider;
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: (kIsWeb)
          ? null
          : StyleProvider(
              style: _CustomStyle(),
              child: ConvexAppBar(
              style: TabStyle.fixedCircle,
              backgroundColor: AppColors.white,
              activeColor: AppColors.black,
              color: AppColors.grey500,
              height: 50,
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
                    padding: widget.navigationShell.currentIndex == 2
                        ? 8.paddingAll
                        : 2.paddingAll,
                      decoration: BoxDecoration(
                      color: AppColors.primaryFor(widget.role),

                      shape: BoxShape.circle,
                    ),

                    child: Center(
                      child: Image.asset(
                        widget.role == AppRole.provider
                            ? Assets.icons.upcoming.keyName
                            : Assets.icons.home.keyName,
                        width: 32,
                      ),
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
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _CustomStyle extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 24;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 10, color: color, fontFamily: fontFamily); // Reduced font size to prevent wrapping
  }
}
