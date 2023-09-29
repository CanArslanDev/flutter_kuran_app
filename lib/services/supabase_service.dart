import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onepref/onepref.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../src/profile/controllers/user_controller.dart';

class SupabaseService {
  int j = 102;
  final userC = Get.put(UserControllerImpl());
  var supabase = Supabase.instance.client;
  getSurahFavoritesData(
      String table, String userId, int surahId, int verseId) async {
    final res1 = await supabase
        .from("SurahFavorites")
        .select(
          "controller",
        )
        .eq("controller", "${userId}_${surahId}_${verseId.toString()}")
        .execute();
    if (res1.data.toString() == "[]" || res1.data.toString() == "null") {
      return false;
    } else {
      return true;
    }
  }

  setSurahFavorite(String userId, int surahId, int verseId) async {
    await Supabase.instance.client.from('SurahFavorites').insert({
      "user_id": userId,
      "surah_id": surahId,
      "verse_id": verseId,
      "controller": "${userId}_${surahId}_${verseId.toString()}"
    }).execute();
  }

  setHadeethFavorite(
    int userId,
    int hadeethId,
    String title,
  ) async {
    await Supabase.instance.client.from('hadeethfavorites').insert({
      "user_id": userId,
      "hadeeth_id": hadeethId,
      "title": title,
    }).execute();
  }

  deleteSurahFavorite(String userId, int surahId, int verseId) async {
    await supabase.from('SurahFavorites').delete().match({
      "user_id": userId,
      "surah_id": surahId,
      "verse_id": verseId,
      "controller": "${userId}_${surahId}_${verseId.toString()}"
    }).execute();
  }

  Future<String?> getSurahSound(String surahName) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('SurahSound')
        .select()
        .eq('name', surahName)
        .execute();

    if (response.error != null) {
      return null;
    }

    final data = response.data as List<dynamic>;
    if (data.isNotEmpty) {
      final row = data.first;
      final surahLink = row['sound_link'] as String?;
      return surahLink;
    }

