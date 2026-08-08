import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/config/app_config.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/services/socket/chat_socket_service.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/utils/helpers/decode_helper.dart';
import 'package:service_provider_umi/data/models/history_model.dart';
import 'package:service_provider_umi/data/models/notification_models.dart';
import 'package:service_provider_umi/data/models/chat_models.dart';
import 'package:service_provider_umi/featured/communication_and_notification/riverpod/communication_and_notification_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';

import '../../../../l10n/app_localizations.dart';
part '_history_tile.dart';
part '_alert_tile.dart';
part '_contact_tile.dart';
part '_tab_bar.dart';

final inboxRefreshProvider = StateProvider<int>((ref) => 0);

// ─── Screen ───────────────────────────────────────────────────
class CommunicationAndNotificationScreen extends ConsumerStatefulWidget {
  const CommunicationAndNotificationScreen({
    super.key,
    this.isNotification = false,
  });
  final bool isNotification;

  @override
  ConsumerState<CommunicationAndNotificationScreen> createState() =>
      _CommunicationAndNotificationScreenState();
}

class _CommunicationAndNotificationScreenState
    extends ConsumerState<CommunicationAndNotificationScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  final _searchController = TextEditingController();

  final _chatService = ChatSocketService.instance;
  List<ChatRoom> _rooms = [];
  String _searchQuery = '';
  bool _isLoading = true;
  StreamSubscription<String>? _errorSub;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final role = ref.read(appRoleProvider);
      if (widget.isNotification || role == AppRole.user) {
        ref.read(notificationsProvider.notifier).fetch();
      }
      if (!widget.isNotification) {
        ref.read(callHistoryProvider.notifier).fetch();
      }
    });

    initializedChatService();

    _chatService.chatListStream.listen(_onChatList);
    _chatService.fetchChatList(onAck: (response) {});
    _errorSub = _chatService.errorStream.listen(_onSocketError);
  }

  Future<void> initializedChatService() async {
    final token = await ref
        .read(localStorageProvider)
        .read(StorageKey.accessToken);

    AppLogger.success("[Connected]: Chat Socket Sucessfully connected");

    ChatSocketService.instance.init(
      baseUrl: AppConfig.socketUrl,
      token: token ?? "",
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _chatService.fetchChatList(onAck: (response) {});
    }
  }

  void _onChatList(List<ChatRoom> rooms) {
    if (!mounted) return;
    setState(() {
      _rooms = rooms;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _errorSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onSocketError(String message) async {
    final connected = await ref.read(networkInfoProvider).isConnected;
    if (!mounted || !connected) return;
    context.showErrorSnackBar(message);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(inboxRefreshProvider, (_, __) {
      final role = ref.read(appRoleProvider);
      if (!widget.isNotification || role == AppRole.user) {
        _chatService.fetchChatList(onAck: (response) {});
      }
      if (widget.isNotification || role == AppRole.user) {
        ref.read(notificationsProvider.notifier).fetch();
      }
      if (!widget.isNotification) {
        ref.read(callHistoryProvider.notifier).fetch();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  if (context.canPop())
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () => context.pop(),
                        child: const Icon(Icons.arrow_back_ios_rounded),
                      ),
                    ),
                  const AppText.h1('Inbox'),
                ],
              ),
            ),

            // ─── Tab Bar ────────────────────────────
            _TabBar(
              controller: _tabController,
              isNotification: widget.isNotification,
            ),
            16.verticalSpace,

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  if (!widget.isNotification)
                    _buildChatTab(),
                  if (widget.isNotification ||
                      ref.watch(appRoleProvider) == AppRole.user)
                    _buildAlertsTab(),
                  if (!widget.isNotification &&
                      ref.watch(appRoleProvider) != AppRole.user)
                    _buildHistoryTab(),
                  if (widget.isNotification) _buildLastAlertsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    final filteredRooms = _rooms.where((r) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = r.otherUser.name.toLowerCase();
      final email = r.otherUser.email.toLowerCase();
      return name.contains(q) || email.contains(q);
    }).toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: 16.paddingH,
          child: AppSearchBar(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            hint: AppLocalizations.of(context)!.searchFriends,
            suffix: Icon(Icons.search, size: 24),
          ),
        ),

        12.verticalSpace,

        // Contact list
        Expanded(
          child: _isLoading
              ? AppLoader()
              : filteredRooms.isEmpty
              ? const AppEmptyState(
                  title: 'No conversations',
                  subtitle: 'Start messaging a provider',
                  icon: Icon(Icons.chat, size: 40, color: AppColors.grey400),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    _chatService.fetchChatList(onAck: (response) {});
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) => 20.verticalSpace,
                    itemCount: filteredRooms.length,
                    itemBuilder: (_, i) => _ContactTile(
                      contact: filteredRooms[i],
                      onTap: () async {
                        final myUserId = await getMyUserId(ref);
                        if (kIsWeb) {
                          context.go(
                            AppRoutes.chatPath(filteredRooms[i].id),
                            extra: {
                              'otherUserId': filteredRooms[i].otherUser.id,
                              'name': filteredRooms[i].otherUser.name,
                              'myId': myUserId,
                              'imageUrl': filteredRooms[i].otherUser.profile ?? "",
                            },
                          );
                        } else {
                          context.push(
                            AppRoutes.chatPath(filteredRooms[i].id),
                            extra: {
                              'otherUserId': filteredRooms[i].otherUser.id,
                              'name': filteredRooms[i].otherUser.name,
                              'myId': myUserId,
                              'imageUrl': filteredRooms[i].otherUser.profile ?? "",
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    final state = ref.watch(callHistoryProvider);

    return state.when(
      initial: () => const AppLoader(),
      loading: () => const AppLoader(),
      failure: (e) => AppErrorWidget(
        error: e,
        onRetry: () => ref.read(callHistoryProvider.notifier).fetch(),
      ),
      success: (history) {
        if (history.isEmpty) {
          return const AppEmptyState(
            title: 'No History',
            subtitle: 'Start calling a provider',
          );
        }

        return ListView.separated(
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => 20.verticalSpace,
          itemCount: history.length,
          itemBuilder: (_, i) {
            final item = history[i];

            return _HistoryTile(
              history: item,

              onTap: () async {
                final myUserId = await getMyUserId(ref);

                context.push(
                  AppRoutes.chatPath(item.receiver?.id ?? ''),
                  extra: {
                    'otherUserId': item.receiver?.id,
                    'name': item.receiver?.name ?? "",
                    'myId': myUserId,
                    'imageUrl': item.receiver?.profile,
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAlertsTab() {
    final alertsAsync = ref.watch(notificationsProvider);

    return alertsAsync.when(
      initial: () => const AppLoader(),
      loading: () => const AppLoader(),
      failure: (e) => AppErrorWidget(
        error: e,
        onRetry: () => ref.read(notificationsProvider.notifier).fetch(),
      ),
      success: (alerts) {
        /// ✅ FIX: return empty state
        if (alerts.isEmpty) {
          return const AppEmptyState(title: "No Alerts");
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.read(notificationsProvider.notifier).fetch();
          },
          child: ListView.separated(
            itemCount: alerts.length,
            separatorBuilder: (_, __) => 16.verticalSpace,
            itemBuilder: (_, i) => _AlertTile(alert: alerts[i]),
          ),
        );
      },
    );
  }

  Widget _buildLastAlertsTab() {
    final alertsAsync = ref.watch(notificationsProvider);
    final markState = ref.watch(markNotificationsProvider);

    return alertsAsync.when(
      initial: () => const AppLoader(),
      loading: () => const AppLoader(),
      failure: (e) => AppErrorWidget(
        error: e,
        onRetry: () => ref.read(notificationsProvider.notifier).fetch(),
      ),
      success: (List<NotificationItem> alerts) {
        final unreadAlerts = alerts.where((e) => e.isRead != true).toList();

        /// ✅ FIX: return empty state
        if (unreadAlerts.isEmpty) {
          return AppEmptyState(title: AppLocalizations.of(context)!.noUnreadAlerts);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.read(notificationsProvider.notifier).fetch();
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      await ref.read(markNotificationsProvider.notifier).mark();

                      /// Optional: refresh list after marking
                      ref.read(notificationsProvider.notifier).fetch();
                    },
                    child: AppText.bodyMd("Mark All Read"),
                  ),
                  8.horizontalSpace,

                  /// ✅ FIX: Proper loading indicator
                  if (markState is NotificationActionLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),

                  20.horizontalSpace,
                ],
              ),
              8.verticalSpace,
              Expanded(
                child: ListView.separated(
                  itemCount: unreadAlerts.length,
                  separatorBuilder: (_, __) => 16.verticalSpace,

                  /// ✅ FIX: use unreadAlerts
                  itemBuilder: (_, i) => _AlertTile(alert: unreadAlerts[i]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
