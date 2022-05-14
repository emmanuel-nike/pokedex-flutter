import 'package:flutter/material.dart';
import 'package:pokedex/screens/DetailScreen.dart';
import 'package:pokedex/screens/HomeScreen.dart';

//double getHeight(context) => MediaQuery.of(context).size.height;

final routes = {
  '/home': (BuildContext context) => const HomeScreen(),
  '/detail': (BuildContext context) => const DetailScreen(),
};
