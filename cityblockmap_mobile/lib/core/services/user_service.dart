import 'dart:convert';
import 'package:cityblockmap_mobile/enviroment.dart';
import 'package:cityblockmap_mobile/core/interceptors/auth_interceptor.dart';
import 'package:cityblockmap_mobile/core/models/user_model.dart';

class UserService {
  final String _apiUrl = '${Environment.apiUrl}/users';

  Future<List<User>> getAll() async {
    final response = await authInterceptor.get(Uri.parse('$_apiUrl/get'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar os usuários.');
    }
  }

  Future<User> getById(int id) async {
    final response = await authInterceptor.get(Uri.parse('$_apiUrl/get/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Usuário não encontrado.');
    }
  }

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

  Future<void> update(int id, UserRequest data) async {
    final response = await authInterceptor.put(
      Uri.parse('$_apiUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar o usuário. (${response.statusCode})');
    }
  }

  Future<void> delete(int id) async {
    final response = await authInterceptor.delete(
      Uri.parse('$_apiUrl/delete/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar o usuário.');
    }
  }
}