    return null;
  }

  Future<List> fetchContentFromSupabase() async {
    // Bu ayın kaçıncı gününde olduğumuzu alıyoruz
    final now = DateTime.now();
    final dayOfMonth = now.day > 30 ? 30 : now.day;
    // Supabase'deki stories tablosunda, day sütununda günümüze ait olan rowu buluyoruz
    final response = await supabase
        .from('stories')
        .select('links')
        .eq('day', dayOfMonth)
        .execute();

    // Json dosyasını çekiyoruz
    final jsonList = response.data as List<dynamic>;

    if (jsonList.isNotEmpty) {
      // İlk rowun links sütununda content1, content2 ve content3 listeleri var
      final jsonLinks = jsonList.first['links'];

      // Listelere dönüştürüyoruz
      final content1 = jsonLinks['content1'] as List<dynamic>;
      final content2 = jsonLinks['content2'] as List<dynamic>;
      final content3 = jsonLinks['content3'] as List<dynamic>;

      // Yazdırma işle
      return [content1, content2, content3];
    } else {
      return [];
    }
  }

  Future<List> fetchPDFBooks() async {
    final response = await supabase
        .from('pdfbooks')
        .select()
        .order('id', ascending: true)
        .execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
      return [];
    }

    final List<dynamic> rows = response.data as List<dynamic>;

    final List<String> links = [];
    final List<String> titles = [];

    for (final row in rows) {
      final String link = row['link'] as String;
      final String title = row['title'] as String;

      links.add(link);
      titles.add(title);
    }

    return [links, titles];
  }

  Future<void> pdfAddToFavorites(String title, String link, int userId) async {
    final response = await supabase
        .from('pdffavorites')
        .upsert({'title': title, 'links': link, 'user_id': userId}).execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
    }
  }

  Future<void> pdfRemoveFromFavorites(int userId, String title) async {
    final response = await supabase
        .from('pdffavorites')
        .delete()
        .eq('user_id', userId)
        .eq('title', title)
        .execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
    }
  }

  Future<List> pdfGetFavoritesByUserId(int userId) async {
    final response = await supabase
        .from('pdffavorites')
        .select('title, links')
        .eq('user_id', userId)
        .execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
      return [];
    }

    final List favorites = response.data as List;
    return favorites;
  }

  Future<bool> isFavoritePDF(int userId, String title) async {
    final response = await supabase
        .from('pdffavorites')
        .select()
        .eq('user_id', userId)
        .eq('title', title)
        .execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
      return false;
    }

    final List<dynamic> favorites = response.data as List<dynamic>;
    return favorites.isNotEmpty;
  }

  Future<bool> isFavoriteHadeeth(int userId, int hadeethId) async {
    final response = await supabase
        .from('hadeethfavorites')
        .select()
        .eq('user_id', userId)
        .eq('hadeeth_id', hadeethId)
        .execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
      return false;
    }

    final List<dynamic> favorites = response.data as List<dynamic>;
    return favorites.isNotEmpty;
  }

  Future<void> restApiAddToFavorites(String link, int userId, String title,
      int index, String image, String date) async {
    // final jsonData = json.decode('["$description"]');
    final response = await supabase.from('restapifavorites').upsert({
      'links': link,
      'user_id': userId,
      'title': title,
      'index': index,
      'image': image,
      'date': date
    }).execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
    }
  }

  Future<void> restApiRemoveFromFavorites(int userId, String links) async {
    final response = await supabase
        .from('restapifavorites')
        .delete()
        .eq('user_id', userId)
        .eq('links', links)
        .execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
    }
  }

  Future<void> hadeethRemoveFromFavorites(int userId, int hadeethId) async {
    final response = await supabase
        .from('hadeethfavorites')
        .delete()
        .eq('user_id', userId)
        .eq('hadeeth_id', hadeethId)
        .execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
    }
  }

  Future<List> restApiGetFavoritesByUserId(int userId) async {
    final response = await supabase
        .from('restapifavorites')
        .select('links,title,image,date,index')
        .eq('user_id', userId)
        .execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
      return [];
    }

    final List favorites = response.data as List;
    return favorites;
  }

  Future<List> hadeethGetFavoritesByUserId(int userId) async {
    final response = await supabase
        .from('hadeethfavorites')
        .select('hadeeth_id,title,user_id')
        .eq('user_id', userId)
        .execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
      return [];
    }

    final List favorites = response.data as List;
    return favorites;
  }

  void restApiDeleteUserFavorites(int userId) async {
    final response = await supabase
        .from('restapifavorites')
        .delete()
        .eq('user_id', userId)
        .execute();

    if (response.error != null) {
      throw response.error!;
    }
  }

  void pdfDeleteUserFavorites(int userId) async {
    final response = await supabase
        .from('pdffavorites')
        .delete()
        .eq('user_id', userId)
        .execute();

    if (response.error != null) {
      throw response.error!;
    }
  }

  Future<bool> restApiIsFavoritePDF(int userId, String links) async {
    final response = await supabase
        .from('restapifavorites')
        .select()
        .eq('user_id', userId)
        .eq('links', links)
        .execute();

    if (response.error != null) {
      // Hata durumunda işlem yapabilirsiniz.
      return false;
    }

    final List<dynamic> favorites = response.data as List<dynamic>;
    return favorites.isNotEmpty;
  }

  Future<int> restApiGetLikeCount(String links) async {
    final response = await supabase
        .from('restapifavorites')
        .select()
        .eq('links', links)
        .execute();

    if (response.error != null) {
      throw response.error!;
    }

    final rows = response.data as List<dynamic>?;
    final rowCount = rows?.length ?? 0;

    return rowCount;
  }

  // getVerseList1() async {
  //   final response = await supabase
  //       .from('surahVerseSounds')
  //       .select('verseList')
  //       .eq('id', 'main')
  //       .execute();

  //   if (response.error != null) {
  //     throw Exception('Veri alınamadı');
  //   }
  //   final jsonList = response.data as List<dynamic>;
  //   return jsonList[0]["verseList"]['fatiha'];
  //   // return verseMap;
  // }

  bool getPurchase() {
    int? year = OnePref.getInt("Pyear");
    int? month = OnePref.getInt("Pmonth");
    int? day = OnePref.getInt(
      "Pday",
    );
    if (year != null && month != null && day != null) {
      DateTime currentDateTime = DateTime.now();

      // Girdiğiniz yıl, ay ve günü kullanarak bir DateTime nesnesi oluşturuyoruz
      DateTime inputDateTime = DateTime(year, month, day);

      // Şu anki tarih ile girdiğiniz tarih arasındaki farkı hesaplayıp dönüştürüyoruz
      Duration difference = currentDateTime.difference(inputDateTime);
      int months = (difference.inDays / 30).floor();
      final monthsDifference =
          (currentDateTime.year - inputDateTime.year) * 12 +
              currentDateTime.month -
              inputDateTime.month;
      int absValue = monthsDifference.abs();
      if (absValue > 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  getPurchaseMonth() {
    int? year = OnePref.getInt("Pyear");
    int? month = OnePref.getInt("Pmonth");
    int? day = OnePref.getInt(
      "Pday",
    );
    if (year != null && month != null && day != null) {
      DateTime currentDateTime = DateTime.now();

      // Girdiğiniz yıl, ay ve günü kullanarak bir DateTime nesnesi oluşturuyoruz
      DateTime inputDateTime = DateTime(year, month, day);

      // Şu anki tarih ile girdiğiniz tarih arasındaki farkı hesaplayıp dönüştürüyoruz
      Duration difference = currentDateTime.difference(inputDateTime);
      int months = (difference.inDays / 30).floor();
      final monthsDifference =
          (currentDateTime.year - inputDateTime.year) * 12 +
              currentDateTime.month -
              inputDateTime.month;

      return monthsDifference.abs();
    } else {
      return null;
    }
  }

  Future<void> setPurchase(
    int month1,
  ) async {
    DateTime now = DateTime.now();
    now = now.add(Duration(days: 30 * month1));
    int year = now.year;
    int month = now.month;
    int day = now.day;
    await OnePref.setInt("month", 12);
    await OnePref.setInt("Pyear", year);
    await OnePref.setInt("Pmonth", month);
    await OnePref.setInt("Pday", day);
    // final response = await supabase
    //     .from('appPurchase')
    //     .select()
    //     .eq('user_id', userId)
    //     .execute();

    // if (response.data.length > 0) {
    //   await supabase
    //       .from('appPurchase')
    //       .update({'last_time': timestamp.toIso8601String()})
    //       .eq('user_id', userId)
    //       .execute();
    // } else {
    //   await supabase.from('appPurchase').insert({
    //     'user_id': userId,
    //     'last_time': timestamp.toIso8601String()
    //   }).execute();
    // }

    Get.dialog(
      AlertDialog(
        title: Text('Üyelik Onaylandı'),
        content: Text('Üyeliğiniz Aktif Edildi'),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text("Tamam"),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(Get.context!).primaryColor),
          )
        ],
      ),
    );
  }

  getVerseList(String surahId) async {
    final response = await supabase
        .from('surahVerseSounds')
        .select('verseList')
        .eq('id', 'main')
        .execute();

    if (response.error != null) {
      throw Exception('Veri alınamadı');
    }
    final jsonList = response.data as List<dynamic>;
    print("r33 " + response.error.toString());
    return jsonList[0]["verseList"][surahId];
  }

  Future getSoundContentList() async {
    final response = await supabase
        .from('soundcontent')
        .select('list')
        .eq('id', 'main')
        .execute();

    if (response.error != null) {
      throw Exception('Veri alınamadı');
    }
    final jsonList = response.data as List<dynamic>;
    return jsonList[0]['list'];
  }

  Future<List<String>> getBackgroundImageURLs() async {
    final response = await supabase
        .from('shareBackgroundImages')
        .select('url')
        .order('id', ascending: true)
        .execute();

    if (response.error != null) {
      throw response.error!.message;
    }

    final List<dynamic> data = response.data as List<dynamic>;
    final List<String> imageURLs =
        data.map((item) => item['url'] as String).toList();

    return imageURLs;
  }
}
