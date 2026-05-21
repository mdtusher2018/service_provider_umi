part of 'web_app_shell.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HEADER  — role-aware nav links + log-out / download buttons
// ─────────────────────────────────────────────────────────────────────────────

class WebsiteHeader extends ConsumerWidget {
  final AppRole role;
  const WebsiteHeader({super.key, required this.role});

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kIsWeb) return const SizedBox.shrink();

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < mobileBreakpoint;
    final isTablet = width < tabletBreakpoint;

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isMobile
                ? _MobileHeader(role: role)
                : _DesktopHeader(role: role, isTablet: isTablet),
          ),
        ),
      ),
    );
  }
}

class _DesktopHeader extends ConsumerWidget {
  final AppRole role;
  final bool isTablet;

  const _DesktopHeader({required this.role, required this.isTablet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Image.asset(Assets.web.weblogo.keyName, width: isTablet ? 60 : 80),

        const Spacer(),

        /// 👉 Hide nav links on tablet
        if (!isTablet) _NavLinks(role: role),

        const Spacer(),

        /// 👉 Tablet = menu icon
        if (isTablet)
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          )
        else
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 40,
                child: AppButton.outline(
                  label: role == AppRole.guest ? 'Log In' : 'Log Out',
                  borderRadius: 8.circular,
                  onPressed: () =>
                      ref.read(appRouterProvider).go(AppRoutes.login),
                ),
              ),
              10.horizontalSpace,
              SizedBox(
                width: 110,
                height: 40,
                child: AppButton.primary(
                  label: 'Download',
                  borderRadius: 8.circular,
                  onPressed: () {},
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _MobileHeader extends StatelessWidget {
  final AppRole role;

  const _MobileHeader({required this.role});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(Assets.logo.keyName),

        const Spacer(),

        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      ],
    );
  }
}

class AppDrawer extends ConsumerWidget {
  final AppRole role;

  const AppDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    final items = role == AppRole.provider ? _providerNavItems : _userNavItems;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Logo
            Image.asset(Assets.web.weblogo.keyName, width: 80),

            const SizedBox(height: 20),

            /// Nav items
            ...items.map(
              (item) => ListTile(
                title: Text(item.label),
                onTap: () {
                  Navigator.pop(context);
                  router.go(item.route);
                },
              ),
            ),

            const Divider(),

            ListTile(
              title: Text(role == AppRole.guest ? 'Log In' : 'Log Out'),
              onTap: () {
                Navigator.pop(context);
                router.go(AppRoutes.login);
              },
            ),

            ListTile(title: const Text('Download'), onTap: () {}),
          ],
        ),
      ),
    );
  }
}

// ─── Nav links — role-aware ───────────────────────────────────────────────────

/// Uses [appRouterProvider] to get the current location because [WebAppShell]
/// lives inside MaterialApp.router's builder — outside the GoRouter subtree —
/// so [GoRouterState.of(context)] would throw.
class _NavLinks extends ConsumerWidget {
  final AppRole role;
  const _NavLinks({required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = role == AppRole.provider ? _providerNavItems : _userNavItems;

    // .matches can be empty during a redirect frame (e.g. login → home).
    // Use a safe helper instead of .last directly.
    final router = ref.watch(appRouterProvider);
    final matches = router.routerDelegate.currentConfiguration.matches;
    final currentLocation = matches.isNotEmpty
        ? matches.last.matchedLocation
        : '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        final isActive =
            currentLocation == item.route ||
            currentLocation.startsWith('${item.route}/');
        return _NavLinkButton(
          item: item,
          isActive: isActive,
          onTap: () => router.go(item.route),
        );
      }).toList(),
    );
  }
}

class _NavLinkButton extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLinkButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavLinkButton> createState() => _NavLinkButtonState();
}

class _NavLinkButtonState extends State<_NavLinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.isActive
                ? AppColors.primary.withOpacity(0.12)
                : _hovered
                ? AppColors.primary.withOpacity(0.06)
                : Colors.transparent,
          ),
          child: AppText(
            widget.item.label,
            style: TextStyle(
              color: widget.isActive ? AppColors.primary : Colors.black87,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
