import 'package:cityblockmap_mobile/core/services/auth_service.dart';

class AdminGuard {
  static final AuthService _authService = AuthService();

  /// Rotas que exigem role ADMIN para acesso.
  static const List<String> _adminOnlyRoutes = [
    '/register',
    '/neighborhood-register',
    '/block-register',
    '/users',
    '/user-edit',
  ];

  static Future<String?> redirect(String location) async {
    final isAdminOnlyRoute = _adminOnlyRoutes.any(
      (route) => location == route || location.startsWith('$route/'),
    );

    if (!isAdminOnlyRoute) return null;

    final isAuthenticated = await _authService.isAuthenticated();
    if (!isAuthenticated) return '/login';

    final isAdmin = await _authService.isAdmin();
    if (!isAdmin) return '/blocks';

    return null;
  }
}
