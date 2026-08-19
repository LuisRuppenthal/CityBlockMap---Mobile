import 'dart:convert';
import 'package:cityblockmap_mobile/enviroment.dart';
import 'package:cityblockmap_mobile/core/interceptors/auth_interceptor.dart';
import 'package:cityblockmap_mobile/core/models/user_model.dart';

class UserService {
  final String _apiUrl = '${Environment.apiUrl}/users';

  Future<void> create(UserRequest data) async {
    final response = await authInterceptor.post(
      Uri.parse('$_apiUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar o usuário. (${response.statusCode})');
    }
  }
}
