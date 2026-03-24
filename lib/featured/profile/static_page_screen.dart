import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

class StaticPageScreen extends StatelessWidget {
  final String title;
  final StaticPageType type;
  const StaticPageScreen({super.key, required this.title, required this.type});

  static const _privacyContent = '''
When you use our site we collect and store your personal information which is provided by you from time to time. Our primary goal in doing so is to provide you a safe, efficient, smooth and customized experience. This allows us to provide services and features that most likely meet your needs, and to customize our website to make your experience safer and easier. More importantly, while doing so, we collect personal information from you that we consider necessary for achieving this purpose.

Below are some of the ways in which we collect and store your information:
We receive and store any information you enter on our website or give us in any other way. We use the information that you provide for such purposes as responding to your requests, customizing future shopping for you, improving our stores, and communicating with you.

We also store certain types of information whenever you interact with us. For example, like many websites, we use "cookies", and we obtain certain types of information when your web browser accesses Chaldal.com or advertisements and other content served by or on behalf of Chaldal.
''';

  static const _termsContent = '''
1.1   Welcome to Gen sense. Gen sense provides access to the mobile application/app to you, subject to these Terms of Use ("Terms") set out on this page. By using the Website, you, a registered or guest user in terms of the eligibility criteria set out herein ("User") agree to be bound by the Terms. Please read them carefully as your continued usage of the Website, you signify your agreement to be bound by these Terms. If you do not want to be bound by the Terms, you must not subscribe to or use the Website or our services.

1.2   By implicitly or expressly accepting these Terms, you also accept and agree to be bound by Gen sense Policies (including but not limited to Privacy Policy available at https://chaldal.com/l/Privacyinfo) as amended from time to time.

1.3   In these Terms references to "you" and "User" shall mean the end-user customer accessing the Website, its contents, and using the Services offered through the Website. References to the "Website", "Gen sense", "Chaldal.com", "we", "us", and "our" shall mean the Website and/or Gen sense Limited.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        title: AppText.h3(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: 20.paddingAll,
        child: AppText.bodyMd(
          type == StaticPageType.privacy ? _privacyContent : _termsContent,
          color: AppColors.textSecondary,
          height: 1.7,
        ),
      ),
    );
  }
}
