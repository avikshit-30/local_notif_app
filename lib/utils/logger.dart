import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';

//import 'package:interbits_23_app/util/color_theme.dart';

const bool ignorePrintsInRelease = true;

class DebugTags {
  static const String repoCreation = "RepoCreation";

  static const String temp = "TEMP";

  static const String auth = "Auth";
  static const String googleSignIn = "Auth-GoogleSignIn";
  static const String authTokenFetch = "Auth-AuthTokens";

  static const String secureStorage = "SecureStorage";

  static const String httpClientException = "HTTP Client Exception";
  static const String httpStatusNotOK = "HTTP Error";
  static const String httpClientResponse = "HTTP Response";
  static const String httpRequest = "HTTP Request";
/*
  static const String rebuildingWidget = "Rebuilding";
  static const String apiCall = "API Call";
  static const String apiResult = "API Result";
  static const String apiResonseParseError = "Response Parse Failed";
*/
  static const String routing = "Routing Path";
}

//Maybe add a warning log function too (it will print a flashy red warning, and also throw an runtime exception if in debug mode)?

// Use this when you want to print a stement for debuging only.
void debugLog(
  String debugTag,
  dynamic msg, {
  bool showToast = false,
  /* ColorTheme? theme*/
}) {
  debugAndToast(debugTag, msg, showToast,
      backgroundColor:
          /*theme != null ? theme.toastBackgroundColor :*/ Colors.black,
      textColor: /*theme != null ? theme.toastTextColor :*/ Colors.white);
}

// Use this when you want to show something to the user as a toast (this automatically prints that statement as well)
void userLog(
  dynamic msg, {
  bool showToast = true,
  String debugTag = "",
  /* ColorTheme? theme*/
}) {
  debugAndToast(debugTag, msg, showToast,
      backgroundColor:
          /*theme != null ? theme.toastBackgroundColor :*/ Colors.black,
      textColor: /*theme != null ? theme.toastTextColor :*/ Colors.white);
}

void debugAndToast(String debugTag, dynamic msg, bool showToast,
    {Color backgroundColor = Colors.black, Color textColor = Colors.white}) {
  String debugMsg = debugTag.isEmpty ? msg.toString() : "$debugTag: $msg";
  if (kReleaseMode) {
    if (!ignorePrintsInRelease) {
      log(debugMsg);
    }
  } else {
    log(debugMsg);
  }

  if (showToast) {
    Fluttertoast.cancel().whenComplete(() => Fluttertoast.showToast(
        msg: msg.toString(),
        backgroundColor: backgroundColor,
        
        textColor: textColor,
        fontSize: 16.0));
  }
}
