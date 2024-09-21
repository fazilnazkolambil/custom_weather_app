import 'package:custom_weather_app/Screens/cities.dart';
import 'package:custom_weather_app/Screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Components/classes&functions.dart';

var width;
var height;
void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme:GoogleFonts.ubuntuCondensedTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
