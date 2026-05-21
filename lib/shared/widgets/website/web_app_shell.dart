import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/router/app_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/theme/app_text_styles.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part 'website_header.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────────────────────

const double kWebAppMaxWidth = 430.0;
const double kWebAppMaxHeight = 860.0;

// ─────────────────────────────────────────────────────────────────────────────
// Nav item model — carries both user and provider variants
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem {
  final String label;
  final String route;
  final int branchIndex; // matches StatefulShellRoute branch index

  const _NavItem({
    required this.label,
    required this.route,
    required this.branchIndex,
  });
}

// Nav definitions — mirrors StatefulShellRoute branch order exactly
const _userNavItems = [
  _NavItem(label: 'Services', route: AppRoutes.services, branchIndex: 0),
  _NavItem(label: 'Favourites', route: AppRoutes.favourites, branchIndex: 1),
  _NavItem(label: 'Home', route: AppRoutes.userHome, branchIndex: 2),
  _NavItem(label: 'Inbox', route: AppRoutes.inbox, branchIndex: 3),
  _NavItem(label: 'Profile', route: AppRoutes.profile, branchIndex: 4),
];

const _providerNavItems = [
  _NavItem(
    label: 'Calendar',
    route: AppRoutes.providerServices,
    branchIndex: 0,
  ),
  _NavItem(label: 'Inbox', route: AppRoutes.providerInbox, branchIndex: 1),
  _NavItem(label: 'Home', route: AppRoutes.providerHome, branchIndex: 2),
  _NavItem(
    label: 'Notifications',
    route: AppRoutes.providerNotifications,
    branchIndex: 3,
  ),
  _NavItem(label: 'Profile', route: AppRoutes.providerProfile, branchIndex: 4),
];

// ─────────────────────────────────────────────────────────────────────────────
// WebAppShell
// Wraps the GoRouter shell child. On web: adds header + phone frame + footer.
// On native: renders the child directly (no-op wrapper).
// ─────────────────────────────────────────────────────────────────────────────

