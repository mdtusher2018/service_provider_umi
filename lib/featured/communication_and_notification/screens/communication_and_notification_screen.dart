import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/services/socket/chat_socket_service.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/data/models/notification_models.dart';
import 'package:service_provider_umi/featured/_chat/chat_models.dart';
import 'package:service_provider_umi/featured/notification/riverpod/notification_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part '../widgets/communication_and_notification_parts/_history_tile.dart';
part '../widgets/communication_and_notification_parts/_alert_tile.dart';
part '../widgets/communication_and_notification_parts/_contact_tile.dart';
part '../widgets/communication_and_notification_parts/_tab_bar.dart';

class CallHistory {
  final String id;
  final String name;
  final String? imageUrl;
  final DateTime lastTime;
  final CallType type; //audio,video

  const CallHistory({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.lastTime,
    required this.type,
  });
}

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

  final List<CallHistory> _history = [
    CallHistory(
      id: '1',
      name: 'Admin Maria',

      lastTime: DateTime.now().subtract(const Duration(minutes: 5)),
      type: CallType.audio,
    ),
    CallHistory(
      id: '1',
      name: 'Admin Maria',

      lastTime: DateTime.now().subtract(const Duration(minutes: 5)),
      type: CallType.video,
    ),
  ];

  final _chatService = ChatSocketService.instance;
  List<ChatRoom> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(notificationsProvider.notifier).fetch();
    });

    _chatService.chatListStream.listen(_onChatList);
    _chatService.fetchChatList();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _chatService.fetchChatList();
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title ──────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: AppText.h1('Inbox'),
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
                  if (!widget.isNotification ||
                      ref.watch(appRoleProvider) == AppRole.user)
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
    return Column(
      children: [
        // Search bar
        Padding(
          padding: 16.paddingH,
          child: AppSearchBar(
            hint: "Search friends",
            suffix: Icon(Icons.search, size: 24),
          ),
        ),

        12.verticalSpace,

        // Contact list
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                )
              : _rooms.isEmpty
              ? const AppEmptyState(
                  title: 'No conversations',
                  subtitle: 'Start messaging a provider',
                  icon: Icon(Icons.chat, size: 40, color: AppColors.grey400),
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => 20.verticalSpace,
                  itemCount: _rooms.length,
                  itemBuilder: (_, i) => _ContactTile(
                    contact: _rooms[i],
                    onTap: () => context.push(
                      AppRoutes.chatPath(_rooms[i].id),
                      extra: {
                        'name': _rooms[i].otherUser.name,
                        'myId': "",
                        'imageUrl': _rooms[i].otherUser.profile ?? "",
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return Column(
      children: [
        // Contact list
        Expanded(
          child: _history.isEmpty
              ? const AppEmptyState(
                  title: 'No History',
                  subtitle: 'Start messaging a provider',
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => 20.verticalSpace,
                  itemCount: _history.length,
                  itemBuilder: (_, i) {
                    return _HistoryTile(
                      history: _history[i],

                      onTap: () => context.push(
                        AppRoutes.chatPath(_rooms[i].id),
                        extra: {
                          'name': _rooms[i].otherUser.name,
                          'myId': "",
                          'imageUrl': _rooms[i].otherUser.profile,
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAlertsTab() {
    final alertsAsync = ref.watch(notificationsProvider);

    return alertsAsync.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      failure: (e) => Center(child: Text(e.toString())),
      success: (alerts) => RefreshIndicator(
        onRefresh: () async {
          ref.read(notificationsProvider.notifier).fetch();
        },
        child: ListView.separated(
          itemCount: alerts.length,
          separatorBuilder: (_, __) => 16.verticalSpace,
          itemBuilder: (_, i) => _AlertTile(alert: alerts[i]),
        ),
      ),
    );
  }

  Widget _buildLastAlertsTab() {
    final alertsAsync = ref.watch(notificationsProvider);

    return alertsAsync.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      failure: (e) => Center(child: Text(e.toString())),
      success: (alerts) => RefreshIndicator(
        onRefresh: () async {
          ref.read(notificationsProvider.notifier).fetch();
        },
        child: ListView.separated(
          itemCount: alerts.length,
          separatorBuilder: (_, __) => 16.verticalSpace,
          itemBuilder: (_, i) => _AlertTile(alert: alerts[i]),
        ),
      ),
    );
  }
}
