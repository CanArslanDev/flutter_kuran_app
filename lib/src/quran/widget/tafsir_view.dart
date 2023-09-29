// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:quran_app/src/quran/controller/surah_controller.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';

class TafsirView extends StatelessWidget {
  TafsirView({Key? key, required this.closeShow, this.surahId, this.verseId}) : super(key: key);
  final int? surahId;
  final int? verseId;
  final void Function() closeShow;

  final controller = Get.find<SurahController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      maxChildSize: 0.95,
      minChildSize: 0.25,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: closeShow,
                icon: const Icon(
                  Icons.highlight_remove_rounded,
                  size: 30,
                  color: Colors.red,
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TabBar(
                            labelColor: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white,
                            tabs: [
                          Tab(text: "kelimeler".tr(),),
                          Tab(text: "ceviriler".tr()),
                        ]),
                        Flexible(
                          child: TabBarView(children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "#",
                                              style: AppTextStyle.normal.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              "kelime",
                                              style: AppTextStyle.normal.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "anlam".tr(),
                                              style: AppTextStyle.normal.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              "kok".tr(),
                                              style: AppTextStyle.normal.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  FutureBuilder(
                                      future: controller.words.isEmpty ? controller.fetchWordsOfVerse(surahId, verseId) : null,
                                      builder: (context, snap) {
                                        if (snap.hasData) {
                                          return Column(
                                            children: [
                                              for (var data in controller.words)
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(data.sortNumber!.toString()),
                                                            Text(data.transcription!),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(child: Text(data.turkish!)),
                                                            Text(data.root!),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            ],
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      }),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FutureBuilder(
                                      future: controller.translations.isEmpty ? controller.fetchTranslationsOfVerse(surahId, verseId) : null,
                                      builder: (context, snap) {
                                        if (snap.hasData) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              for(var data in controller.translations)
                                                Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(child: Text(data.author!.name!,style: TextStyle(fontWeight: FontWeight.bold),)),
                                                        Expanded(child: Text(data.author!.description != null ? data.author!.description! :  "",style: TextStyle(fontWeight: FontWeight.w100),)),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20,),
                                                    Text(data.text!.replaceAll(RegExp('\\[.*?\\]'), '')),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                      child: Divider(),
                                                    )
                                                  ],
                                                )
                                            ],
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*
Flexible(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Text(
                        "Tafsir Ayat ke - $numberInSurah",
                        style: AppTextStyle.title,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "$textTafsir",
                          style: AppTextStyle.normal.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
*/
