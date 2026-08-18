part of 'user_home_screen.dart';

class RadialMenu extends StatefulWidget {
  const RadialMenu({super.key, required this.menuItems});
  final List<CategoryModel> menuItems;

  @override
  State<RadialMenu> createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.menuItems.length;
    double radiusSize = itemCount > 6 ? 44.0 : 50.0;
    // Use 0.35 instead of 0.38 so it leaves margin and doesn't cross the screen edge
    double radius = context.screenWidth * (itemCount > 6 ? 0.35 : 0.32);
    double center = context.screenWidth / 2;

    return SizedBox(
      width: context.screenWidth,
      height: context.screenWidth,
      child: Stack(
        children: [
          ...List.generate(itemCount, (index) {
            final angle = (2 * pi / itemCount) * index;
            final x = radius * cos(angle);
            final y = radius * sin(angle);

            /// Separate animations (IMPORTANT FIX)
            final scaleAnimation = CurvedAnimation(
              parent: _controller,
              curve: Interval(
                (index / itemCount),
                1,
                curve: Curves.easeOutBack,
              ),
            );

            final fadeAnimation = CurvedAnimation(
              parent: _controller,
              curve: Interval((index / itemCount), 1.0, curve: Curves.easeIn),
            );

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  left: center + (x * scaleAnimation.value) - radiusSize,
                  top: center + (y * scaleAnimation.value) - radiusSize,
                  child: Opacity(
                    opacity: fadeAnimation.value, // SAFE now
                    child: Transform.translate(
                      offset: Offset(0, sin(_controller.value * 2 * pi) * 2),
                      child: Transform.scale(
                        scale: scaleAnimation.value,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: _RadialMenuItem(
                item: widget.menuItems[index],
                size: radiusSize,
              ),
            );
          }),

          Align(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final pulse = 1 + (sin(_controller.value * 2 * pi) * 0.2);
                return Transform.scale(scale: pulse, child: child);
              },
              child: SizedBox(
                width: radiusSize * 2.5,
                height: radiusSize * 2.5,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    InkWell(
                      onTap: () => showCustomDialog(context),
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: radiusSize * 2.5,
                        height: radiusSize * 2.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: Center(
                          child: Image.asset(
                            Assets.icons.support.keyName,
                            width: radiusSize * 1.2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -28,
                      child: AppText.h4(
                        AppLocalizations.of(context)!.support,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (context, _, _) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: 10.circular),
          child: Padding(
            padding: 16.paddingAll,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentGeometry.topRight,
                  child: InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Icon(Icons.close),
                  ),
                ),
                Image.asset(Assets.support.keyName, width: 120),
                16.verticalSpace,

                16.verticalSpace,
                AppButton.primary(
                  label: AppLocalizations.of(context)!.call,
                  prefixIcon: Icon(Icons.call, color: AppColors.white),
                  onPressed: () async {
                    const phoneNumber = "017XXXXXXXX"; // your number

                    await Clipboard.setData(ClipboardData(text: phoneNumber));
                    context.pop();
                    context.showSnackBar(AppLocalizations.of(context)!.phoneNumberCopied);

                    print("Call pressed");
                  },
                ),
                8.verticalSpace,
                AppButton.primary(
                  label: AppLocalizations.of(context)!.message,
                  prefixIcon: Icon(Icons.message, color: AppColors.white),
                  onPressed: () {
                    context.pop();
                    if (kIsWeb) {
                      context.go(AppRoutes.supportMessage);
                    } else {
                      context.push(AppRoutes.supportMessage);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RadialMenuItem extends ConsumerStatefulWidget {
  final CategoryModel item;
  final double size;

  const _RadialMenuItem({required this.item, required this.size});

  @override
  ConsumerState<_RadialMenuItem> createState() => _RadialMenuItemState();
}

class _RadialMenuItemState extends ConsumerState<_RadialMenuItem> {
  double scale = 1.0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.9),
      onTapUp: (_) => setState(() => scale = 1.0),
      onTapCancel: () => setState(() => scale = 1.0),
      onTap: isLoading ? null : () async {
        if (ref.read(appRoleProvider) == AppRole.guest) {
          _showGuestAuthSheet(context);
          return;
        }

        setState(() => isLoading = true);
        try {
          final subcategories = await ref.read(subcategoriesProvider(widget.item.id).future);
          if (!mounted) return;
          
          if (subcategories.isNotEmpty) {
            if (kIsWeb) {
              context.go(AppRoutes.searchSubcategoryPath(widget.item.id));
            } else {
              context.push(AppRoutes.searchSubcategoryPath(widget.item.id));
            }
          } else {
            if (kIsWeb) {
              context.go(AppRoutes.searchTimePath(widget.item.id));
            } else {
              context.push(AppRoutes.searchTimePath(widget.item.id));
            }
          }
        } finally {
          if (mounted) setState(() => isLoading = false);
        }
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        child: SizedBox(
          width: widget.size * 2,
          height: widget.size * 2,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.size * 2,
                height: widget.size * 2,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  border: Border.all(color: AppColors.grey200, width: 1),
                ),
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Center(
                        child: Image.network(
                          widget.item.image ?? "",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, color: AppColors.grey500, size: 24),
                        ),
                      ),
              ),
              Positioned(
                bottom: -24,
                child: AppText.bodySm(
                  widget.item.name,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGuestAuthSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton.primary(
                label: AppLocalizations.of(context)!.login.toUpperCase(),
                textColor: AppColors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.login);
                },
              ),
              12.verticalSpace,
              AppButton.outline(
                label: AppLocalizations.of(context)!.createAccountBtn,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.login);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
