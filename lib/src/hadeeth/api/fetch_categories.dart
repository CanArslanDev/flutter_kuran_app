import 'dart:ui';

import 'package:http/http.dart' as http;

import '../model/categories_model.dart';

Future<List<CategoriesModel>> fetchHadeethCategories() async {
  final response = await http.get(Uri.parse(
      'https://hadeethenc.com/api/v1/categories/list/?language=' +
          window.locale.languageCode));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return categoriesModelFromJson(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
