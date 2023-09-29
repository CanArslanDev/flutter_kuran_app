import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:radio_player/radio_player.dart';

import '../../../helper/ads.dart';

class RadioPageController extends GetxController {
  final RadioPlayer radioPlayer = RadioPlayer();
  Rx<bool> isPlaying = false.obs;
  late Rx<List<String>?> metadata;
  Rx<String> radioTitle = "".obs;
  Rx<int> radioIndex = 0.obs;

  BannerAd? myBanner;
  List radios = [
    {
      "title": "Erkam Radyo",
      "url": 'https://api-tv5.yayin.com.tr:8002/mp3',
      "icon": "https://www.erkamradyo.com/images/islamveihsan.jpg",
    },
    {
      "title": "Vav Radyo",
      "url": 'https://trkvz-radyolar.ercdn.net/radyovav/chunklist.m3u8',
      "icon":
          "https://yt3.googleusercontent.com/RACtsIu2-G96TFGcEje3D8fhomrVO0CTEv_H8CFTTLDtsB1EdbOSaY_j5EVsAHshCrTIMCVTtj0=s900-c-k-c0x00ffffff-no-rj",
    },
    {
      "title": "Berat Radyo",
      "url": "https://beratfm.80.yayin.com.tr/;",
      "icon": "https://www.canliradyodinle.fm/wp-content/uploads/berat-fm.jpg",
    },
    {
      "title": "Diyanet Radyo",
      "url":
          "https://eustr76.mediatriple.net/videoonlylive/mtikoimxnztxlive/broadcast_5e3c1171d7d2a.smil/playlist.m3u8",
      "icon":
          "https://www.canliradyodinle.fm/wp-content/uploads/Diyanet-Radyo-100x100.jpg",
    },
    {
      "title": "Hak Radyo",
      "url": "http://shoutcast.radyogrup.com:1060/;stream/1",
      "icon": "https://www.canliradyodinle.fm/wp-content/uploads/hak-radyo.jpg",
    },
    {
      "title": "Arkadaş FM",
      "url": "https://radyo.yayindakiler.com:4134/stream?/;stream.mp3",
      "icon":
          "https://www.canliradyodinle.fm/wp-content/uploads/isparta-arkadas-fm.jpg",
    },
    {
      "title": "Bayram FM",
      "url": "https://sslyayin.netyayin.net/3442/stream?/;stream.mp3",
      "icon":
          "https://www.canliradyodinle.fm/wp-content/uploads/bayram-fm-100x100.jpg",
    },
    {
      "title": "Berat FM",
      "url": "https://beratfm.80.yayin.com.tr/;",
      "icon": "https://www.canliradyodinle.fm/wp-content/uploads/berat-fm.jpg",
    },
    {
      "title": "Bizim Radyo",
      "url": "https://ip132.ozelip.com:7017/stream?",
      "icon":
          "https://www.canliradyodinle.fm/wp-content/uploads/bizim-radyo-istanbul.jpg",
    },
    {
      "title": "Diyanet Radyo",
      "url":
          "https://eustr76.mediatriple.net/videoonlylive/mtikoimxnztxlive/broadcast_5e3c1171d7d2a.smil/chunklist_b200000.m3u8",
      "icon":
          "https://www.canliradyodinle.fm/wp-content/uploads/Diyanet-Radyo-100x100.jpg",
    },
    {
      "title": "Dolunay FM",
      "url": "https://yayin2.canliyayin.org:10955/;stream/;stream.mp3",
      "icon":
          "https://www.canliradyodinle.fm/wp-content/uploads/dolunay-fm.jpg",
    },
    {
      "title": "Hedef Radyo",
      "url": "https://stream.rcast.net/200299",
      "icon":
          "https://www.canliradyodinle.fm/wp-content/uploads/hedef-radyo.jpg",
    },
    {
      "title": "Enderun FM",
      "url": "https://yayin2.canliyayin.org:10996/;",
      "icon":
          "https://www.canliradyodinle.fm/wp-content/uploads/enderun-fm.jpg",
    },
    {
      "title": "Moral FM",
      "url":
          "https://stream-51.zeno.fm/0cfiqwdkobavv?zs=RptTdDEHQ2Wej62cArILjQ/;stream.mp3",
      "icon":
          "https://www.canliradyodinle.fm/wp-content/uploads/radyo-moral-fm.jpg",
    },
    {
      "title": "Lalegül FM",
      "url": "https://icecast.netmedya.net/lalegulfm",
      "icon":
          "https://www.canliradyodinle.fm/wp-content/uploads/lalegul-fm.jpg",
    },
  ];

