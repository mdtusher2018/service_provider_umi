import 'package:go_router/go_router.dart';

import '../app_routes.dart';
import '../../../shared/enums/user_role.dart';

class RoleGuard {
  static String? redirect(UserRole activeRole, GoRouterState state) {
    final location = state.uri.toString();
    final isUserRoute = location.startsWith('/user');
    final isProviderRoute = location.startsWith('/provider');

    if (activeRole == UserRole.user && isProviderRoute) {
      return AppRoutes.userHome;
    }

    if (activeRole == UserRole.serviceProvider && isUserRoute) {
      return AppRoutes.providerDashboard;
    }

    return null;
  }
}
