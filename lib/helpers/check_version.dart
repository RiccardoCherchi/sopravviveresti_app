import 'dart:convert';
import 'dart:io';

import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;

Future<bool> checkAppVersion() async {
  final version = (await PackageInfo.fromPlatform()).buildNumber;
  final data = json.decode((await http.get(
          "https://sopravvivresti.howmuchismyoutfit.com/check-version?version=$version"))
      .body);
  return data['up_to_date'] as bool;
}
