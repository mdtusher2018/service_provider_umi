import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

class NotFoundScreen extends ConsumerWidget {
  final String? error;

  const NotFoundScreen({super.key, this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: 24.paddingAll,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: 24.circular),
                child: Padding(
                  padding: 32.paddingAll,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Icon
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: AppColors.primaryFor(
                            ref.read(appRoleProvider),
                          ).withOpacity(.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.search_off_rounded,
                          size: 60,
                          color: AppColors.primaryFor(
                            ref.read(appRoleProvider),
                          ),
                        ),
                      ),

                      32.verticalSpace,

                      /// 404
                      AppText.h1(
                        "404",

                        fontSize: 64,

                        color: AppColors.primaryFor(ref.read(appRoleProvider)),
                      ),

                      12.verticalSpace,

                      /// Title
                      AppText.h1(
                        "Page Not Found",
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),

                      16.verticalSpace,

                      /// Description
                      AppText(
                        "The page you are looking for doesn't exist or may have been moved.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      /// Button
                      AppButton.primary(
                        label: "Back to Home",
                        onPressed: () {
                          context.go(AppRoutes.login);
                        },
                      ),

                      /// Optional debug message
                      if (error != null && kDebugMode) ...[
                        24.verticalSpace,
                        AppText.bodyMd(error!, textAlign: TextAlign.center),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
