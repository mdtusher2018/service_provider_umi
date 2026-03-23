import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import '../app_routes.dart';

class RoleGuard {
  static String? redirect(AppRole activeRole, GoRouterState state) {
    final location = state.uri.toString();
    final isUserRoute = location.startsWith('/user');
    final isProviderRoute = location.startsWith('/provider');

    if (activeRole == AppRole.user && isProviderRoute) {
      return AppRoutes.userHome;
    }

    if (activeRole == AppRole.provider && isUserRoute) {
      return AppRoutes.providerDashboard;
    }

    return null;
  }
}
