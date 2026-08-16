import 'dart:convert';
import 'package:cityblockmap_mobile/enviroment.dart';
import 'package:cityblockmap_mobile/core/interceptors/auth_interceptor.dart';
import 'package:cityblockmap_mobile/core/models/block_model.dart';

class BlockService {
  final String _apiUrl = '${Environment.apiUrl}/blocks';

  Future<List<Block>> getAll() async {
    final response = await authInterceptor.get(Uri.parse('$_apiUrl/get'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Block.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar as quadras.');
    }
  }

  Future<Block> getById(int id) async {
    final response = await authInterceptor.get(Uri.parse('$_apiUrl/get/$id'));

    if (response.statusCode == 200) {
      return Block.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Quadra não encontrada.');
    }
  }

  Future<Block> create(BlockRequest data) async {
    final response = await authInterceptor.post(
      Uri.parse('$_apiUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 201) {
      return Block.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar a quadra. (${response.statusCode})');
    }
  }

  Future<Block> update(int id, BlockRequest data) async {
    final response = await authInterceptor.put(
      Uri.parse('$_apiUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return Block.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar a quadra. (${response.statusCode})');
    }
  }

  Future<void> delete(int id) async {
    final response = await authInterceptor.delete(
      Uri.parse('$_apiUrl/delete/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar a quadra.');
    }
  }
}
