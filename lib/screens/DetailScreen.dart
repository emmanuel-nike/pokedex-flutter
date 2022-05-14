import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/model/pokemon_stat.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => init(context));
  }

  init(BuildContext context) {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  /// Create pokemon body data reusable widget
  Widget _bodyData(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: ColorConstants.lightTextColor,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorConstants.textColor,
            ),
          )
        ],
      ),
    );
  }

  /// Create reusable stat box
  Widget _statBox(PokemonStat stat) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                stat.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.lightTextColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                stat.stat.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: stat.stat.toDouble() / 100,
            color: getColor(stat.stat.toDouble()),
            backgroundColor: ColorConstants.scrollViewBackgroundColor,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Convert stat value to appropriate color
  Color getColor(double value) {
    if (value > 70) {
      return Colors.green;
    } else if (value > 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    PokemonProvider pk = Provider.of<PokemonProvider>(context);
    bool isFav = pk.activePokemon.isFavorite;
    return Scaffold(
      backgroundColor: ColorConstants.scrollViewBackgroundColor,
      floatingActionButton: Container(
        width: isFav ? 201.0 : 157.0,
        child: FloatingActionButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          child: Text(
            isFav ? "Remove from favourites" : "Mark as favourite",
            style: TextStyle(
                color: isFav ? ColorConstants.appMainBlue : Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
          ),
          backgroundColor: isFav ? ColorConstants.appLightBlue : ColorConstants.appMainBlue,
          onPressed: () {
              if(isFav){
                Provider.of<PokemonProvider>(context, listen: false).removeFavorite(pk.activePokemon);
              }else{
                Provider.of<PokemonProvider>(context, listen: false).addFavorite(pk.activePokemon);
              }
          },
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 200.0,
            leading: InkWell(
              onTap: () => {Navigator.of(context).pop()},
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              //title: Text('SliverAppBar'),
              background: Container(
                color: pk.activePokemon.background.withOpacity(0.3),
                height: 200,
                padding: const EdgeInsets.fromLTRB(30, 90, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pk.activePokemon.name,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              Text(
                                pk.activePokemon.types.join(", "),
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pk.activePokemon.getFormattedId(),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            //alignment: Alignment..centerRight,
                            //fit: StackFit.expand,
                            children: [
                              Positioned(
                                top: 0,
                                right: 0,
                                child: SvgPicture.asset(
                                  'assets/images/detail_svg.svg',
                                  color: pk.activePokemon.background
                                      .withOpacity(0.5),
                                  height: 150,
                                ),
                              ),
                              ClipRect(
                                child: Container(
                                  height: 135,
                                  margin: const EdgeInsets.only(right: 16),
                                  child: OverflowBox(
                                    maxHeight: 150,
                                    child: CachedNetworkImage(
                                      imageUrl: pk.activePokemon.image,
                                      alignment: Alignment.bottomLeft,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  _bodyData("Height", pk.activePokemon.height.toString()),
                  _bodyData("Weight", pk.activePokemon.weight.toString()),
                  _bodyData("BMI", pk.activePokemon.getBMI().toStringAsFixed(2))
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Text(
                      'Base stats',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 1),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _statBox(pk.activePokemon.stats[index]);
              },
              childCount: pk.activePokemon.stats.length,
            ),
          ),
          SliverToBoxAdapter(
            child: _statBox(pk.activePokemon.averagePower()),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }
}
