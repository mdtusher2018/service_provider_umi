import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

class ServiceProviderOnboardingScreen extends StatefulWidget {
  const ServiceProviderOnboardingScreen({super.key});

  @override
  State<ServiceProviderOnboardingScreen> createState() =>
      _ServiceProviderOnboardingScreenState();
}

class _ServiceProviderOnboardingScreenState
    extends State<ServiceProviderOnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<_OnboardingModel> onboardingData = [
    _OnboardingModel(
      image: "assets/service_provider_images/provider_onboarding_1.png",
      title: "Offer your at-home\nservices",
      description:
          "Let us know where you can travel to, when you’re available, and what services you want to offer.",
    ),
    _OnboardingModel(
      image: "assets/service_provider_images/provider_onboarding_2.png",
      title: "Perform the services",
      description:
          "Complete the service for which you’ve been booked. It’s time to make an impact!",
    ),
    _OnboardingModel(
      image: "assets/service_provider_images/provider_onboarding_3.png",
      title: "Earn money",
      description:
          "Receive the payment for the services you’ve provided in your account. Simple and fast.",
    ),
  ];

  void nextPage() {
    if (currentIndex == onboardingData.length - 1) {
      // Navigate to the main screen for service providers (e.g., dashboard, login)
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    // Navigate directly to the main screen (e.g., dashboard, login)
  }

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, index) {
                  final item = onboardingData[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        /// Image
                        Expanded(flex: 5, child: Image.asset(item.image)),

                        const SizedBox(height: 20),

                        /// Title
                        AppText.h1(item.title),

                        const SizedBox(height: 10),

                        /// Description
                        AppText.bodyLg(
                          item.description,
                          color: AppColors.grey500,
                        ),

                        const SizedBox(height: 30),
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
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 14 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.teal
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

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

            const SizedBox(height: 30),
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
