import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/src/quran/view/background_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';

import '../../settings/theme/app_theme.dart';
import '../../widgets/app_card.dart';

class FridayMessagePage extends StatelessWidget {
  const FridayMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeJson() async {
      String response =
          await rootBundle.loadString('assets/cuma_mesajlari.json');
      return await json.decode(response);
    }

    List<Color> colorList = [
      Colors.cyan,
      Colors.blue,
      Colors.pink,
      Colors.amber,
      Colors.purple,
      Colors.deepPurple,
      Colors.brown,
      Colors.orange,
      Colors.indigo,
      Colors.lime,
      Colors.red,
      Colors.teal,
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "cumamesaji".tr(),
            style: AppTextStyle.bigTitle,
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: initializeJson(),
            builder: (context, snapshot) {
              Map dataTemp = snapshot.data as Map;
              List data = dataTemp['data'];
              if (snapshot.hasData) {
                return Column(
                  children: [
                    for (int i = 0; i < data.length; i++)
                      Visibility(
                        visible: context.locale.toLanguageTag() == "tr",
                        child: FadeInLeft(
                          from: 50,
                          child: AppCard(
                            vPadding: 16,
                            vMargin: 10,
                            border: Border.all(
                                color: colorList[
                                    Random().nextInt(colorList.length)],
                                width: 2),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                  titleTr: data[i],
                                                  numberOfVerses: "0",
                                                  surahName: "0",
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
                                            data[i],
                                          ),
                                          child: const Icon(
                                            Icons.share,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Positioned.fill(
                                        child: Container(
                                      decoration: BoxDecoration(
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
                                        data[i],
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ));
  }
}
