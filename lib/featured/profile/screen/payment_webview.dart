import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatelessWidget {
  final String url;

  const PaymentWebViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.bodyLg("Complete Payment"),
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: WebViewWidget(
        controller:
            WebViewController(
                onPermissionRequest: (request) {
                  request.grant();
                },
              )
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {
                    // Update loading bar.
                  },
                  onPageStarted: (String url) {},
                  onPageFinished: (String url) {},
                  onHttpError: (HttpResponseError error) {},
                  onWebResourceError: (WebResourceError error) {},
                  onNavigationRequest: (NavigationRequest request) {
                    if (request.url.contains('transaction/complete')) {
                      Navigator.of(context).pop();
                      context.showSnackBar("Payment sucessfull");
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
