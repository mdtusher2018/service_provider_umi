import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/chat_screen.dart';
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

// ─── Models ───────────────────────────────────────────────────
class InboxContact {
  final String id;
  final String name;
  final String? imageUrl;
  final String lastMessage;
  final DateTime lastTime;
  final int unreadCount;
  final bool isOnline;

  const InboxContact({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.lastMessage,
    required this.lastTime,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

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

class AlertItem {
  final String id;
  final String title;
  final String description;
  final DateTime time;
  final AlertType type;

  const AlertItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
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
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final String _searchQuery = '';

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
  final List<InboxContact> _contacts = [
    InboxContact(
      id: '1',
      name: 'Admin Maria',
      lastMessage: 'Hello, How are you Im Designer',
      lastTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      isOnline: true,
    ),
    InboxContact(
      id: '2',
      name: 'NB Sujon',
      lastMessage: 'Hello, How are you Im Designer',
      lastTime: DateTime.now().subtract(const Duration(minutes: 10)),
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  final List<AlertItem> _alerts = [
    AlertItem(
      id: '1',
      title: 'Order Accepted',
      description: 'We have accepted your order. Click to view details.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: AlertType.orderAccepted,
    ),
    AlertItem(
      id: '2',
      title: 'Order Complete',
      description: 'We have accepted your order. Click to view details.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: AlertType.orderComplete,
    ),
    AlertItem(
      id: '3',
      title: 'Cancel order',
      description: 'We have accepted your order. Click to view details.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: AlertType.cancelOrder,
    ),
  ];

  List<InboxContact> get _filteredContacts => _searchQuery.isEmpty
      ? _contacts
      : _contacts
            .where(
              (c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AppSearchBar(
            hint: "Search friends",
            suffix: Icon(Icons.search, size: 24),
          ),
        ),

        12.verticalSpace,

        // Contact list
        Expanded(
          child: _filteredContacts.isEmpty
              ? const AppEmptyState(
                  title: 'No conversations',
                  subtitle: 'Start messaging a provider',
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => 20.verticalSpace,
                  itemCount: _filteredContacts.length,
                  itemBuilder: (_, i) => _ContactTile(
                    contact: _filteredContacts[i],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          contactId: _filteredContacts[i].id,
                          contactName: _filteredContacts[i].name,
                          contactImageUrl: _filteredContacts[i].imageUrl,
                        ),
                      ),
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
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            contactId: _filteredContacts[i].id,
                            contactName: _filteredContacts[i].name,
                            contactImageUrl: _filteredContacts[i].imageUrl,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAlertsTab() {
    return ListView.separated(
      itemCount: _alerts.length,
      separatorBuilder: (_, __) => 16.verticalSpace,
      itemBuilder: (_, i) => _AlertTile(alert: _alerts[i]),
    );
  }

  Widget _buildLastAlertsTab() {
    return ListView.separated(
      itemCount: _alerts.length,
      separatorBuilder: (_, __) => 16.verticalSpace,
      itemBuilder: (_, i) => _AlertTile(alert: _alerts[i]),
    );
  }
}

