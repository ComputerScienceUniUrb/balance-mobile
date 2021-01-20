
import 'package:flutter/material.dart';

// Class containing all the [MaterialColor] of the app
class BColors {

  BColors._();

  static const MaterialColor colorPrimary = _malibu;
  static const MaterialColor colorPrimaryDark = _scampi;
  static const MaterialColor colorPrimaryLight = _periwinkle;
  static const MaterialColor colorAccent = _dodger_blue;
  static const MaterialColor colorSecondary = _solitude;
  static const Color textColor = _dove_gray;
  static const Color darkOnBg = _mine_shaft;

  static const MaterialColor _malibu = MaterialColor(0xFF8C88FF, {
    50: Color.fromRGBO(140, 136, 255, .1),
    100: Color.fromRGBO(140, 136, 255, .2),
    200: Color.fromRGBO(140, 136, 255, .3),
    300: Color.fromRGBO(140, 136, 255, .4),
    400: Color.fromRGBO(140, 136, 255, .5),
    500: Color.fromRGBO(140, 136, 255, .6),
    600: Color.fromRGBO(140, 136, 255, .7),
    700: Color.fromRGBO(140, 136, 255, .8),
    800: Color.fromRGBO(140, 136, 255, .9),
    900: Color.fromRGBO(140, 136, 255, 1),
  });
  static const MaterialColor _scampi = MaterialColor(0xFF6865AC, {
    50: Color.fromRGBO(104, 101, 172, .1),
    100: Color.fromRGBO(104, 101, 172, .2),
    200: Color.fromRGBO(104, 101, 172, .3),
    300: Color.fromRGBO(104, 101, 172, .4),
    400: Color.fromRGBO(104, 101, 172, .5),
    500: Color.fromRGBO(104, 101, 172, .6),
    600: Color.fromRGBO(104, 101, 172, .7),
    700: Color.fromRGBO(104, 101, 172, .8),
    800: Color.fromRGBO(104, 101, 172, .9),
    900: Color.fromRGBO(104, 101, 172, 1),
  });
  static const MaterialColor _periwinkle = MaterialColor(0xFFCECCFF, {
    50: Color.fromRGBO(206, 204, 255, .1),
    100: Color.fromRGBO(206, 204, 255, .2),
    200: Color.fromRGBO(206, 204, 255, .3),
    300: Color.fromRGBO(206, 204, 255, .4),
    400: Color.fromRGBO(206, 204, 255, .5),
    500: Color.fromRGBO(206, 204, 255, .6),
    600: Color.fromRGBO(206, 204, 255, .7),
    700: Color.fromRGBO(206, 204, 255, .8),
    800: Color.fromRGBO(206, 204, 255, .9),
    900: Color.fromRGBO(206, 204, 255, 1),
  });
  static const MaterialColor _dodger_blue = MaterialColor(0xFF34C6F9, {
    50: Color.fromRGBO(52, 198, 249, .1),
    100: Color.fromRGBO(52, 198, 249, .2),
    200: Color.fromRGBO(52, 198, 249, .3),
    300: Color.fromRGBO(52, 198, 249, .4),
    400: Color.fromRGBO(52, 198, 249, .5),
    500: Color.fromRGBO(52, 198, 249, .6),
    600: Color.fromRGBO(52, 198, 249, .7),
    700: Color.fromRGBO(52, 198, 249, .8),
    800: Color.fromRGBO(52, 198, 249, .9),
    900: Color.fromRGBO(52, 198, 249, 1),
  });
  static const MaterialColor _solitude = MaterialColor(0xFFE5F4FF, {
    50: Color.fromRGBO(229, 244, 255, .1),
    100: Color.fromRGBO(229, 244, 255, .2),
    200: Color.fromRGBO(229, 244, 255, .3),
    300: Color.fromRGBO(229, 244, 255, .4),
    400: Color.fromRGBO(229, 244, 255, .5),
    500: Color.fromRGBO(229, 244, 255, .6),
    600: Color.fromRGBO(229, 244, 255, .7),
    700: Color.fromRGBO(229, 244, 255, .8),
    800: Color.fromRGBO(229, 244, 255, .9),
    900: Color.fromRGBO(229, 244, 255, 1),
  });

  static const Color _dove_gray = Color.fromARGB(255, 102, 102, 102);
  
  static const Color _mine_shaft = Color.fromARGB(255, 31, 31, 31);
}