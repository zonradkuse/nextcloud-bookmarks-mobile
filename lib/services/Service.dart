import 'dart:convert';

import 'package:bookmarks/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class Service {

  Service({@required endpointBase, @required user}) : this._endpointBase = endpointBase, this.user = user;

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
      // for convenience we catch the missing optional urlParam below here
      if (param == null) continue;

      urlExtension += "/$param";
    }

    return _request(method, urlExtension);
  }

  Future<http.Response> getRequest<T>([T? urlParam]) async =>
      _requestWithParameters(http.get, [urlParam]);

  Future<http.Response> deleteRequest<T>([T? urlParam]) async =>
      _requestWithParameters(http.delete, [urlParam]);

  Future<http.Response> postRequest<T>([T? urlParam]) async =>
      _requestWithParameters(http.post, [urlParam]);

  Future<http.Response> putRequest<T>([T? urlParam]) async =>
      _requestWithParameters(http.put, [urlParam]);
}