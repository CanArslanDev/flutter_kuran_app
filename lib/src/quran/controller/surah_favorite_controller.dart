import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:quran_app/src/quran/model/surah.dart';
import 'package:quran_app/src/quran/repository/surah_favorite_repository.dart';

class SurahFavoriteController extends GetxController {
  final _listOfFavorite = <Surah>{}.obs;
  Set<Surah> get listOfFavorite => _listOfFavorite();

  var isLoading = false.obs;

  void addToFavorite(Surah surah) {
    _listOfFavorite.add(surah);
  }

  void removeFromFavorite(Surah surah) {
    _listOfFavorite.remove(surah);
  }

  bool isFavorite(Surah surah) {
    return _listOfFavorite.contains(surah);
  }

  Future<void> fetchSurahFavorites(int userID) async {
    final surahFavoriteRepo = SurahFavoriteRepositoryImpl();

    log(_listOfFavorite.length.toString());
    isLoading.value = true;

    final result = await surahFavoriteRepo.getListOfFavoriteSurah(userID);
    if (result.error != null) {
      Get.snackbar("hayaksi".tr(), result.error.toString());
    } else {

      var surahFavorites = result.surahFavorites;
      if (surahFavorites!.isNotEmpty) {
        // for (var item in surahFavorites) {
          
        // }
      }

      log(_listOfFavorite.length.toString());
    }

    isLoading.value = false;
  }
}
