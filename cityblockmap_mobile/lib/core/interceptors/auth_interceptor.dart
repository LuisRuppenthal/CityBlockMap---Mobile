import 'package:http/http.dart' as http;
import 'package:cityblockmap_mobile/core/services/auth_service.dart';

class AuthInterceptor extends http.BaseClient {
  final http.Client _inner = http.Client();
  final AuthService _authService = AuthService();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _authService.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return _inner.send(request);
  }
}

final authInterceptor = AuthInterceptor();
