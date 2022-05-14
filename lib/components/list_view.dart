import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../model/pokemon.dart';
import '../network_utils/handle_errors.dart';
import 'card_item.dart';

class ListViewWidget extends StatelessWidget {
  final GlobalKey scaffoldKey;
  final ScrollController controller;
  final bool isFavoriteList;

  const ListViewWidget({required this.scaffoldKey, required this.controller, this.isFavoriteList = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PokemonProvider pk = context.watch<PokemonProvider>();
    return MasonryGridView.count(
      padding: const EdgeInsets.all(10.0),
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      shrinkWrap: true,
      controller: controller,
      itemCount: isFavoriteList ? pk.favoritePokemons.length : pk.pokemons.length,
      itemBuilder: (context, index) =>
          ChangeNotifierProvider.value(
            value: pk,
            child: CardItemWidget(pokemon: isFavoriteList ? pk.favoritePokemons[index] : pk.pokemons[index], scaffoldKey: scaffoldKey),
          ),
    );
  }
}