  @override
  void onInit() {
    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {});
    interstitalAdCheck();
    initRadioPlayer(radios[0]["title"], radios[0]["url"]);
    super.onInit();
  }

  @override
  void onClose() {
    radioPlayer.pause();
    radioIndex.value = 0;
    radioPlayer.pause();
    super.onClose();
  }

  setRadioIndex(int index) {
    if (radioIndex == index && isPlaying.value) {
      radioPlayer.pause();
      return;
    }
    interstitalAdCheckIn();
    radioPlayer.pause();
    radioIndex.value = index;
    initRadioPlayer(radios[index]["title"], radios[index]["url"]);
    Timer(const Duration(seconds: 1), () {
      radioPlayer.play();
    });
  }

  changeRadioIndex(bool next) {
    interstitalAdCheckIn();
    radioPlayer.pause();
    if (next == true) {
      if (radios.length - 1 != radioIndex.value) {
        radioIndex.value++;
        initRadioPlayer(
            radios[radioIndex.value]["title"], radios[radioIndex.value]["url"]);
      } else {
        radioIndex.value = 0;
        initRadioPlayer(
            radios[radioIndex.value]["title"], radios[radioIndex.value]["url"]);
      }
    } else {
      if (radioIndex.value != 0) {
        radioIndex.value--;
        initRadioPlayer(
            radios[radioIndex.value]["title"], radios[radioIndex.value]["url"]);
      } else {
        radioIndex.value = radios.length - 1;
        initRadioPlayer(
            radios[radioIndex.value]["title"], radios[radioIndex.value]["url"]);
      }
    }
    Timer(const Duration(seconds: 1), () {
      radioPlayer.play();
    });
  }

  void initRadioPlayer(String title, String url) {
    radioPlayer.setChannel(
      title: title,
      url: url,
      // imagePath: 'assets/cover.jpg',
    );
    // void initRadioPlayer() {
    //   radioPlayer.setChannel(
    //     title: 'Radio Player',
    //     url: 'https://api-tv5.yayin.com.tr:8002/mp3',
    //     // imagePath: 'assets/cover.jpg',
    //   );

    radioTitle.value = title;
    radioPlayer.stateStream.listen((value) {
      isPlaying.value = value;
    });

    radioPlayer.metadataStream.listen((value) {
      metadata.value = value;
    });
  }

  interstitalAdCheck() async {
    final box = Get.find<GetStorage>();
    if (box.hasData("interstitialAdRadioPage")) {
      if (box.read("interstitialAdRadioPage") == 4) {
        AdsHelper().loadInterstitialAd();
        await box.write("interstitialAdRadioPage", 1);
      } else {
        var count = box.read("interstitialAdRadioPage");
        await box.write("interstitialAdRadioPage", count + 1);
      }
    } else {
      await box.write("interstitialAdRadioPage", 1);
    }
  }

  interstitalAdCheckIn() async {
    final box = Get.find<GetStorage>();
    if (box.hasData("interstitialAdRadioPageIn")) {
      if (box.read("interstitialAdRadioPageIn") == 4) {
        AdsHelper().loadInterstitialAd();
        await box.write("interstitialAdRadioPageIn", 1);
      } else {
        var count = box.read("interstitialAdRadioPageIn");
        await box.write("interstitialAdRadioPageIn", count + 1);
      }
    } else {
      await box.write("interstitialAdRadioPageIn", 1);
    }
  }
}
