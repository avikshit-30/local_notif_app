import 'package:flutter/material.dart';

extension StyleExt on TextStyle {
  TextStyle get size9 => copyWith(fontSize: 9);
  TextStyle get size10 => copyWith(fontSize: 10);
  TextStyle get size11 => copyWith(fontSize: 11);

  TextStyle get size12 => copyWith(fontSize: 12);

  TextStyle get size13 => copyWith(fontSize: 13);

  TextStyle get size14 => copyWith(fontSize: 14);

  TextStyle get size15 => copyWith(fontSize: 15);

  TextStyle get size16 => copyWith(fontSize: 16);

  TextStyle get size17 => copyWith(fontSize: 17);

  TextStyle get size18 => copyWith(fontSize: 18);

  TextStyle get size19 => copyWith(fontSize: 19);

  TextStyle get size20 => copyWith(fontSize: 20);

  TextStyle get size21 => copyWith(fontSize: 21);

  TextStyle get size22 => copyWith(fontSize: 22);

  TextStyle get size23 => copyWith(fontSize: 23);

  TextStyle get size24 => copyWith(fontSize: 24);

  TextStyle get size25 => copyWith(fontSize: 25);

  TextStyle get size26 => copyWith(fontSize: 26);

  TextStyle get size28 => copyWith(fontSize: 28);

  TextStyle get size32 => copyWith(fontSize: 32);

  TextStyle get size30 => copyWith(fontSize: 30);

  TextStyle get size36 => copyWith(fontSize: 36);
  TextStyle get size40 => copyWith(fontSize: 40);

  TextStyle get size50 => copyWith(fontSize: 50);

  TextStyle get colorWhite => copyWith(color: const Color(0xffffffff));

  TextStyle get colorBlack => copyWith(color: const Color(0xff000000));

  TextStyle withHeight(double x) => copyWith(height: x);

  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
}

const w400 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal);
// GoogleFonts.poppins(
//     fontSize: 11,
//     color: Colors.black,
//     fontWeight: FontWeight.w400,
//     fontStyle: FontStyle.normal);

const w500 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal);

const w600 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal);
const w800 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal);
const w900 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.normal);

const w700 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal);
