class NeighborhoodRef {
  final int id;
  final String? name;

  NeighborhoodRef({required this.id, this.name});

  factory NeighborhoodRef.fromJson(Map<String, dynamic> json) {
    return NeighborhoodRef(id: json['id'], name: json['name'] as String?);
  }
}

class Block {
  final int id;
  final String number;
  final double latitude;
  final double longitude;
  final NeighborhoodRef? neighborhood;

  Block({
    required this.id,
    required this.number,
    required this.latitude,
    required this.longitude,
    this.neighborhood,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'],
      number: json['number'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      neighborhood: json['neighborhood'] != null
          ? NeighborhoodRef.fromJson(json['neighborhood'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'latitude': latitude,
    'longitude': longitude,
  };
}

class BlockRequest {
  final String number;
  final double latitude;
  final double longitude;
  final int neighborhoodId;

  BlockRequest({
    required this.number,
    required this.latitude,
    required this.longitude,
    required this.neighborhoodId,
  });

  Map<String, dynamic> toJson() => {
    'number': number,
    'latitude': latitude,
    'longitude': longitude,
    'neighborhood': {'id': neighborhoodId},
  };
}
