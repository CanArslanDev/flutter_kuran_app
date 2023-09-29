import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final box = Get.find<GetStorage>();
  Rx<bool> homePageStoryCard = true.obs;
  Rx<bool> homePagePrayerCard = true.obs;
  Rx<bool> homePageFridayCard = true.obs;
  Rx<bool> homePageQuizCard = true.obs;
  Rx<bool> homePageQuizHistoryCard = true.obs;
  Rx<bool> homePageKuranCard = true.obs;
  Rx<bool> homePageTesbihatCard = true.obs;
  Rx<bool> homePagePDFCard = true.obs;
  Rx<bool> homePagePostCard = true.obs;
  Rx<bool> homePageAyetCard = true.obs;
  Rx<bool> homePageRadioCard = true.obs;
  Rx<bool> homePageEsmaulhusnaCard = true.obs;
  Rx<bool> homePageBabyCard = true.obs;
  Rx<bool> homePageQuestionCard = true.obs;
  Rx<bool> homePageImageCard = true.obs;
  @override
  void onInit() {
    load();
    super.onInit();
  }

  bool StringToBool(String text) {
    if (text == 'true') return true;
    return false;
  }

  load() async {
    box.writeIfNull('homePageStoryCard', 'true');
    box.writeIfNull('homePagePrayerCard', 'true');
    box.writeIfNull('homePageFridayCard', 'true');
    box.writeIfNull('homePageQuizCard', 'true');
    box.writeIfNull('homePageQuizHistoryCard', 'true');
    box.writeIfNull('homePageKuranCard', 'true');
    box.writeIfNull('homePageTesbihatCard', 'true');
    box.writeIfNull('homePagePDFCard', 'true');
    box.writeIfNull('homePagePostCard', 'true');
    box.writeIfNull('homePageAyetCard', 'true');
    box.writeIfNull('homePageRadioCard', 'true');
    box.writeIfNull('homePageEsmaulhusnaCard', 'true');
    box.writeIfNull('homePageBabyCard', 'true');
    box.writeIfNull('homePageQuestionCard', 'true');
    box.writeIfNull('homePageImageCard', 'true');
    if (box.read('homePageStoryCard') == true) {
    } else {}
    homePageStoryCard.value = StringToBool(box.read('homePageStoryCard'));
    homePagePrayerCard.value = StringToBool(box.read('homePagePrayerCard'));
    homePageFridayCard.value = StringToBool(box.read('homePageFridayCard'));
    homePageQuizCard.value = StringToBool(box.read('homePageQuizCard'));
    homePageQuizHistoryCard.value =
        StringToBool(box.read('homePageQuizHistoryCard'));
    homePageKuranCard.value = StringToBool(box.read('homePageKuranCard'));
    homePageTesbihatCard.value = StringToBool(box.read('homePageTesbihatCard'));
    homePagePDFCard.value = StringToBool(box.read('homePagePDFCard'));
    homePagePostCard.value = StringToBool(box.read('homePagePostCard'));
    homePageAyetCard.value = StringToBool(box.read('homePageAyetCard'));
    homePageRadioCard.value = StringToBool(box.read('homePageRadioCard'));
    homePageEsmaulhusnaCard.value =
        StringToBool(box.read('homePageEsmaulhusnaCard'));
    homePageBabyCard.value = StringToBool(box.read('homePageBabyCard'));
    homePageQuestionCard.value = StringToBool(box.read('homePageQuestionCard'));
    homePageImageCard.value = StringToBool(box.read('homePageImageCard'));
  }
}
