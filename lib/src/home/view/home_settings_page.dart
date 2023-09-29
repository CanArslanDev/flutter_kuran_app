import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/home_controller.dart';

class HomePageSettings extends StatefulWidget {
  const HomePageSettings({Key? key}) : super(key: key);

  @override
  State<HomePageSettings> createState() => _HomePageSettingsState();
}

class _HomePageSettingsState extends State<HomePageSettings> {
  final homeC = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ana Sayfa Ayarları"),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Obx(() => Container(
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 20, // changes position of shadow
                        )
                      ]),
                  child: Column(children: [
                    switchWidget("Hikayeler", homeC.homePageStoryCard.value,
                        () async {
                      await homeC.box.write(
                          'homePageStoryCard', !homeC.homePageStoryCard.value);
                      homeC.homePageStoryCard.value =
                          !homeC.homePageStoryCard.value;
                    }),
                    switchWidget(
                        "Namaz Saatleri", homeC.homePagePrayerCard.value,
                        () async {
                      await homeC.box.write('homePagePrayerCard',
                          !homeC.homePagePrayerCard.value);
                      homeC.homePagePrayerCard.value =
                          !homeC.homePagePrayerCard.value;
                    }),
                    switchWidget(
                        "Cuma Mesajları", homeC.homePageFridayCard.value,
                        () async {
                      await homeC.box.write('homePageFridayCard',
                          !homeC.homePageFridayCard.value);
                      homeC.homePageFridayCard.value =
                          !homeC.homePageFridayCard.value;
                    }),
                    switchWidget("İslami Yarışma", homeC.homePageQuizCard.value,
                        () async {
                      await homeC.box.write(
                          'homePageQuizCard', !homeC.homePageQuizCard.value);
                      homeC.homePageQuizCard.value =
                          !homeC.homePageQuizCard.value;
                    }),
                    switchWidget(
                        "Tarihi Yarışma", homeC.homePageQuizHistoryCard.value,
                        () async {
                      await homeC.box.write('homePageQuizHistoryCard',
                          !homeC.homePageQuizHistoryCard.value);
                      homeC.homePageQuizHistoryCard.value =
                          !homeC.homePageQuizHistoryCard.value;
                    }),
                    switchWidget("Kuran Okuma", homeC.homePageKuranCard.value,
                        () async {
                      await homeC.box.write(
                          'homePageKuranCard', !homeC.homePageKuranCard.value);
                      homeC.homePageKuranCard.value =
                          !homeC.homePageKuranCard.value;
                    }),
                    switchWidget("Tesbihat", homeC.homePageTesbihatCard.value,
                        () async {
                      await homeC.box.write('homePageTesbihatCard',
                          !homeC.homePageTesbihatCard.value);
                      homeC.homePageTesbihatCard.value =
                          !homeC.homePageTesbihatCard.value;
                    }),
                    switchWidget("İslami Kitaplar", homeC.homePagePDFCard.value,
                        () async {
                      await homeC.box.write(
                          'homePagePDFCard', !homeC.homePagePDFCard.value);
                      homeC.homePagePDFCard.value =
                          !homeC.homePagePDFCard.value;
                    }),
                    switchWidget(
                        "İslami Paylaşımlar", homeC.homePagePostCard.value,
                        () async {
                      await homeC.box.write(
                          'homePagePostCard', !homeC.homePagePostCard.value);
                      homeC.homePagePostCard.value =
                          !homeC.homePagePostCard.value;
                    }),
                    switchWidget("Günün Ayeti", homeC.homePageAyetCard.value,
                        () async {
                      await homeC.box.write(
                          'homePageAyetCard', !homeC.homePageAyetCard.value);
                      homeC.homePageAyetCard.value =
                          !homeC.homePageAyetCard.value;
                    }),
                    switchWidget("Radyo", homeC.homePageRadioCard.value,
                        () async {
                      await homeC.box.write(
                          'homePageRadioCard', !homeC.homePageRadioCard.value);
                      homeC.homePageRadioCard.value =
                          !homeC.homePageRadioCard.value;
                    }),
                    switchWidget(
                        "Esmaül Hüsna", homeC.homePageEsmaulhusnaCard.value,
                        () async {
                      await homeC.box.write('homePageEsmaulhusnaCard',
                          !homeC.homePageEsmaulhusnaCard.value);
                      homeC.homePageEsmaulhusnaCard.value =
                          !homeC.homePageEsmaulhusnaCard.value;
                    }),
                    switchWidget("Bebek İsimleri", homeC.homePageBabyCard.value,
                        () async {
                      await homeC.box.write(
                          'homePageBabyCard', !homeC.homePageBabyCard.value);
                      homeC.homePageBabyCard.value =
                          !homeC.homePageBabyCard.value;
                    }),
                    switchWidget(
                        "Günün Sorusu", homeC.homePageQuestionCard.value,
                        () async {
                      await homeC.box.write('homePageQuestionCard',
                          !homeC.homePageQuestionCard.value);
                      homeC.homePageQuestionCard.value =
                          !homeC.homePageQuestionCard.value;
                    }),
                    switchWidget("İslami Resim", homeC.homePageImageCard.value,
                        () async {
                      await homeC.box.write(
                          'homePageImageCard', !homeC.homePageImageCard.value);
                      homeC.homePageImageCard.value =
                          !homeC.homePageImageCard.value;
                    }),
                  ]),
                )),
          ],
        ));
  }

  switchWidget(String title, bool switchValue, VoidCallback callback) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 20,
                ),
              ),
              Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                      value: switchValue,
                      onChanged: (value) {
                        callback();
                      })),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
