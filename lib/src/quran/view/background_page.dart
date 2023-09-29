import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/services/supabase_service.dart';
import 'package:quran_app/src/purchase/views/in_app_purchase_page.dart';
import 'package:quran_app/src/quran/view/verse_share_page.dart';

import '../../profile/controllers/user_controller.dart';

class BackgroundPage extends StatefulWidget {
  const BackgroundPage(
      {Key? key,
      required this.title,
      required this.titleTr,
      required this.surahName,
      required this.numberOfVerses,
      this.viewSurahName})
      : super(key: key);
  final String title;
  final String titleTr;
  final String surahName;
  final String numberOfVerses;
  final bool? viewSurahName;
  @override
  State<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
  final userC = Get.put(UserControllerImpl());
  ValueNotifier<bool> upgradeAccount = ValueNotifier(false);
  List bgList = [
    "assets/verseBackgrounds/muslim-bg1.png",
    "assets/verseBackgrounds/muslim-bg2.png",
    "assets/verseBackgrounds/muslim-bg3.png",
    "assets/verseBackgrounds/muslim-bg4.png",
    "assets/verseBackgrounds/muslim-bg5.png",
    "assets/verseBackgrounds/muslim-bg6.png",
    "assets/verseBackgrounds/muslim-bg7.png",
    "assets/verseBackgrounds/muslim-bg8.png",
    "assets/verseBackgrounds/muslim-bg9.jpg",
    "assets/verseBackgrounds/muslim-bg10.png",
    "assets/verseBackgrounds/muslim-bg11.jpg",
    "assets/verseBackgrounds/muslim-bg12.jpg",
    "assets/verseBackgrounds/muslim-bg13.jpg",
    "assets/verseBackgrounds/muslim-bg14.jpg",
    "assets/verseBackgrounds/muslim-bg15.jpg",
    "assets/verseBackgrounds/muslim-bg16.jpg",
    "assets/verseBackgrounds/muslim-bg17.jpg",
    "assets/verseBackgrounds/muslim-bg18.jpg",
    "assets/verseBackgrounds/muslim-bg19.jpg",
    "assets/verseBackgrounds/muslim-bg20.jpg",
    "assets/verseBackgrounds/muslim-bg21.jpg",
    "assets/verseBackgrounds/muslim-bg22.jpg",
    "assets/verseBackgrounds/muslim-bg23.jpg",
    "assets/verseBackgrounds/muslim-bg24.jpg",
    "assets/verseBackgrounds/muslim-bg25.jpg",
    "assets/verseBackgrounds/muslim-bg26.jpg",
    "assets/verseBackgrounds/muslim-bg26.jpg",
    "assets/verseBackgrounds/muslim-bg27.jpg",
    "assets/verseBackgrounds/muslim-bg28.jpg",
    "assets/verseBackgrounds/muslim-bg29.jpg",
    "assets/verseBackgrounds/muslim-bg30.jpg",
    "assets/verseBackgrounds/muslim-bg31.jpg",
    "assets/verseBackgrounds/muslim-bg32.jpg",
    "assets/verseBackgrounds/muslim-bg33.jpg",
    "assets/verseBackgrounds/muslim-bg34.jpg",
    "assets/verseBackgrounds/muslim-bg35.jpg",
    "assets/verseBackgrounds/muslim-bg36.jpg",
    "assets/verseBackgrounds/muslim-bg37.jpg",
    "assets/verseBackgrounds/muslim-bg38.jpg",
    "assets/verseBackgrounds/muslim-bg39.jpg",
    "assets/verseBackgrounds/muslim-bg40.jpg",
    "assets/verseBackgrounds/muslim-bg41.jpg",
    "assets/verseBackgrounds/muslim-bg42.jpg",
    "assets/verseBackgrounds/muslim-bg43.jpg",
    "assets/verseBackgrounds/muslim-bg44.jpg",
    "assets/verseBackgrounds/muslim-bg45.jpg",
    "assets/verseBackgrounds/muslim-bg46.jpg",
    "assets/verseBackgrounds/muslim-bg47.jpg",
    "assets/verseBackgrounds/muslim-bg48.jpg",
    "assets/verseBackgrounds/muslim-bg49.jpg",
    "assets/verseBackgrounds/muslim-bg50.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    fetchImages();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "background".tr(),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Center(
              child: Wrap(
            children: [
              for (int i = 0; i < bgList.length; i++)
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      if (i == 0 || i == 1 || upgradeAccount.value == true) {
                        Get.to(VerseSharePage(),
                            arguments: (widget.viewSurahName == true)
                                ? [
                                    bgList[i],
                                    widget.title,
                                    widget.titleTr,
                                    widget.surahName,
                                    widget.numberOfVerses,
                                    widget.viewSurahName
                                  ]
                                : [
                                    bgList[i],
                                    widget.title,
                                    widget.titleTr,
                                    widget.surahName,
                                    widget.numberOfVerses
                                  ]);
                      } else {
                        Get.to(const InAppPurchasePage());
                      }
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              bgList[i],
                              width: MediaQuery.of(context).size.width / 2.22,
                            )),
                        Positioned.fill(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 8),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.asset(
                                      "assets/icon/icon.png",
                                      height: Get.height / 40,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3.0),
                                    child: Text(
                                      "meal".tr(),
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                            child: Center(
                          child: upgradeAccount.value
                              ? null
                              : Icon(
                                  Icons.lock,
                                  size: 40,
                                  color: Colors.grey.shade300.withOpacity(i == 0
                                      ? 0
                                      : i == 1
                                          ? 0
                                          : 1),
                                ),
                        ))
                      ],
                    ),
                  ),
                ),
            ],
          )),
        ),
      ),
    );
  }

  fetchImages() async {
    if (userC.user.id != null) {
      upgradeAccount.value = SupabaseService().getPurchase();
    }
  }
}
