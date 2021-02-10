import 'dart:convert';

import 'package:bookmarks/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';

abstract class Service {
  Service({@required endpointBase, @required this.user})
      : this._endpointBase = endpointBase;

  final String _endpointBase;

  final User user;

  Future<Map<String, dynamic>> _request(method,
      [String endpointExtension = ""]) async {
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode('${user.username}:${user.appPassword}'));

    http.Response response = await method(
        this.user.serverUrl + _endpointBase + endpointExtension,
        headers: <String, String>{'authorization': basicAuth});
    if (response.statusCode != 200) {
      throw new Exception('Request failed');
    }
    if (!isJSON(response.body)) {
      throw new Exception('Failed to parse response: ' + response.body);
    }
    return jsonDecode(response.body);
  }

  Image getImage([String endpointExtension = '']) {
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode('${user.username}:${user.appPassword}'));

    Image image = Image.network(
        this.user.serverUrl + _endpointBase + endpointExtension,
        width: 32.0,
        height: 32.0,
        headers: <String, String>{'authorization': basicAuth},
        errorBuilder:
            (BuildContext build, Object object, StackTrace stackTrace) =>
                Icon(Icons.bookmark_border, size: 32.0));

    return image;
  }

  Future<Map<String, dynamic>> getRequest([String urlParam]) async =>
      _request(http.get, urlParam);

  Future<Map<String, dynamic>> deleteRequest([String urlParam]) async =>
      _request(http.delete, urlParam);

  Future<Map<String, dynamic>> postRequest<T>([String urlParam]) async =>
      _request(http.post, urlParam);

  Future<Map<String, dynamic>> putRequest<T>([String urlParam]) async =>
      _request(http.put, urlParam);
}
