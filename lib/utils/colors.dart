import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color colorStart = Colors.purple;
const Color colorEnd = Colors.deepPurple;

const primaryGradient = LinearGradient(
    colors: const [colorEnd, colorStart],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);

final ThemeData iosTheme = ThemeData(
    primaryColor: Colors.green[100],
    primarySwatch: Colors.orange,
    primaryColorBrightness: Brightness.light);

final ThemeData defaultTheme = ThemeData(
    primarySwatch: Colors.purple, accentColor: Colors.orangeAccent[400]);
