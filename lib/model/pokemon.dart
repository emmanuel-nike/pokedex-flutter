//import 'package:run_mobile/model/constants.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/model/pokemon_stat.dart';

class Pokemon {
  final String name;
  final bool loading;
  final String url;
  String id = "";
  String image = "";
  List<String> types = [];
  List<PokemonStat> stats = [];
  int height = 0;
  int weight = 0;
  Color background = Colors.white;
  bool isFavorite = false;

  Pokemon({this.name = "", this.url = "", this.loading = false});

  Pokemon.initFromApiJson(Map<String, dynamic> json)
      : name = Pokemon.capitalize(json['name']),
        url = json['url'],
        loading = true;

  Pokemon.fromApiJson(Map<String, dynamic> json, this.url, this.isFavorite)
      : id = json['id'].toString(),
        name = Pokemon.capitalize(json['name']),
        height = json['height'],
        weight = json['weight'],
        image = json['sprites']['other']?['official-artwork']?['front_default'],
        stats = (json['stats'] as List).map((e) => PokemonStat.fromApiJson(e)).toList(),
        types = (json['types'] as List).map((e) => Pokemon.capitalize(e['type']['name'].toString())).toList(),
        loading = false;

  Pokemon.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        url = json['url'],
        name = Pokemon.capitalize(json['name']),
        height = json['height'],
        weight = json['weight'],
        image = json['image'],
        stats = (json['stats'] as List).map((e) => PokemonStat.fromJson(e)).toList(),
        types = (json['types'] as List).map((e) => Pokemon.capitalize(e.toString())).toList(),
        background = Color(json['background']),
        loading = false,
        isFavorite = true;
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'height': height,
      'weight': weight,
      'image': image,
      'stats': stats.map((e) => e.toJson()).toList(),
      'types': types,
      'background': background.value
    };
  }

  /// Calculate the pokemon BMI
  double getBMI(){
    return weight/(height * height);
  }

  /// Format the pokemon ID
  String getFormattedId(){
    return '#' + id.toString().padLeft(3, '0');
  }

  /// Calculate the pokemon average power as a stat
  PokemonStat averagePower(){
    double avgStat = stats.map((e) => e.stat).reduce((a, b) => a + b) / stats.length;
    return PokemonStat(stat: avgStat.toInt(), name: "Avg. Power");
  }

  /// Attempt to map types to background color (Not used)
  Color getBackgroundColor(){
    if(types.isNotEmpty && types.first == 'Grass'){
      return hexToColor("#F3F9EF");
    }
    if(types.isNotEmpty && types.first == 'Fire'){
      return hexToColor("#FDF1F1");
    }
    if(types.isNotEmpty && types.first == 'Water'){
      return hexToColor("#F3F9FE");
    }
    return Colors.white;
  }

  /// Utility function to capitalize first letter in string
  static String capitalize(String item){
    return item.isNotEmpty ? "${item[0].toUpperCase()}${item.substring(1).toLowerCase()}" : "";
  }

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    return other is Pokemon && other.url == url;
  }

  @override
  String toString() => 'Pokemon(name: $name, url: $url)';
}
