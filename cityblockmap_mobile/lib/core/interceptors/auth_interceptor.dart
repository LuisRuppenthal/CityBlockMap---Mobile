import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:cityblockmap_mobile/core/services/auth_service.dart';
import 'package:cityblockmap_mobile/core/services/session_expired_service.dart';
import 'package:cityblockmap_mobile/core/navigation/navigator_key.dart';

class AuthInterceptor extends http.BaseClient {
  final http.Client _inner = http.Client();
  final AuthService _authService = AuthService();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _authService.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401) {
      _handleSessionExpired();
    }

    return response;
  }

  Future<void> _handleSessionExpired() async {
    // Evita disparar múltiplas caso chegue ao ponto das requisições falharem juntas.
    if (SessionExpiredService.instance.visible) return;

    SessionExpiredService.instance.show();
    await _authService.logout();

    await Future.delayed(const Duration(milliseconds: 2000));

    SessionExpiredService.instance.hide();

    final context = rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      GoRouter.of(context).go('/login');
    }
  }
}

final authInterceptor = AuthInterceptor();
