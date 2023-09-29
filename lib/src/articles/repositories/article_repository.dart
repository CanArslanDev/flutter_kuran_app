import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/rss_feed.dart';

class ArticleRepository {
  static Future<Feed?> fetchFeed(String feedUrl) async {
    Map result = {};
    try {
      //random ayet çek:
      String urlAyet = "http://54.79.48.6/ayetler/sureler?apikey=1234567890";
      var responseAyet0 = await http.get(Uri.parse(urlAyet));
      List listAyetBasliklar = json.decode(responseAyet0.body);
      Random random = Random();
      int randomAyetBasligi = random.nextInt(listAyetBasliklar.length);
      Map jsonAyetBasligi = listAyetBasliklar[randomAyetBasligi];
      String urlAyet2 = jsonAyetBasligi['link'];
      var responseAyet1 = await http.get(Uri.parse("$urlAyet&link=$urlAyet2"));
      List listAyetler = json.decode(responseAyet1.body);
      int randomAyet = random.nextInt(listAyetler.length);
      Map jsonAyet = listAyetler[randomAyet];

      //random hadis çek
      urlAyet = "http://54.79.48.6/hadisler?apikey=1234567890";
      responseAyet0 = await http.get(Uri.parse(urlAyet));
      listAyetBasliklar = json.decode(responseAyet0.body);
      randomAyetBasligi = random.nextInt(listAyetBasliklar.length);
      jsonAyetBasligi = listAyetBasliklar[randomAyetBasligi];
      urlAyet2 = jsonAyetBasligi['link'];
      responseAyet1 = await http.get(Uri.parse("$urlAyet&link=$urlAyet2"));
      listAyetler = json.decode(responseAyet1.body);
      randomAyet = random.nextInt(listAyetler.length);
      Map jsonHadis = listAyetler[randomAyet];

      //random soz çek
      urlAyet = "http://54.79.48.6/sozler?apikey=1234567890";
      responseAyet0 = await http.get(Uri.parse(urlAyet));
      listAyetBasliklar = json.decode(responseAyet0.body);
      randomAyetBasligi = random.nextInt(listAyetBasliklar.length);
      jsonAyetBasligi = listAyetBasliklar[randomAyetBasligi];
      urlAyet2 = jsonAyetBasligi['link'];
      responseAyet1 = await http.get(Uri.parse("$urlAyet&link=$urlAyet2"));
      listAyetler = json.decode(responseAyet1.body);
      randomAyet = random.nextInt(listAyetler.length);
      Map jsonSoz = listAyetler[randomAyet];

      //random fihrist çek
      urlAyet = "http://54.79.48.6/fihrist?harf=a&apikey=1234567890";
      responseAyet0 = await http.get(Uri.parse(urlAyet));
      listAyetBasliklar = json.decode(responseAyet0.body);
      randomAyetBasligi = random.nextInt(listAyetBasliklar.length);
      jsonAyetBasligi = listAyetBasliklar[randomAyetBasligi];
      urlAyet2 = jsonAyetBasligi['link'];
      responseAyet1 = await http.get(Uri.parse("$urlAyet&link=$urlAyet2"));
      listAyetler = json.decode(responseAyet1.body);
      randomAyet = random.nextInt(listAyetler.length);
      Map jsonFihrist = listAyetler[randomAyet];

      result['ayet'] = jsonAyet['ayetNo'];
      result['ayet_info'] = jsonAyet['ayet'];
      result['hadis'] = jsonHadis['konu'];
      result['hadis_info'] = jsonHadis['hadis'];
      result['soz'] = jsonSoz['kisi'];
      result['soz_info'] = jsonSoz['soz'];
      result['fihrist'] = jsonFihrist['ayet'];
      result['soz_info'] = jsonFihrist['fihrist'];

      /*   final client = http.Client();
      final response = await client.get(Uri.parse(feedUrl));


      final body = json.decode(utf8.decode(response.bodyBytes));*/

      Map<String, dynamic> x = json.encode(result) as Map<String, dynamic>;
      Feed feed = Feed.fromJson(x);
      return feed;
    } catch (e) {
      debugPrint("Errorx: " + e.toString());
      return null;
    }
  }
}
