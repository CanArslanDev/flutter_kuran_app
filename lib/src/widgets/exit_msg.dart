import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_app/helper/ads.dart';

class ExitMsg {
  BannerAd? myBanner;
  Future<bool> msg(BuildContext context) async {
    myBanner = AdsHelper.square();
    await myBanner!.load().then((value) {});
    Get.dialog(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3 * 2.5,
                height: 400,
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "cikisyap".tr(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      myBanner != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AdWidget(ad: myBanner!),
                                    width: myBanner!.size.width.toDouble(),
                                    height: myBanner!.size.height.toDouble(),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "cikissoru".tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("hayir".tr())),
                          OutlinedButton(
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                              child: Text("evet".tr()))
                        ],
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return false;
  }
}
