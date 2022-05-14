//import 'package:run_mobile/model/constants.dart';

import 'package:pokedex/model/pokemon.dart';

class PokemonStat {
  final String name;
  final String url;
  final int stat;

  PokemonStat({this.name = "", this.url = "", this.stat = 0});

  PokemonStat.fromApiJson(Map<String, dynamic> json)
      : name = Pokemon.capitalize(json['stat']['name']),
        url = json['stat']['url'],
        stat = json['base_stat'];

  PokemonStat.fromJson(Map<String, dynamic> json)
      : name = Pokemon.capitalize(json['name']),
        url = json['url'],
        stat = json['stat'];

  Map<String, dynamic> toJson() {
    return{
      'name': name,
      'url': url,
      'stat': stat
    };
  }
}
