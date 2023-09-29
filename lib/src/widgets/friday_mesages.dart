import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/src/quran/view/background_page.dart';
import 'package:quran_app/src/widgets/app_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';
import 'package:get_storage/get_storage.dart';

import '../../helper/ads.dart';
import '../quran/view/friday_messages_page.dart';
import '../settings/theme/app_theme.dart';

class FridayMessages extends StatelessWidget {
  const FridayMessages({Key? key, required this.fridayControl})
      : super(key: key);
  final bool fridayControl;
  @override
  Widget build(BuildContext context) {
    initializeJson() async {
      String response =
          await rootBundle.loadString('assets/cuma_mesajlari.json');
      return await json.decode(response);
    }

    int weekNumber(DateTime date) {
      int dayOfYear = int.parse(DateFormat("D").format(date));
      return ((dayOfYear - date.weekday + 10) / 7).floor();
    }

    String day = DateFormat('EEEE', "en").format(DateTime.now());

    return Container(
      child: (day != "Friday" && fridayControl == true)
          ? Container()
          : FutureBuilder(
              future: initializeJson(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("1");
                  Map dataTemp = snapshot.data as Map;
                  List data = dataTemp['data'];
                  int dataLength = data.length;
                  double index = (weekNumber(DateTime.now()) * dataLength) / 52;
                  print("data lenght $dataLength ${data[index.toInt()]}");
                  return Visibility(
                    visible: context.locale.toLanguageTag() == "tr",
                    child: FadeInLeft(
                      from: 50,
                      child: AppCard(
                        vPadding: 16,
                        vMargin: fridayControl == false ? 5 : 10,
                        hMargin: fridayControl == false ? 5 : 20,
                        border: Border.all(color: Colors.blue, width: 2),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      UniconsLine.book_open,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "cumamesaji".tr(),
                                      style: AppTextStyle.small.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () => Get.to(BackgroundPage(
                                              titleTr: data[index.toInt()],
                                              numberOfVerses: "0",
                                              surahName: "",
                                              title: "",
                                            )),
                                        child: Image.asset(
                                          "assets/share_arrow.png",
                                          height: 23,
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () => Share.share(
                                        data[index.toInt()],
                                      ),
                                      child: const Icon(
                                        Icons.share,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "assets/cuma_mesaj_bg.png",
                                    )),
                                Positioned.fill(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                          begin: Alignment.centerRight,
                                          end: Alignment.centerLeft,
                                          colors: [
                                            Colors.white.withOpacity(0),
                                            Colors.white.withOpacity(0.8),
                                            Colors.white,
                                          ])),
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 11.0),
                                  child: Text(
                                    data[index.toInt()],
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            fridayControl == false ? 15 : 20),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  interstitalAdCheck();
                                  Get.to(const FridayMessagePage());
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                      child: Text(
                                    "tummesajlar".tr(),
                                    style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
    );
  }

  interstitalAdCheck() async {
    final box = Get.find<GetStorage>();
    if (box.hasData("interstitialAdFridayMessages")) {
      if (box.read("interstitialAdFridayMessages") == 4) {
        AdsHelper().loadInterstitialAd();
        await box.write("interstitialAdFridayMessages", 1);
      } else {
        var count = box.read("interstitialAdFridayMessages");
        await box.write("interstitialAdFridayMessages", count + 1);
      }
    } else {
      await box.write("interstitialAdFridayMessages", 1);
    }
  }
}
