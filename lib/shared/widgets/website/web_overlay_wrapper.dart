// in overlay_provider.dart — add a key alongside the notifier
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/utils/animations.dart';

final overlayDismissKey = GlobalKey<_WebOverlayWrapperState>();

// web_overlay.dart
void showWebOverlay(WidgetRef ref, Widget content) {
  ref
      .read(overlayProvider.notifier)
      .show(
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: content,
            ),
          ),
        ),
      );
}

Future<void> dismissWebOverlay(WidgetRef ref) async {
  await overlayDismissKey.currentState?._dismiss();
  await Future.delayed(const Duration(milliseconds: 50));
}

// shared/widgets/website/web_overlay_wrapper.dart
class WebOverlayWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismiss;

  const WebOverlayWrapper({
    required this.child,
    required this.onDismiss,
    super.key,
  });

  @override
  State<WebOverlayWrapper> createState() => _WebOverlayWrapperState();
}

class _WebOverlayWrapperState extends State<WebOverlayWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          dialogSlidingFadeTransitionDuration, // 👈 your existing constant
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08), // 👈 slides up from slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(); // 👈 play on appear
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _controller.reverse(); // 👈 play reverse on dismiss
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _dismiss, // tap barrier → animate out
        child: FadeTransition(
          opacity: _fade,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // block tap-through
                child: SlideTransition(
                  position: _slide,
                  child: FadeTransition(opacity: _fade, child: widget.child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
