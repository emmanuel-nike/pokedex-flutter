import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:pokedex/routes.dart';
import 'package:pokedex/services/pokemon_service.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PokemonProvider(PokemonService())),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Noto Sans',
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textColor),
          headline2: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w700,
              color: ColorConstants.textColor),
          bodyText1: TextStyle(fontSize: 14.0, color: ColorConstants.textColor),
          bodyText2: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: ColorConstants.textColor),
        ),
      ),
      initialRoute: '/home',
      routes: routes,
    );
  }
}
