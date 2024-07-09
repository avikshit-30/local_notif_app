import 'dart:convert';

import 'logger.dart';

class FactoryUtils {
  static T Function(String) modelFromString<T>(
      T Function(Map<String, dynamic>) factory,
      {String? subtag,
      bool showLog = true}) {
    return (rawStr) {
      try {
        var decoded = jsonDecode(rawStr);
        if (subtag != null) {
          return factory(decoded[subtag]);
        }
        try {
          if (decoded["message"] != null && showLog) {
            userLog(decoded["message"]);
          }
          // ignore: empty_catches
        } catch (e) {}
        return factory(decoded);
      } catch (e) {
        try {
          var decoded = jsonDecode(rawStr);
          if (decoded["message"] != null && showLog) {
            userLog(decoded["message"]);
            // ignore: empty_catches
          } else {
//            rethrow;
          }
          // ignore: empty_catches
        } catch (e) {}
        rethrow;
//        throw Exception("${T.toString()} Model Parsing Failed: $e");
      }
    };
  }

  static List<T> Function(String) listFromString<T>(
      T Function(Map<String, dynamic>) factory,
      {String? perElementSubtag,
      String? entireDataSubTag}) {
    return (str) {
      try {
        List<T> res = [];
//        var x = jsonDecode(str);
//        print(x.runtimeType);
        var decoded = jsonDecode(
            str); /*
       print("xoxo: " + decoded.runtimeType.toString());
       if (entireDataSubTag != null) {
        print("xoxo1: $decoded");
        print("xoxo2: ${decoded[entireDataSubTag]}");
        print("xoxo3");
       }*/

        var list = (entireDataSubTag == null
            ? decoded
            : decoded[entireDataSubTag]) as List<dynamic>;
//        if (element.count)
        for (var element in list) {
          //print("xoxo: $element");
//          print("decoding: $element");
          if (perElementSubtag == null) {
            res.add(factory(element));
          } else {
            res.add(factory(element[perElementSubtag]));
          }

//          print("decoded");
        }

        return res;
      } catch (e) {
        debugLog("Model Parsing Error (FactoryUtils)", e.toString());
        userLog(jsonDecode(str)["message"]);
        throw Exception("${T.toString()} Model Parsing Failed: $e");
      }
    };
  }
}
