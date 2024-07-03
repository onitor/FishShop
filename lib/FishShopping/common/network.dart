
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class EDCRequest {
  static const String baseUrl = 'http://www.shuqi.com/';

  static Future<dynamic> get({required String action, required Map params}) async {
    return EDCRequest.mock(action: action, params: params);
  }

  static Future<dynamic> post({required String action, required Map params}) async {
    return EDCRequest.mock(action: action, params: params);
  }

  static Future<dynamic> mock({required String action, required Map params}) async {
    var responseStr = await rootBundle.loadString('mock/$action.json');
    var responseJson = json.decode(responseStr);
    return responseJson['data'];
  }
}