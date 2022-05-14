
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/pokemon.dart';
import '../network_utils/api.dart';

class PokemonService {
  final favoriteKey = 'favorites';
  dynamic errorResponse;

  /// Get pokemons from offset and limit
  Future<List<Pokemon>> getPokemons(int offset, int limit) async {
    clearErrorResponse();
    var res = await Network().getData("/pokemon/?offset=$offset&limit=$limit");
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List).map((e) => Pokemon.initFromApiJson(e)).toList();
    } else {
      errorResponse = res;
      return [];
    }
  }

  void clearErrorResponse(){
    errorResponse = null;
  }

  /// Get single pokemon full details
  Future<Pokemon> getPokemon(Pokemon pokemon, bool isFavorite) async{
    clearErrorResponse();
    var res = await Network().getData(pokemon.url);
    if (res.statusCode == 200) {
      Pokemon pk = Pokemon.fromApiJson(jsonDecode(res.body), pokemon.url, isFavorite);
      pk.background = await generatePalette(pk.image);
      return pk;
    } else {
      errorResponse = res;
      return pokemon;
    }
  }

  /// Use the pokemon image to generate a palette background image
  Future<Color> generatePalette(String url) async {
    try {
      Response response = await get(Uri.parse(url));
      if(response.statusCode == 200){
        final PaletteGenerator _generator =
        await PaletteGenerator.fromImageProvider(MemoryImage(response.bodyBytes));
        List<Color> colors = _generator.colors.toList();
        return colors.isNotEmpty ? colors.first : Colors.white;
      }
      errorResponse = response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occured while generating palette in the isolate: $e');
      }
    }
    return Colors.white;
  }

  /// Store favorite pokemons storage
  Future<bool> storeFavorite(List<Pokemon> pokemons) async{
    final prefs = await SharedPreferences.getInstance();
    if (kDebugMode) print(jsonEncode(pokemons));
    return await prefs.setString(favoriteKey, jsonEncode(pokemons));
  }

  /// Fetch favorite pokemons from storage
  Future<List<Pokemon>> retrieveFavoritePokemons() async {
    final prefs = await SharedPreferences.getInstance();
    var favoriteJson = prefs.getString(favoriteKey);
    if (kDebugMode) print(jsonDecode(favoriteJson!)[0]['stats']);
    if(favoriteJson != null){
      return (jsonDecode(favoriteJson) as List).map((e) => Pokemon.fromJson(e)).toList();
    }
    return [];
  }

}