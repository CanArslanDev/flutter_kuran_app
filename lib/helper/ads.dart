// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Widget getAd() {
  BannerAdListener bannerAdListener =
      BannerAdListener(onAdWillDismissScreen: (ad) {
    ad.dispose();
  }, onAdClosed: (ad) {
    debugPrint("Ad Got Closeed");
  });
  BannerAd bannerAd = BannerAd(
    size: AdSize.banner,
    adUnitId: "ca-app-pub-4828471636798994/2952854754",
    listener: bannerAdListener,
    request: const AdRequest(),
  );

  bannerAd.load();

  return SizedBox(
    height: 50,
    child: AdWidget(ad: bannerAd),
  );
}

Widget listItem(int index) {
  return ListTile(
    title: Text("Item No $index"),
    subtitle: Text("This item is at $index"),
  );
}

class AdsHelper {
  static AppOpenAd? openAd;
  static InterstitialAd? interstitalAd;
  //RewardedAd? rewardedAd;
  bool isShowReward = false;

  final adRewardedUnitId = Platform.isAndroid
      ? "ca-app-pub-4828471636798994/7468570136"
      : kDebugMode == true
          ? 'ca-app-pub-3940256099942544/1712485313'
          : "";

  static banner() {
    return BannerAd(
      adUnitId: 'ca-app-pub-4828471636798994/2952854754',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }

  static BannerAd square() {
    return BannerAd(
      adUnitId: 'ca-app-pub-4828471636798994/2952854754',
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }

  static Future<void> loadOpenAd() async {
    await AppOpenAd.load(
        adUnitId: 'ca-app-pub-4828471636798994/8062120634',
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
          print('ad is loaded');
          openAd = ad;
          //openAd!.show();
        }, onAdFailedToLoad: (error) {
          print('ad failed to load $error');
        }),
        orientation: AppOpenAd.orientationPortrait);
  }

  static showOpenAd() async {
    openAd!.show();
  }

  Future<bool> loadInterstitialAd() async {
    bool isFinish = false;
    await InterstitialAd.load(
      adUnitId: "ca-app-pub-4828471636798994/7682437259",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) async {
          interstitalAd = ad;
          await interstitalAd!.show();
          isFinish = true;
          isShowReward = true;
        },
        onAdFailedToLoad: (error) {
          print('ad failed to load $error');
        },
      ),
    );
    return isFinish;
  }

  // static Future<void> loadRewardedAd() async {
  //   await InterstitialAd.load(
  //     adUnitId: "ca-app-pub-4828471636798994/7682437259",
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         interstitalAd = ad;
  //         interstitalAd!.show();
  //       },
  //       onAdFailedToLoad: (error) {
  //         print('ad failed to load $error');
  //       },
  //     ),
  //   );
  // }

  // loadRewardedAd() {
  //   return RewardedAd.load(
  //       adUnitId: adRewardedUnitId,
  //       request: const AdRequest(),
  //       rewardedAdLoadCallback: RewardedAdLoadCallback(
  //         onAdLoaded: (ad) {
  //           rewardedAd = ad;
  //           rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
  //             onAdShowedFullScreenContent: (ad) => ad.dispose(),
  //             onAdFailedToShowFullScreenContent: (ad, error) {
  //               ad.dispose();
  //             },
  //           );
  //           _onReady(ad);
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           if (kDebugMode) {
  //             print('Ad failed to load: $error');
  //           }
  //         },
  //       ));
  // }

  // Future<bool> showRewardedAd(Function(RewardedAd ad) onReady) async {
  //   _onReady = onReady;

  //   bool _isShow = false;

  //   await rewardedAd!.show(
  //     onUserEarnedReward: (AdWithoutView ads, reward) async {
  //       if (kDebugMode) {
  //         print('User earned reward: ${reward.amount}');
  //       }
  //       rewardedAd!.fullScreenContentCallback = null;
  //       // ad.fullScreenContentCallback = null;
  //       _isShow = true;
  //     },
  //   );
  //   return _isShow;
  // }

/*static void showAd() async{
    if(openAd == null) {
      print('trying tto show before loading');
      loadAd();
      return;
    }

    openAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print('onAdShowedFullScreenContent');
        },
        onAdFailedToShowFullScreenContent: (ad, error){
          ad.dispose();
          print('failed to load $error');
          openAd = null;
          loadAd();
        },
        onAdDismissedFullScreenContent: (ad){
          ad.dispose();
          print('dismissed');
          openAd = null;
          loadAd();
        }
    );

    openAd!.show();
  }*/
}
