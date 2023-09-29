// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:quran_app/src/quran/controller/surah_controller.dart';
import 'package:quran_app/src/quran/model/verse.dart';
import 'package:quran_app/src/quran/widget/tafsir_view.dart';
import 'package:quran_app/src/quran/widget/verse_item.dart';
import 'package:unicons/unicons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../bricks/my_widgets/input_text.dart';
import '../../settings/theme/app_theme.dart';

class SearchQuranPage extends StatefulWidget {
  SearchQuranPage({Key? key}) : super(key: key);

  static const routeName = '/search-quran';

  @override
  State<SearchQuranPage> createState() => _SearchQuranPageState();
}

class _SearchQuranPageState extends State<SearchQuranPage> {
  final _search = TextEditingController();

  final controller = Get.find<SurahController>();

  Widget tafsirView = const SizedBox();

  final List<String> popularSearch = [
    "cuz".tr(),
    "sayfa".tr(),
    "sure".tr(),
    "diger".tr()
  ];
  final List<String> juz = [];
  final List<String> page = [];
  final List<String> surah = [];

  String? selectedJuz;
  String? selectedPage;
  String? selectedSurah;

  @override
  void initState() {
    for (int i = 1; i < 30; i++) {
      juz.add("$i. " + "cuz".tr());
    }
    for (int i = 1; i < 603; i++) {
      page.add("$i. " + "sayfa".tr());
    }
    for (var item in controller.listOfSurah) {
      surah.add("${item.number}. ${item.name!}");
    }
    super.initState();
  }

  String? selectedItem = "";

