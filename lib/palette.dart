import 'package:flutter/material.dart';

Color kExtraDarkPrimaryColor = Color(0xFF231942);
Color kDarkPrimaryColor = Color(0xFF5e548e);
Color kButtonBackground = Color(0xFF1D1D27);

Color kPrimaryColor = Color(0xFFC933EB);
Color kSecondaryColor = Color(0xFFFC76A1);
Color kBackGroundColor = Color(0xFF424242);
Color kLightPrimaryColor = Color(0xFFbe95c4);
Color kExtraLightPrimaryColor = Color(0xFFe0b1cb);
var kGradientColor = [
  Color(0xFFbb3fdd),
  Color(0xFFfb6da9),
  Color(0xFFff9f7c),
];

Color kPrimaryTextColor = Color(0xFF212121);
Color kSecondaryTextColor = Color(0xFF757575);
Color kDividerColor = Color(0xFFBDBDBD);

Color kTextColor = Color(0xFFFFFFFF);

const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFC933EB), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

// class MyThemes {
//   static final darkTheme = ThemeData.dark().copyWith(
//     scaffoldBackgroundColor: Colors.grey.shade900,
//     primaryColor: Colors.black,
//     colorScheme: ColorScheme.dark(),
//     iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
//   );

//   static final lightTheme = ThemeData.light().copyWith(
//     scaffoldBackgroundColor: Colors.white,
//     primaryColor: Colors.white,
//     colorScheme: ColorScheme.light(),
//     iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),
//   );
// }
