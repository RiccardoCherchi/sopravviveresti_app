import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'device.dart';

class APIResponse {
  final dynamic data;
  final int statusCode;

  APIResponse(this.data, this.statusCode);
}

class API {
  final String url;

  API(this.url);

  Future get({
    String path,
    String fullUrl,
  }) async {
    try {
      http.Request request = http.Request(
        "get",
        Uri.parse(fullUrl == null ? url + path : fullUrl),
      );

      final vendor = await getVendorId();
      request.headers.addAll({
        "Vendor": "$vendor",
      });

      final response = await request.send();
      final data = json.decode(await response.stream.bytesToString());
      return APIResponse(
        data,
        response.statusCode,
      );
    } catch (e) {
      throw e;
    }
  }

  Future post({
    String path,
    String fullUrl,
    @required Map body,
  }) async {
    http.Request request = http.Request(
      "post",
      Uri.parse(fullUrl == null ? url + path : fullUrl),
    );

    request.body = json.encode(body);
    request.headers.addAll({
      "Content-Type": "application/json",
    });

    final vendor = await getVendorId();
    request.headers.addAll({
      "Vendor": "$vendor",
    });

    final response = await request.send();
    final data = json.decode(await response.stream.bytesToString());
    return APIResponse(
      data,
      response.statusCode,
    );
  }

  Future put({
    String path,
    String fullUrl,
    @required Map body,
  }) async {
    http.Request request = http.Request(
      "put",
      Uri.parse(fullUrl == null ? url + path : fullUrl),
    );

    request.body = json.encode(body);
    request.headers.addAll({
      "Content-Type": "application/json",
    });

    final vendor = await getVendorId();
    request.headers.addAll({
      "Vendor": "$vendor",
    });

    final response = await request.send();
    final data = json.decode(await response.stream.bytesToString());
    return APIResponse(
      data,
      response.statusCode,
    );
  }

  Future delete({
    String path,
    String fullUrl,
  }) async {
    try {
      http.Request request = http.Request(
        "delete",
        Uri.parse(fullUrl == null ? url + path : fullUrl),
      );

      final vendor = await getVendorId();
      request.headers.addAll({
        "Vendor": "$vendor",
      });

      final response = await request.send();
      final stream = await response.stream.bytesToString();
      dynamic data;
      try {
        data = json.encode(stream);
      } catch (e) {
        data = stream;
      }
      return APIResponse(
        await data,
        response.statusCode,
      );
    } catch (e) {
      throw e;
    }
  }
}

final api = API('https://howmuchismyoutfit.com/');