  @override
  Widget build(BuildContext context) {
    //controller.resetListOfSearchedSurah();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ara".tr(),
          style: AppTextStyle.bigTitle,
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: selectedJuz,
                  items: juz
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  hint: Text("cuzsec".tr()),
                  onChanged: (a) {
                    setState(() {
                      selectedItem = "cuz".tr();
                      selectedJuz = a;
                      selectedPage = null;
                      selectedSurah = null;
                      controller.resetListOfSearchedSurah();
                      controller.searchSurah(a!.toLowerCase(), selectedItem!);
                    });
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                DropdownButton<String>(
                  value: selectedPage,
                  items: page
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  hint: Text("sayfasec".tr()),
                  onChanged: (a) {
                    setState(() {
                      selectedItem = "sayfa".tr();
                      selectedPage = a;
                      selectedJuz = null;
                      selectedSurah = null;
                      controller.resetListOfSearchedSurah();
                      controller.searchSurah(a!.toLowerCase(), selectedItem!);
                    });
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                DropdownButton<String>(
                  value: selectedSurah,
                  items: surah
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  hint: Text("suresec".tr()),
                  onChanged: (a) {
                    setState(() {
                      selectedItem = "sure".tr();
                      selectedSurah = a;
                      selectedJuz = null;
                      selectedPage = null;
                      controller.resetListOfSearchedSurah();
                      controller.searchSurah(a!.toLowerCase(), selectedItem!);
                    });
                  },
                ),
                /*for (var item in popularSearch)
                  InkWell(
                    onTap: () {
                      /*controller.resetListOfSearchedSurah();
                              _search.text = item;
                              controller
                                  .searchSurah(_search.text.trim().toLowerCase());*/
                      setState(() {
                        FocusScope.of(context).unfocus();
                        selectedItem = item;
                      });
                    },
                    child: Chip(
                      backgroundColor: Get.isDarkMode ? Theme.of(context).cardColor : null,
                      label: Text(
                        item,
                        style: AppTextStyle.small,
                      ),
                      avatar: item == selectedItem
                          ? CircleAvatar(
                              radius: 12,
                              child: Icon(Icons.check),
                            )
                          : null,
                    ),
                  ),*/
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
            ),
            child: InputText(
              textController: _search,
              keyboardType: selectedItem == "cuz".tr()
                  ? TextInputType.number
                  : selectedItem == "sayfa".tr()
                      ? TextInputType.number
                      : TextInputType.name,
              hintText: "buradaara".tr(),
              prefixIcon: Icon(
                UniconsLine.search,
                color: Theme.of(context).primaryColor,
              ),
              onChanged: (v) {
                setState(() {});
                controller.resetListOfSearchedSurah();
                controller.searchSurah(_search.text.toLowerCase(), "");
              },
            ),
          ),
          Obx(
            () => (controller.listOfSearchedVerse.isNotEmpty)
                ? const SizedBox(height: 20)
                : const SizedBox(height: 40),
          ),
          Obx(
            () => controller.listOfSearchedVerse.isNotEmpty
                ? Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          ListView.separated(
                            //shrinkWrap: true,
                            //physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return FadeInDown(
                                child: InkWell(
                                  highlightColor: Colors.white12,
                                  splashColor: Colors.white12,
                                  onTap: () {
                                    /*controller.setRecenlySurah(
                              controller.listOfSearchedVerse.toList()[i]);*/
                                    /* Get.to(
                            SurahDetailPage(
                              surah: controller.listOfSearchedVerse
                                  .toList()[i],
                            ),
                            routeName:
                                '/surah/${controller.listOfSearchedVerse.toList()[i].name!.toLowerCase()}',
                          );*/
                                  },
                                  child: VerseItem(
                                    surahName: controller.listOfSearchedVerse
                                        .toList()[i]
                                        .surahName,
                                    verseNumber: controller.listOfSearchedVerse
                                        .toList()[i]
                                        .verseNumber,
                                    verse: "",
                                    transcription: controller
                                        .listOfSearchedVerse
                                        .toList()[i]
                                        .transcription,
                                    textTranslation: controller
                                        .listOfSearchedVerse
                                        .toList()[i]
                                        .translation!
                                        .text,
                                    author: controller.listOfSearchedVerse
                                        .toList()[i]
                                        .translation!
                                        .author,
                                    onTapSeeTafsir: () {
                                      if (controller.showTafsir.value) {
                                        controller.showTafsir.value = false;
                                      }
                                      controller.showTafsir.value = true;
                                      _buildTafsirView(controller
                                          .listOfSearchedVerse
                                          .toList()[i]);
                                    },
                                    onTapSeeTefsir: () {
                                      if (controller.showTafsir.value) {
                                        controller.showTafsir.value = false;
                                      }
                                      controller.showTafsir.value = true;
                                      _buildTafsirView(controller
                                          .listOfSearchedVerse
                                          .toList()[i]);
                                    },
                                  ),
                                  /*child: SurahItem(
                          isSearch: true,
                          term: _search.text.trim(),
                          number: controller.listOfSerchedSurah
                              .toList()[i]
                              .number,
                          name: controller.listOfSerchedSurah
                              .toList()[i]
                              .name!,
                          numberOfVerses: controller.listOfSerchedSurah
                              .toList()[i]
                              .numberOfVerses,
                          nameOriginal: controller.listOfSerchedSurah.toList()[i].nameOriginal,
                        ),*/
                                ),
                              );
                            },
                            separatorBuilder: (context, i) =>
                                const SizedBox(height: 10),
                            itemCount: controller.listOfSearchedVerse.length,
                          ),
                          if (controller.showTafsir.value) tafsirView,
                        ],
                      ),
                    ),
                  )
                : Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/illustration/01-readTheQuran.png',
                            width: 250,
                          ),
                          Text(
                            // "What are you looking for?",
                            "sureokuma".tr(),
                            style: AppTextStyle.title,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          DefaultTextStyle(
                            style: AppTextStyle.normal.copyWith(
                              // color: ColorPalletes.bgDarkColor,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                TyperAnimatedText(
                                  // 'Text Quran',
                                  "yasin".tr(),
                                  speed: const Duration(milliseconds: 100),
                                ),
                                TyperAnimatedText(
                                  // 'Name of Surah',
                                  "maide".tr(),
                                  speed: const Duration(milliseconds: 100),
                                ),
                                TyperAnimatedText(
                                  "vakia".tr(),
                                  speed: const Duration(milliseconds: 100),
                                ),
                                TyperAnimatedText(
                                  'veyadiger'.tr(),
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _buildTafsirView(Verse verse) {
    tafsirView = TafsirView(
        surahId: verse.surahId,
        verseId: verse.verseNumber,
        closeShow: () {
          controller.showTafsir.value = false;
          controller.resetWords();
          controller.resetTranslations();
        });
  }
}
