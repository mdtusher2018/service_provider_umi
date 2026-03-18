import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/chat_screen.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

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

enum AlertType { orderAccepted, orderComplete, cancelOrder }

enum CallType { audio, video }

// ─── Screen ───────────────────────────────────────────────────
class CommunicationAndNotificationScreen extends ConsumerStatefulWidget {
  const CommunicationAndNotificationScreen({
    super.key,
    this.isNotification = false,
  });
  final bool isNotification;

  @override
  ConsumerState<CommunicationAndNotificationScreen> createState() =>
      _InboxScreenState();
}

class _InboxScreenState
    extends ConsumerState<CommunicationAndNotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

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
            _InboxTabBar(
              controller: _tabController,
              isNotification: widget.isNotification,
            ),
            const SizedBox(height: 16),

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

        const SizedBox(height: 12),

        // Contact list
        Expanded(
          child: _filteredContacts.isEmpty
              ? const AppEmptyState(
                  title: 'No conversations',
                  subtitle: 'Start messaging a provider',
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => SizedBox(height: 20),
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
                  separatorBuilder: (context, index) => SizedBox(height: 20),
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
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _AlertTile(alert: _alerts[i]),
    );
  }

  Widget _buildLastAlertsTab() {
    return ListView.separated(
      itemCount: _alerts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _AlertTile(alert: _alerts[i]),
    );
  }
}

// ─── Tab Bar ──────────────────────────────────────────────────
class _InboxTabBar extends ConsumerWidget {
  final TabController controller;
  final bool isNotification;

  const _InboxTabBar({required this.controller, required this.isNotification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabBar(
      controller: controller,
      dividerColor: AppColors.grey500,
      indicatorColor: AppColors.primaryFor(ref.watch(appRoleProvider)),
      indicatorWeight: 2,

      indicatorSize: TabBarIndicatorSize.label,
      tabs: [
        if (!isNotification || ref.watch(appRoleProvider) == AppRole.user)
          Tab(child: AppText.labelLg("Chat", fontWeight: FontWeight.w600)),
        if (isNotification || ref.watch(appRoleProvider) == AppRole.user)
          Tab(child: AppText.labelLg("Alerts", fontWeight: FontWeight.w600)),
        if (!isNotification && ref.watch(appRoleProvider) != AppRole.user)
          Tab(child: AppText.labelLg("History", fontWeight: FontWeight.w600)),
        if (isNotification)
          Tab(
            child: AppText.labelLg("Last Alerts", fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}

// ─── History Tile ─────────────────────────────────────────────
class _HistoryTile extends ConsumerWidget {
  final CallHistory history;
  final VoidCallback onTap;
  const _HistoryTile({required this.history, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 6),
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 5,
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              AppAvatar(
                name: history.name,
                imageUrl: history.imageUrl,
                size: AvatarSize.md,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelLg(history.name),
                    const SizedBox(height: 2),
                    AppText.bodySm(
                      history.lastTime.toRelativeTime,
                      maxLines: 1,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              (history.type == CallType.audio)
                  ? Icon(Icons.call)
                  : Icon(Icons.videocam_outlined),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Contact Tile ─────────────────────────────────────────────
class _ContactTile extends ConsumerWidget {
  final InboxContact contact;
  final VoidCallback onTap;
  const _ContactTile({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 6),
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 5,
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              AppAvatar(
                name: contact.name,
                imageUrl: contact.imageUrl,
                size: AvatarSize.md,
                isOnline: contact.isOnline,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelLg(contact.name),
                    const SizedBox(height: 2),
                    AppText.bodySm(
                      contact.lastMessage,
                      maxLines: 1,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText.bodyXs(contact.lastTime.toRelativeTime),
                  const SizedBox(height: 4),
                  if (contact.unreadCount > 0)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${contact.unreadCount}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Alert Tile ───────────────────────────────────────────────
class _AlertTile extends StatelessWidget {
  final AlertItem alert;
  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    Color iconBg;
    Color iconColor;
    IconData icon;

    switch (alert.type) {
      case AlertType.orderAccepted:
        iconBg = AppColors.star;
        iconColor = AppColors.white;
        icon = Icons.check_circle_outline_rounded;
        break;
      case AlertType.orderComplete:
        iconBg = AppColors.success;
        iconColor = AppColors.white;
        icon = Icons.task_alt_rounded;
        break;
      case AlertType.cancelOrder:
        iconBg = AppColors.error;
        iconColor = AppColors.white;
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 6),
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.labelLg(alert.title),
                  const SizedBox(height: 2),
                  AppText.bodySm(
                    alert.description,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Icon(Icons.watch_later_outlined, size: 16),
                AppText.bodySm(
                  alert.time.toRelativeTime,
                  color: AppColors.textgrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
