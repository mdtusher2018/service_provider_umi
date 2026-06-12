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

class ServiceProviderOnboardingScreen extends ConsumerStatefulWidget {
  const ServiceProviderOnboardingScreen({super.key});

  @override
  ConsumerState<ServiceProviderOnboardingScreen> createState() =>
      _ServiceProviderOnboardingScreenState();
}

class _ServiceProviderOnboardingScreenState
    extends ConsumerState<ServiceProviderOnboardingScreen> {
  final PageController _controller = PageController();

  final List<_OnboardingModel> onboardingData = [
    _OnboardingModel(
      image: Assets.serviceProviderImages.providerOnboarding1.keyName,
      title: "Offer your at-home\nservices",
      description:
          "Let us know where you can travel to, when you’re available, and what services you want to offer.",
    ),
    _OnboardingModel(
      image: Assets.serviceProviderImages.providerOnboarding2.keyName,
      title: "Perform the services",
      description:
          "Complete the service for which you’ve been booked. It’s time to make an impact!",
    ),
    _OnboardingModel(
      image: Assets.serviceProviderImages.providerOnboarding3.keyName,
      title: "Earn money",
      description:
          "Receive the payment for the services you’ve provided in your account. Simple and fast.",
    ),
  ];

  final _onboardingIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

  void nextPage() {
    final currentIndex = ref.read(_onboardingIndexProvider);
    if (currentIndex == onboardingData.length - 1) {
      context.go(AppRoutes.verificationProviderDocument);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
      context.go(AppRoutes.verificationProviderDocument);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(_onboardingIndexProvider);
    return Scaffold(
      backgroundColor: Colors.white,
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
              padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
              child: AppButton(
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
