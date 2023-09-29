import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../helper/ads.dart';

class MainPageController extends GetxController with WidgetsBindingObserver {
  BannerAd? myBanner;
  Rx<bool> isPaused = false.obs;
  Rx<int> index = 0.obs;
  @override
  void onInit() {
    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {});
    AdsHelper.loadOpenAd();
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused.value = true;
    }
    if (state == AppLifecycleState.resumed && isPaused.value) {
      print("Resumed==========================");
      AdsHelper.showOpenAd();
      AdsHelper.loadOpenAd();
      isPaused.value = false;
    }
  }
}