class WebAppShell extends ConsumerWidget {
  final Widget child;
  const WebAppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kIsWeb) return child;

    final role = ref.watch(appRoleProvider);
    final real = MediaQuery.of(context);
    final screenWidth = real.size.width;
    final screenHeight = real.size.height;

    final double containerWidth = screenWidth < kWebAppMaxWidth
        ? screenWidth
        : kWebAppMaxWidth;
    final double containerHeight = screenHeight < kWebAppMaxHeight
        ? screenHeight
        : kWebAppMaxHeight;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      endDrawer: AppDrawer(role: role),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Full-width header ────────────────────────────────────────────
            WebsiteHeader(role: role),

            // ── Phone container ──────────────────────────────────────────────
            Center(
              child: SizedBox(
                width: containerWidth,
                height: containerHeight,
                child: MediaQuery(
                  data: real.copyWith(
                    size: Size(containerWidth, containerHeight),
                    devicePixelRatio: real.devicePixelRatio.clamp(1.0, 3.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: child,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // ── Website sections ─────────────────────────────────────────────
            const WebsiteBody(),

            // ── Footer ───────────────────────────────────────────────────────
            _WebsiteFooter(role: role),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FOOTER — role-aware nav links
// ─────────────────────────────────────────────────────────────────────────────

class _WebsiteFooter extends StatelessWidget {
  final AppRole role;
  const _WebsiteFooter({required this.role});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    final items = role == AppRole.provider ? _providerNavItems : _userNavItems;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.only(top: 36, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Logo ──────────────────────────────────────────────────────────
          _FooterLogo(),

          const SizedBox(height: 20),

          // ── Nav links ─────────────────────────────────────────────────────
          Wrap(
            spacing: 32,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: items
                .map(
                  (item) =>
                      _FooterNavItem(label: item.label, route: item.route),
                )
                .toList(),
          ),

          const SizedBox(height: 20),

          // ── Divider ───────────────────────────────────────────────────────
          AppDivider(),
          const SizedBox(height: 16),

          // ── Copyright ─────────────────────────────────────────────────────
          AppText.bodyMd('Copyright iBadi'),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FooterLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 3,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        AppText.bodyMd('Badi'),
      ],
    );
  }
}

class _FooterNavItem extends ConsumerStatefulWidget {
  final String label;
  final String route;
  const _FooterNavItem({required this.label, required this.route});

  @override
  ConsumerState<_FooterNavItem> createState() => _FooterNavItemState();
}

class _FooterNavItemState extends ConsumerState<_FooterNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => ref.read(appRouterProvider).go(widget.route),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTextStyles.bodyMd.copyWith(
            color: _hovered ? AppColors.primary : null,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Design tokens (local, mirrors iBadi brand)
// ─────────────────────────────────────────────────────────────────────────────

abstract class _T {
  static const Color textDark = Color(0xFF1A2332);
  static const Color textBody = Color(0xFF6B7A8D);
  static const Color textMuted = Color(0xFF9AA5B4);
  static const Color white = Color(0xFFFFFFFF);
  static const Color bgLight = Color(0xFFF7F9FC);
  static const Color bgReviews = Color(0xFFE8FAF7);
  static const Color bgCta = Color(0xFF00BFA5);
  static const Color cardBorder = Color(0xFFECF0F5);
  static const Color checkIcon = Color(0xFF00BFA5);

  static const double maxWidth = 1100.0;
  static const double sectionV = 72.0;
  static const double sectionH = 40.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// WebsiteBody — all landing sections
// ─────────────────────────────────────────────────────────────────────────────

class WebsiteBody extends StatelessWidget {
  const WebsiteBody({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    return const Column(
      children: [
        _AboutUsSection(),
        _OurServicesSection(),
        _ClientReviewsSection(),
        _BestCenterSection(),
        _CtaBannerSection(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 1 — About Us
// ─────────────────────────────────────────────────────────────────────────────

class _AboutUsSection extends StatelessWidget {
  const _AboutUsSection();

  static const _checks = [
    'Lorem ipsum dolor sit amet consectetur.',
    'Augue non malesuada placerat faucibus nam purus sem.',
    'Urna pulvinar porttitor dignissim congue pellentesque ac hac.',
    'Eu adipiscing massa ut proin mauris orci tincidunt ac in.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _T.white,
      padding: const EdgeInsets.symmetric(
        vertical: _T.sectionV,
        horizontal: _T.sectionH,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _T.maxWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: _AboutImage()),
                    const SizedBox(width: 64),
                    Expanded(flex: 6, child: _AboutText(checks: _checks)),
                  ],
                );
              }
              return Column(
                children: [
                  _AboutImage(),
                  const SizedBox(height: 40),
                  _AboutText(checks: _checks),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AboutImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 20,
            top: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 3),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 20,
            bottom: 20,
            child: ClipRRect(
              borderRadius: 4.circular,
              child: Image.asset(Assets.web.care1.keyName, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutText extends StatelessWidget {
  final List<String> checks;
  const _AboutText({required this.checks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h1('About Us', fontSize: 32),
        const SizedBox(height: 16),
        AppText.labelLg(
          'Lorem ipsum dolor sit amet consectetur. Augue non malesuada '
          'placerat faucibus nam purus sem. Uma pulvinar porttitor '
          'dignissim congue pellentesque ac hac.',
        ),
        const SizedBox(height: 20),
        ...checks.map((text) => _CheckItem(text: text)),
        const SizedBox(height: 28),
        Container(
          constraints: BoxConstraints(maxWidth: 120),
          child: AppButton.primary(label: 'Booking', onPressed: () {}),
        ),
      ],
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String text;
  const _CheckItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.library_add_check_outlined, color: _T.checkIcon),
          const SizedBox(width: 10),
          Expanded(child: AppText.labelLg(text)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 2 — Our Services
// ─────────────────────────────────────────────────────────────────────────────

class _OurServicesSection extends StatelessWidget {
  const _OurServicesSection();

  static const _services = [
    _ServiceData(
      title: 'Resident Care',
      icon: Icons.home_work_outlined,
      body:
          'Lorem ipsum dolor sit amet consectetur. Augue non malesuada placerat faucibus nam purus sem. Uma pulvinar porttitor dignissim congue pellentesque ac hac.',
      hasBg: false,
    ),
    _ServiceData(
      title: 'Elderly Nutrition',
      icon: Icons.restaurant_menu_outlined,
      body:
          'Lorem ipsum dolor sit amet consectetur. Augue non malesuada placerat faucibus nam purus sem. Uma pulvinar porttitor dignissim congue pellentesque ac hac.',
      hasBg: false,
    ),
    _ServiceData(
      title: 'Resident Care',
      icon: Icons.home_work_outlined,
      body:
          'Lorem ipsum dolor sit amet consectetur. Augue non malesuada placerat faucibus nam purus sem. Uma pulvinar porttitor dignissim congue pellentesque ac hac.',
      hasBg: false,
    ),
    _ServiceData(
      title: 'Elderly Nutrition',
      icon: Icons.restaurant_menu_outlined,
      body:
          'Lorem ipsum dolor sit amet consectetur. Augue non malesuada placerat faucibus nam purus sem. Uma pulvinar porttitor dignissim congue pellentesque ac hac.',
      hasBg: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _T.bgLight,
      padding: const EdgeInsets.symmetric(
        vertical: _T.sectionV,
        horizontal: _T.sectionH,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _T.maxWidth),
          child: Column(
            children: [
              const Text(
                'Our Services',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  if (isWide) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _ServiceCard(data: _services[0])),
                            const SizedBox(width: 24),
                            Expanded(child: _ServiceCard(data: _services[1])),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: _ServiceCard(data: _services[2])),
                            const SizedBox(width: 24),
                            Expanded(child: _ServiceCard(data: _services[3])),
                          ],
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: _services
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _ServiceCard(data: s),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceData {
  final String title;
  final IconData icon;
  final String body;
  final bool hasBg;
  const _ServiceData({
    required this.title,
    required this.icon,
    required this.body,
    required this.hasBg,
  });
}

class _ServiceCard extends StatelessWidget {
  final _ServiceData data;
  const _ServiceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: data.hasBg ? AppColors.primaryLight : _T.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: data.hasBg ? Colors.transparent : _T.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: _T.white, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            data.title,
            style: const TextStyle(
              color: _T.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.body,
            style: const TextStyle(
              color: _T.textBody,
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 3 — Client Reviews
// ─────────────────────────────────────────────────────────────────────────────

class _ClientReviewsSection extends StatelessWidget {
  const _ClientReviewsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _T.bgReviews,
      padding: const EdgeInsets.symmetric(
        vertical: _T.sectionV,
        horizontal: _T.sectionH,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            children: [
              const Text(
                'Client Reviews',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 48),
              Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Text(
                      '\u201C',
                      style: TextStyle(
                        color: AppColors.primary.withOpacity(0.5),
                        fontSize: 80,
                        height: 0.8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 56,
                    right: 0,
                    child: Text(
                      '\u201D',
                      style: TextStyle(
                        color: AppColors.primary.withOpacity(0.5),
                        fontSize: 80,
                        height: 0.8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Lorem ipsum dolor sit amet consectetur. Amet sed '
                          'tellus elementum mauris. Libero maecenas eget '
                          'tellus morbi diam enim euismod egestas. Adipiscing '
                          'fringilla quis justo adipiscing eget aenean '
                          'sollicitudin. Nibh ut sed sodales magna risus '
                          'tellus. Nulla ut arcu ac justo blandit tincidunt '
                          'ante. Tincidunt libero urna ut aliquet vitae '
                          'nunc quisque sapien cursus.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _T.textBody,
                            fontSize: 14.5,
                            height: 1.75,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Assets.web.client.keyName, width: 50),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  'James Smith',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'ABC Softwares',
                                  style: TextStyle(
                                    color: _T.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _Dot(active: true),
                            const SizedBox(width: 6),
                            _Dot(active: false),
                            const SizedBox(width: 6),
                            _Dot(active: false),
                          ],
                        ),
                      ],
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

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 4 — Best Center
// ─────────────────────────────────────────────────────────────────────────────

class _BestCenterSection extends StatelessWidget {
  const _BestCenterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _T.white,
      padding: const EdgeInsets.symmetric(
        vertical: _T.sectionV,
        horizontal: _T.sectionH,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _T.maxWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: _BestCenterText()),
                    const SizedBox(width: 60),
                    Expanded(flex: 5, child: _BestCenterPhoto()),
                  ],
                );
              }
              return Column(
                children: [
                  _BestCenterText(),
                  const SizedBox(height: 40),
                  _BestCenterPhoto(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BestCenterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'The Best Eldery Care\nCenter For You',
          style: TextStyle(
            color: _T.textDark,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Lorem ipsum dolor sit amet consectetur. Augue non malesuada '
          'placerat faucibus nam purus sem. Uma pulvinar porttitor '
          'dignissim congue pellentesque ac hac. Viverra donec nulla id '
          'enim posuere donec morbi dolor. Eu adipiscing massa ut proin '
          'mauris orci tincidunt ac in.',
          style: TextStyle(color: _T.textBody, fontSize: 14, height: 1.7),
        ),
        const SizedBox(height: 28),
        Container(
          constraints: BoxConstraints(maxWidth: 120),
          child: AppButton.primary(label: 'Booking', onPressed: () {}),
        ),
      ],
    );
  }
}

class _BestCenterPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 400,
        color: const Color(0xFFCFD8DC),
        child: Image.asset(Assets.web.care2.keyName, fit: BoxFit.cover),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 5 — CTA Banner
// ─────────────────────────────────────────────────────────────────────────────

class _CtaBannerSection extends StatelessWidget {
  const _CtaBannerSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _T.bgCta,
      padding: const EdgeInsets.symmetric(
        vertical: 52,
        horizontal: _T.sectionH,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _T.maxWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Looking for a Better Care?',
                          style: TextStyle(
                            color: _T.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Lorem ipsum dolor sit amet consectetur. Augue non '
                          'malesuada placerat faucibus nam purus sem. Uma '
                          'pulvinar porttitor dignissim congue pellentesque ac hac.',
                          style: TextStyle(
                            color: Color(0xCCFFFFFF),
                            fontSize: 13.5,
                            height: 1.65,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          constraints: BoxConstraints(maxWidth: 120),
                          child: AppButton.outline(
                            label: 'Booking',
                            borderColor: AppColors.white,
                            textColor: AppColors.white,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isWide) ...[
                    const SizedBox(width: 48),
                    Column(
                      children: [
                        Image.asset(Assets.web.a247.keyName, width: 80),

                        Image.asset(Assets.web.send.keyName, width: 100),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
