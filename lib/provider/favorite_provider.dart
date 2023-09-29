import 'package:shared_preferences/shared_preferences.dart';

favoriteAdd() async {
  List<String> naber = [
    {
      "kanaryamfb1234@gmail.com": [
        {"quranID": ""}.toString(),
        {"quranID": ""}.toString(),
      ]
    }.toString(),
  ];
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList('items', naber);
}
