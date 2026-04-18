part of 'user_home_screen.dart';

class RadialMenu extends StatefulWidget {
  const RadialMenu({super.key, required this.menuItems});
  final List<ServiceModel> menuItems;

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
    double radiusSize = 50.0;
    double radius = context.screenWidth * 0.32;
    double center = context.screenWidth / 2;
    int itemCount = min(widget.menuItems.length, 6);

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
                  left:
                      center + (x * scaleAnimation.value) - (radiusSize * 0.8),
                  top: center + (y * scaleAnimation.value) - (radiusSize * 0.8),
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

          /// CENTER BUTTON (PULSE)
          Positioned(
            left: center - radiusSize,
            top: center - radiusSize,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final pulse = 1 + (sin(_controller.value * 2 * pi) * 0.2);
                return Transform.scale(scale: pulse, child: child);
              },
              child: ElevatedButton(
                onPressed: () => showCustomDialog(context),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: 24.paddingAll,
                  backgroundColor: AppColors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/icons/support.png", width: radiusSize),
                    AppText.h4('Support', color: AppColors.secondary),
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
                Image.asset("assets/support.png", width: 120),
                16.verticalSpace,

                16.verticalSpace,
                AppButton.primary(
                  label: 'Call',
                  prefixIcon: Icon(Icons.call, color: AppColors.white),
                  onPressed: () {
                    // Call action
                    context.pop();
                    print("Call pressed");
                  },
                ),
                8.verticalSpace,
                AppButton.primary(
                  label: 'Message',
                  prefixIcon: Icon(Icons.message, color: AppColors.white),
                  onPressed: () {
                    // Message action
                    context.pop();
                    print("Message pressed");
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

class _RadialMenuItem extends StatefulWidget {
  final ServiceModel item;
  final double size;

  const _RadialMenuItem({required this.item, required this.size});

  @override
  State<_RadialMenuItem> createState() => _RadialMenuItemState();
}

class _RadialMenuItemState extends State<_RadialMenuItem> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.9),
      onTapUp: (_) => setState(() => scale = 1.0),
      onTapCancel: () => setState(() => scale = 1.0),
      onTap: () {
        if (widget.item.haveSubcategory) {
          context.push(
            AppRoutes.serviceSubCategory,
            extra: {
              "serviceName": widget.item.name,
              "serviceId": widget.item.id,
            },
          );
        } else {
          context.push(AppRoutes.bookingTime);
        }
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: widget.size * 2,
          height: widget.size * 2,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.item.image ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AppText.bodySm(widget.item.name),
            ],
          ),
        ),
      ),
    );
  }
}
