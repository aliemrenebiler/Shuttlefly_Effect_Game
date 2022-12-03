import 'package:flutter/material.dart';
import 'package:shuttlefly_effect/backend/methods.dart';

class SEColors {
  var white = const Color(0xFFFFFFFF);

  var lgrey = const Color(0xFFE0E0E0);
  var grey = const Color(0xFFBDBDBD);
  var dgrey = const Color(0xFF9E9E9E);
  var dgrey2 = const Color(0xFF454545);

  var lblack = const Color(0xFF2E2E2E);
  var black = const Color(0xFF121212);
  var dblack = const Color(0xFF000000);

  var lcream = const Color(0xFFFFCDB2);
  var cream = const Color(0xFFFFB4A2);
  var dcream = const Color(0xFFE18A6B);
  var dcream2 = const Color(0xFFA6563A);

  var lred = const Color(0xFFFF1744);
  var red = const Color(0xFFD50000);
  var dred = const Color(0xFF8E0000);

  var lblue = const Color(0xFF448AFF);
  var blue = const Color(0xFF2962FF);
  var dblue = const Color(0xFF002486);

  var lyellow2 = const Color(0xFFFFDF00);
  var lyellow = const Color(0xFFF9A825);
  var yellow = const Color(0xFFF57F17);
  var dyellow = const Color(0xFF8A470C);

  var lpurple = const Color(0xFF8E24AA);
  var purple = const Color(0xFF6A1B9A);
  var dpurple = const Color(0xFF310D47);
}

class SESizes {
  double fontSizeSmall = queryContext!.size.height / 25;
  double fontSizeMedium = queryContext!.size.height / 20;
  double fontSizeLarge = queryContext!.size.height / 15;

  double spaceScale = queryContext!.size.height / 180;
  double sizeScale = queryContext!.size.height / 360;

  double defaultButtonHeight = queryContext!.size.height / 360 * 50;
}

var seBorderWidth = queryContext!.size.height / 80;
