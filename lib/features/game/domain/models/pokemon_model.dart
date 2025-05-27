import 'package:flutter/material.dart';

class PokemonModel {
  final int id;
  final String name;
  final String imageUrl;
  final List<PokemonType> types;
  final Map<String, int> stats;
  final int baseExperience;

  PokemonModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.stats,
    required this.baseExperience,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] as String,
      types: (json['types'] as List)
          .map((type) => typeToEnum(type['type']['name']))
          .toList(),
      stats: Map.fromEntries(
        (json['stats'] as List).map(
              (stat) =>
              MapEntry(
                stat['stat']['name'] as String,
                stat['base_stat'] as int,
              ),
        ),
      ),
      baseExperience: json['base_experience'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'types': types.map((type) => type.name.toLowerCase()
    ).toList(),
    'stats': stats,
    'baseExperience': baseExperience,
    };
    }

PokemonModel copyWith({
  int? id,
  String? name,
  String? imageUrl,
  List<PokemonType>? types,
  Map<String, int>? stats,
  int? baseExperience,
}) {
  return PokemonModel(
    id: id ?? this.id,
    name: name ?? this.name,
    imageUrl: imageUrl ?? this.imageUrl,
    types: types ?? List.from(this.types),
    stats: stats ?? Map.from(this.stats),
    baseExperience: baseExperience ?? this.baseExperience,
  );
}

}

enum PokemonType {
  normal,
  fire,
  water,
  electric,
  grass,
  ice,
  fighting,
  poison,
  ground,
  flying,
  psychic,
  bug,
  rock,
  ghost,
  dragon,
  dark,
  steel,
  fairy
}

PokemonType typeToEnum(String type) {
  switch (type.toLowerCase()) {
    case 'normal':
      return PokemonType.normal;
    case 'fire':
      return PokemonType.fire;
    case 'water':
      return PokemonType.water;
    case 'electric':
      return PokemonType.electric;
    case 'grass':
      return PokemonType.grass;
    case 'ice':
      return PokemonType.ice;
    case 'fighting':
      return PokemonType.fighting;
    case 'poison':
      return PokemonType.poison;
    case 'ground':
      return PokemonType.ground;
    case 'flying':
      return PokemonType.flying;
    case 'psychic':
      return PokemonType.psychic;
    case 'bug':
      return PokemonType.bug;
    case 'rock':
      return PokemonType.rock;
    case 'ghost':
      return PokemonType.ghost;
    case 'dragon':
      return PokemonType.dragon;
    case 'dark':
      return PokemonType.dark;
    case 'steel':
      return PokemonType.steel;
    case 'fairy':
      return PokemonType.fairy;
    default:
      return PokemonType.normal;
  }
}

extension PokemonTypeToColorExtension on PokemonType {
  Color get color {
    switch (this) {
      case PokemonType.normal:
        return Colors.grey;
      case PokemonType.fire:
        return Colors.orange;
      case PokemonType.water:
        return Colors.blue;
      case PokemonType.electric:
        return Colors.yellow;
      case PokemonType.grass:
        return Colors.green;
      case PokemonType.ice:
        return Colors.lightBlue;
      case PokemonType.fighting:
        return Colors.red;
      case PokemonType.poison:
        return Colors.purple;
      case PokemonType.ground:
        return Colors.brown;
      case PokemonType.flying:
        return Colors.lightBlue;
      case PokemonType.psychic:
        return Colors.pink;
      case PokemonType.bug:
        return Colors.lightGreen;
      case PokemonType.rock:
        return Colors.brown;
      case PokemonType.ghost:
        return Colors.deepPurple;
      case PokemonType.dragon:
        return Colors.indigo;
      case PokemonType.dark:
        return Colors.black87;
      case PokemonType.steel:
        return Colors.blueGrey;
      case PokemonType.fairy:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  String get name {
    switch (this) {
      case PokemonType.normal:
        return 'Normal';
      case PokemonType.fire:
        return 'Fire';
      case PokemonType.water:
        return 'Water';
      case PokemonType.electric:
        return 'Electric';
      case PokemonType.grass:
        return 'Grass';
      case PokemonType.ice:
        return 'Ice';
      case PokemonType.fighting:
        return 'Fighting';
      case PokemonType.poison:
        return 'Poison';
      case PokemonType.ground:
        return 'Ground';
      case PokemonType.flying:
        return 'Flying';
      case PokemonType.psychic:
        return 'Psychic';
      case PokemonType.bug:
        return 'Bug';
      case PokemonType.rock:
        return 'Rock';
      case PokemonType.ghost:
        return 'Ghost';
      case PokemonType.dragon:
        return 'Dragon';
      case PokemonType.dark:
        return 'Dark';
      case PokemonType.steel:
        return 'Steel';
      case PokemonType.fairy:
        return 'Fairy';
    }
  }
}