import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';

import 'package:service_provider_umi/shared/widgets/app_text.dart';

class GuestOnboardingScreen extends ConsumerStatefulWidget {
  const GuestOnboardingScreen({super.key});

  @override
  ConsumerState<GuestOnboardingScreen> createState() =>
      _GuestOnboardingScreenState();
}

class _GuestOnboardingScreenState extends ConsumerState<GuestOnboardingScreen> {
  final PageController _controller = PageController();
  final _onboardingIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

  final List<_OnboardingModel> onboardingData = [
    _OnboardingModel(
      image: Assets.guestImages.guestOnboarding1.keyName,
      title: "Find your at-\nhome services",
      description:
          "We offer almost everything cleaning, private\nclasses, beauty...",
    ),
    _OnboardingModel(
      image: Assets.guestImages.guestOnboarding2.keyName,
      title: "Choose your ideal\nprofessional",
      description:
          "Browse through hundreds of professionals\nand pick the one you like most.",
    ),
    _OnboardingModel(
      image: Assets.guestImages.guestOnboarding3.keyName,
      title: "Enjoy your service",
      description:
          "Welcome the professional to the agreed\nplace and time. Thank you for trusting us!",
    ),
  ];

  void nextPage() {
    final currentIndex = ref.read(_onboardingIndexProvider);
    if (currentIndex == onboardingData.length - 1) {
      context.go(AppRoutes.userHome);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    context.go(AppRoutes.userHome);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(_onboardingIndexProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            /// Skip
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: skip, child: AppText("Skip")),
            ),

            /// Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  ref.read(_onboardingIndexProvider.notifier).state = index;
                },
                itemBuilder: (_, index) {
                  final item = onboardingData[index];

                  return Padding(
                    padding: 28.paddingH,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,

                        /// Image
                        Expanded(flex: 5, child: Image.asset(item.image)),

                        20.verticalSpace,

                        /// Title
                        AppText.h1(item.title),

                        10.verticalSpace,

                        /// Description
                        AppText.bodyLg(
                          item.description,
                          color: AppColors.grey500,
                        ),

                        30.verticalSpace,
                        Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: 4.paddingH,
                  width: currentIndex == index ? 14 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.teal
                        : Colors.grey[300],
                    borderRadius: 10.circular,
                  ),
                ),
              ),
            ),

            20.verticalSpace,

            /// Next button
            Padding(
              padding: 20.paddingH,
              child: AppButton.primary(
                label: currentIndex == onboardingData.length - 1
                    ? "Finish"
                    : "Next",
                onPressed: nextPage,
              ),
            ),

            30.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _OnboardingModel {
  final String image;
  final String title;
  final String description;

  _OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}
