import 'package:flutter/material.dart';

class AppColors {
  static const colorPrincipal = Color(0xFF54ace6);
  static const degradado1 = Color(0xFFc7a7e9);
  static const degradado2 = Color(0xFFa1a8ec);


  static const gradientColor1 = LinearGradient(colors: [
    colorPrincipal,
    degradado1,
    degradado2


    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}