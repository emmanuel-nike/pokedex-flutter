import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pokedex/components/card_item.dart';
import 'package:pokedex/components/icon_counter.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/network_utils/handle_errors.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

import '../components/list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    WidgetsBinding.instance?.addPostFrameCallback((_) => init(context));
  }

  init(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context, listen: false);
    provider.getFavoritePokemons().then((value) {
      provider.getPokemons(page: page).then((value) {
        if(!value){
          handleErrors(_scaffoldKey, provider.errorResponse);
        }
      });
    });

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          page++;
          provider.getPokemons(page: page);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    PokemonProvider pk = context.watch<PokemonProvider>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          bottom: TabBar(
            indicatorColor: ColorConstants.indicatorColor,
            unselectedLabelColor: ColorConstants.unselectedTextColor,
            labelColor: ColorConstants.selectedTextColor,
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            tabs: [
              const Tab(text: "All Pokemons"),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Favorites"),
                    SizedBox(width: 5,),
                    IconCounterWidget(),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          title: Card(
            elevation: 1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ic_launcher.png',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Pokedex",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  //Color(0x161A33)
                ],
              ),
            ),
          ),
          titleSpacing: 0.0,
          actions: const [],
        ),
        backgroundColor: ColorConstants.scrollViewBackgroundColor,
        body: TabBarView(
          children: [
            Column(
              children: [
                if(pk.pokemons.isNotEmpty) Expanded(
                  child: ListViewWidget(scaffoldKey: _scaffoldKey, controller: _controller)
                ),
                if(pk.isLoading) Container(margin: const EdgeInsets.all(15),child: const CircularProgressIndicator())
              ],
            ),
            Column(
              children: [
                ListViewWidget(scaffoldKey: _scaffoldKey, controller: _controller, isFavoriteList: true)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
