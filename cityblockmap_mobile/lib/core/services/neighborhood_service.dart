import 'dart:convert';
import 'package:cityblockmap_mobile/enviroment.dart';
import 'package:cityblockmap_mobile/core/interceptors/auth_interceptor.dart';
import 'package:cityblockmap_mobile/core/models/neighborhood_model.dart';

class NeighborhoodService {
  final String _apiUrl = '${Environment.apiUrl}/neighborhoods';

  Future<List<Neighborhood>> getAll() async {
    final response = await authInterceptor.get(Uri.parse('$_apiUrl/get'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Neighborhood.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar os bairros.');
    }
  }

  Future<Neighborhood> getById(int id) async {
    final response = await authInterceptor.get(Uri.parse('$_apiUrl/get/$id'));

    if (response.statusCode == 200) {
      return Neighborhood.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Bairro não encontrado.');
    }
  }

  Future<Neighborhood> create(NeighborhoodRequest data) async {
    final response = await authInterceptor.post(
      Uri.parse('$_apiUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 201) {
      return Neighborhood.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar o bairro.');
    }
  }

  Future<Neighborhood> update(int id, NeighborhoodRequest data) async {
    final response = await authInterceptor.put(
      Uri.parse('$_apiUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return Neighborhood.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar o bairro.');
    }
  }

  Future<void> delete(int id) async {
    final response = await authInterceptor.delete(
      Uri.parse('$_apiUrl/delete/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar o bairro.');
    }
  }
}
