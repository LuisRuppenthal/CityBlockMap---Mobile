import 'package:cityblockmap_mobile/core/models/block_model.dart';

class Neighborhood {
  final int id;
  final String name;
  final List<Block> blocks;

  Neighborhood({required this.id, required this.name, this.blocks = const []});

  factory Neighborhood.fromJson(Map<String, dynamic> json) {
    return Neighborhood(
      id: json['id'],
      name: json['name'],
      blocks: json['blocks'] != null
          ? (json['blocks'] as List).map((b) => Block.fromJson(b)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class NeighborhoodRequest {
  final String name;

  NeighborhoodRequest({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}
