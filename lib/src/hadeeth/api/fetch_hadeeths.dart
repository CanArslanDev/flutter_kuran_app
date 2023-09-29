import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:quran_app/src/hadeeth/model/hadeeths_model.dart';

Future<HadeethsModel> fetchHadeeths(int id, int page) async {
  final response = await http.get(Uri.parse(
      'https://hadeethenc.com/api/v1/hadeeths/list/?language=' +
          window.locale.languageCode +
          '&category_id=$id&page=$page&per_page=20'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return hadeethsModelFromJson(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<HadeethsModel> fetchAllHadeeths(int id) async {
  final response = await http.get(Uri.parse(
      'https://hadeethenc.com/api/v1/hadeeths/list/?language=' +
          window.locale.languageCode +
          '&category_id=$id&page=1&per_page=2000'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return hadeethsModelFromJson(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
