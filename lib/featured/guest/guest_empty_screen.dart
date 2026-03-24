import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';

import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

class GuestServicesScreen extends StatelessWidget {
  const GuestServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GuestEmptyScreen(
      title: "Services",
      description: "Your booked services will appear here",
      image: "assets/guest_images/guest_service.png",
    );
  }
}

class GuestFavouritesScreen extends StatelessWidget {
  const GuestFavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GuestEmptyScreen(
      title: "Favourites",
      description: "Your favourite professionals will appear here",
      image: "assets/guest_images/guest_favorite.png",
    );
  }
}

class GuestInboxScreen extends StatelessWidget {
  const GuestInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              /// Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Row(children: [AppText.h2("Inbox")]),
              ),

              /// Tabs
              TabBar(
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(text: "Chat"),
                  Tab(text: "Alerts"),
                ],
              ),

              /// Tab content
              const Expanded(
                child: TabBarView(
                  children: [_ChatGuestTab(), _AlertsGuestTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GuestProfileScreen extends StatelessWidget {
  const GuestProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GuestEmptyScreen(
      title: "Profile",
      description:
          "Please create an account first to access and enjoy all the services.",
      image: "assets/guest_images/guest_profile.png",
    );
  }
}

class _ChatGuestTab extends StatelessWidget {
  const _ChatGuestTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 20.paddingH,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.h3("No messages", color: AppColors.textSecondary),

                  20.verticalSpace,

                  Image.asset(
                    "assets/guest_images/guest_chat.png",
                    height: 180,
                  ),

                  20.verticalSpace,

                  AppText.bodyMd(
                    "You don’t have messages from professionals yet",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          30.verticalSpace,

          AppButton.outline(
            label: "LOGIN",
            onPressed: () {
              context.go(AppRoutes.login);
            },
          ),

          12.verticalSpace,

          AppButton.primary(
            label: "Create Account",
            onPressed: () {
              context.go(AppRoutes.login);
            },
          ),

          80.verticalSpace,
        ],
      ),
    );
  }
}

class _AlertsGuestTab extends StatelessWidget {
  const _AlertsGuestTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 20.paddingH,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.h3("No Notification", color: AppColors.textSecondary),

                  20.verticalSpace,

                  Image.asset(
                    "assets/guest_images/guest_alerts.png",
                    height: 180,
                  ),
                  20.verticalSpace,

                  AppText.bodyMd(
                    "You don’t have messages from professionals yet",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          30.verticalSpace,

          AppButton.outline(label: "LOGIN", onPressed: () {}),

          12.verticalSpace,

          AppButton.primary(label: "Create Account", onPressed: () {}),

          80.verticalSpace,
        ],
      ),
    );
  }
}

class _GuestEmptyScreen extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const _GuestEmptyScreen({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: 20.paddingH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,

              /// Title
              AppText.h2(title),

              6.verticalSpace,

              /// Description
              AppText.bodyMd(description, color: AppColors.textSecondary),

              40.verticalSpace,

              /// Illustration
              Expanded(child: Center(child: Image.asset(image, height: 250))),

              /// Login Button
              AppButton.outline(label: "LOGIN", onPressed: () {}),

              12.verticalSpace,

              /// Create account
              AppButton.primary(label: "Create Account", onPressed: () {}),

              80.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
