import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData mythemedata = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: kprimary,
  fontFamily: 'Pop',
  buttonTheme: ButtonThemeData(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), side: BorderSide.none),
      buttonColor: kbtn.withOpacity(0.7),
      minWidth: 150),
  scaffoldBackgroundColor: kBackgroundColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kwhite,
    elevation: 0,
    type: BottomNavigationBarType.shifting,
    selectedItemColor: Color.fromARGB(255, 111, 223, 59),
    showSelectedLabels: true,
    showUnselectedLabels: false,
    unselectedItemColor: Colors.black,
    selectedIconTheme: IconThemeData(size: 25),
    unselectedIconTheme: IconThemeData(size: 20),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: kprimary.withOpacity(0.1),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kprimary, width: 1)),
  ),
  dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme:
          InputDecorationTheme(contentPadding: EdgeInsets.all(5))),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
  ),
  cardTheme: CardTheme(
      color: kprimary.withOpacity(0.4),
      elevation: 10,
      shadowColor: kshadowe,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(5)),
  iconTheme: const IconThemeData(size: 25, color: kprimary, weight: 10),
  dialogTheme: DialogTheme(
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15),
      backgroundColor: kwhite,
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: kshadowe),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(10),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide.none)),
          backgroundColor:
              MaterialStateProperty.all<Color>(kbtn.withOpacity(0.6)),
          elevation: MaterialStateProperty.all<double>(10),
          shadowColor: MaterialStateProperty.all<Color>(kshadowe))),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(15),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(kwhite),
          backgroundColor: MaterialStateProperty.all<Color>(kbtn),
          elevation: MaterialStateProperty.all<double>(5),
          shadowColor: MaterialStateProperty.all<Color>(kshadowe))),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), side: BorderSide.none)),
      padding: MaterialStateProperty.all(
        const EdgeInsets.all(10),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(kbtn),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
  ),
);
