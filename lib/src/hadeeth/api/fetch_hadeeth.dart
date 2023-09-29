import 'dart:ui';

import 'package:http/http.dart' as http;
import '../model/hadeeth_model.dart';

Future<HadeethModel> fetchHadeeth(int id) async {
  final response = await http.get(Uri.parse(
      'https://hadeethenc.com/api/v1/hadeeths/one/?language=' + window.locale.languageCode+  '&id=$id'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return hadeethModelFromJson(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
