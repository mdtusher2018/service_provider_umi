import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<_OnboardingModel> onboardingData = [
    _OnboardingModel(
      image: "assets/guest_images/guest_onboarding_1.png",
      title: "Find your at-\nhome services",
      description:
          "We offer almost everything cleaning, private\nclasses, beauty...",
    ),
    _OnboardingModel(
      image: "assets/guest_images/guest_onboarding_2.png",
      title: "Choose your ideal\nprofessional",
      description:
          "Browse through hundreds of professionals\nand pick the one you like most.",
    ),
    _OnboardingModel(
      image: "assets/guest_images/guest_onboarding_3.png",
      title: "Enjoy your service",
      description:
          "Welcome the professional to the agreed\nplace and time. Thank you for trusting us!",
    ),
  ];

  void nextPage() {
    if (currentIndex == onboardingData.length - 1) {
      // Navigate to login/home
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    // Navigate to login/home
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    currentIndex == onboardingData.length - 1
                        ? "Finish"
                        : "Next",
                  ),
                ),
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
