import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class IconCounterWidget extends StatelessWidget {
  const IconCounterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = Provider.of<PokemonProvider>(context).favoritePokemons.length;

    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorConstants.indicatorColor),
      child: Center(
        child: Text(
          "$count",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
