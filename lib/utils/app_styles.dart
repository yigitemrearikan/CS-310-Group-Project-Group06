import 'package:flutter/material.dart';

class AppStyles {
  static const String mainFontFamily = 'CustomFontFamily';

  static const Color primaryColor = Colors.black87;
  static const Color backgroundColor = Colors.white;
  static const Color buttonColor = Colors.grey;


  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);

  
  static const TextStyle titleStyle = TextStyle(
    fontFamily: mainFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );
}