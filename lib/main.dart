// ignore_for_file: prefer_const_constructors
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'HomePage.dart';
import 'data.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryContainerColor));
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryContainerColor = Color(0xff5C0AFF);
const Color secondaryTextColor = Color(0xffAFBED0);
const Color normalPriority = Color(0xffF09819);
const Color lowPriority = Color(0xff3BE1F1);
const Color highPriority = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff1D2830);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myThemeData(primaryTextColor, secondaryTextColor),
      home: HomeScreen(),
    );
  }

  ThemeData myThemeData(Color primaryTextColor, Color secondaryTextColor) {
    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 15, color: secondaryTextColor),
        prefixIconColor: secondaryTextColor,
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
          color: ColorScheme.light().onPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          color: ColorScheme.light().onSecondary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          
        ),
      ),

      colorScheme: ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryContainerColor,
        background: Color(0xffF3F5F8),
        onBackground: primaryTextColor,
        onSurface: primaryTextColor,
        secondary: primaryColor,
        onSecondary: Colors.white,
      ),
      // secondaryHeaderColor: secondaryTextColor,
      // appBarTheme: AppBarTheme(backgroundColor: primaryTextColor),
      // inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(),
      // primarySwatch: Colors.lightBlue,
      useMaterial3: true,
    );
  }
}
