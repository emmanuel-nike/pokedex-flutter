
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/services/pokemon_service.dart';
import '../model/pokemon.dart';

class PokemonProvider with ChangeNotifier {
  final PokemonService _pokemonService;

  List<Pokemon> _pokemons = [];
  List<Pokemon> get pokemons => _pokemons;

  List<Pokemon> _favoritePokemons = [];
  List<Pokemon> get favoritePokemons => _favoritePokemons;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Pokemon _activePokemon = Pokemon();
  Pokemon get activePokemon => _activePokemon;

  dynamic get errorResponse => _pokemonService.errorResponse;

  PokemonProvider(this._pokemonService);

  /// Get all pokemons from particular page and certain limit
  Future<void> getFavoritePokemons() async{
    _favoritePokemons = await _pokemonService.retrieveFavoritePokemons();
    notifyListeners();
  }

  /// Get all pokemons from particular page and certain limit
  Future<bool> getPokemons({int page = 1, int limit = 12}) async{
    int offset = 20 * (page - 1);
    _setLoading(true);
    _pokemons.addAll(await _pokemonService.getPokemons(offset, limit));
    _setLoading(false);
    return _pokemonService.errorResponse == null;
  }

  /// Toggle loading for when pokemons are being fetched
  void _setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  /// Fetch the details of the pokemon
  Future<bool> getPokemonDetail(Pokemon pokemon) async{
      bool isFavorite = _favoritePokemons.where((e) => e.url == pokemon.url).isNotEmpty;
      Pokemon pk = await _pokemonService.getPokemon(pokemon, isFavorite);
      int index = _pokemons.indexWhere((element) => element.url == pokemon.url);
      if(index > -1 && !pk.loading){
        _pokemons[index] = pk;
        notifyListeners();
        return true;
      }
      return false;
  }

  /// Set the active pokemon for detail page
  void setActivePokemon(Pokemon pokemon){
    _activePokemon = pokemon;
    notifyListeners();
  }

  /// Add to favorites
  Future<void> addFavorite(Pokemon pokemon) async{
    if(_favoritePokemons.where((e) => e.url == pokemon.url).isNotEmpty) return;
    // Update pokemon on main list
    int index = _pokemons.indexWhere((e) => e.url == pokemon.url);
    if(index != -1){
      _pokemons[index].isFavorite = true;
    }
    //Add pokemon to favorite pokemons
    _favoritePokemons.add(pokemon);
    _favoritePokemons[_favoritePokemons.length -1].isFavorite = true;

    //Store in shared preferences
    _pokemonService.storeFavorite(_favoritePokemons);

    //Update activePokemon
    if(_activePokemon.url == pokemon.url){
      _activePokemon.isFavorite = true;
    }

    notifyListeners();
  }

  /// Remove from favorites
  Future<void> removeFavorite(Pokemon pokemon) async{
    int favIndex = _favoritePokemons.indexWhere((e) => e.url == pokemon.url);
    if(favIndex < 0) return;
    // Update pokemon on main list
    int index = _pokemons.indexWhere((e) => e.url == pokemon.url);
    if(index != -1){
      _pokemons[index].isFavorite = false;
    }
    //Remove pokemon from favorite list
    _favoritePokemons.removeAt(favIndex);

    //Store in shared preferences
    _pokemonService.storeFavorite(_favoritePokemons);

    //Update activePokemon
    if(_activePokemon.url == pokemon.url){
      _activePokemon.isFavorite = false;
    }

    notifyListeners();
  }
}
