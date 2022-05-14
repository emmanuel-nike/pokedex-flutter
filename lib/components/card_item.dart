import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../model/pokemon.dart';
import '../network_utils/handle_errors.dart';

class CardItemWidget extends StatelessWidget {
  final Pokemon pokemon;
  final GlobalKey scaffoldKey;

  const CardItemWidget({required this.pokemon, required this.scaffoldKey, Key? key}) : super(key: key);

//   @override
//   CardItemWidgetState createState() => CardItemWidgetState();
// }
//
// class CardItemWidgetState extends State<CardItemWidget> {
//   Pokemon pokemon = Pokemon();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((_) => init(context));
//     pokemon = widget.data;
//   }
//
//   init(BuildContext context) async {
//     if (pokemon.loading) {
//       Provider.of<PokemonProvider>(context, listen: false)
//           .getPokemonDetail(pokemon);
//     }
//     print(pokemon.image);
//     print(pokemon.url);
//   }
//
//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }

  @override
  Widget build(BuildContext context) {
    final pk = Provider.of<PokemonProvider>(context);
    if (pokemon.loading) {
      pk.getPokemonDetail(pokemon).then((value) {
        if(!value){
          handleErrors(scaffoldKey, pk.errorResponse);
        }
      });
    }
    return Card(
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          if(!pokemon.loading){
            pk.setActivePokemon(pokemon);
            Navigator.of(context).pushNamed('/detail');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 104,
              color: pokemon.background.withOpacity(0.3),
              child: pokemon.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      ),
                      height: 104,
                      width: 104,
                      imageUrl: pokemon.image,
                    ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  pokemon.getFormattedId(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: ColorConstants.lightTextColor,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    pokemon.name,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    pokemon.types.join(", "),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: ColorConstants.lightTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
