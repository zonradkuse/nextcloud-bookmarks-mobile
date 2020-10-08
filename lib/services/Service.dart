import 'dart:convert';

import 'package:bookmarks/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class Service {

  Service({@required endpointBase, @required this.user}) : this._endpointBase = endpointBase;

  final String _endpointBase;

  final User user;

  Future<http.Response> _request(method, [String endpointExtension = ""]) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('${user.username}:${user.appPassword}'));

    return await method(
        this.user.serverUrl + _endpointBase + endpointExtension,
        headers: <String, String>{'authorization': basicAuth}
    );
  }

  Future<http.Response> _requestWithParameters<T>(method, List<T> urlParams) async {
    String urlExtension = "";
    for (T param in urlParams) {
      urlExtension += "/$param";
    }

    return _request(method, urlExtension);
  }

  Future<http.Response> getRequest<T>([T urlParam]) async =>
      _requestWithParameters(http.get, [urlParam]);

  Future<http.Response> deleteRequest<T>([T urlParam]) async =>
      _requestWithParameters(http.delete, [urlParam]);

  Future<http.Response> postRequest<T>([T urlParam]) async =>
      _requestWithParameters(http.post, [urlParam]);

  Future<http.Response> putRequest<T>([T urlParam]) async =>
      _requestWithParameters(http.put, [urlParam]);
}