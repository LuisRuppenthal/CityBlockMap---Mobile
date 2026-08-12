import 'package:cityblockmap_mobile/core/services/auth_service.dart';

class AuthGuard {
  static final AuthService _authService = AuthService();

  static const List<String> _publicRoutes = ['/login', '/register'];

  static Future<String?> redirect(String location) async {
    final isAuthenticated = await _authService.isAuthenticated();
    final isPublicRoute = _publicRoutes.contains(location);

    if (!isAuthenticated && !isPublicRoute) {
      return '/login';
    }

    if (isAuthenticated && location == '/login') {
      return '/dashboard';
    }

    return null;
  }
}
