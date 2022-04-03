import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import './secret.dart';

class SecretLoader {
  final String path;

  SecretLoader({required this.path});

  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(this.path, (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
