import 'dart:convert';

import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;

Future<bool> checkAppVersion() async {
  final version = (await PackageInfo.fromPlatform()).buildNumber;
  final data = json.decode((await http
          .get("http://68.183.71.76:8000/check-version?version=$version"))
      .body);

  return data['up_to_date'] as bool;
}
