// ignore_for_file: library_prefixes, duplicate_ignore

import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quran_app/services/supabase_service.dart';
import 'package:quran_app/src/quran/controller/audio_player_controller.dart';
import 'package:quran_app/src/quran/view/background_page.dart';
import 'helper/ads.dart';
// ignore: library_prefixes
import 'datas/list_tr.dart' as TR;
// ignore: library_prefixes
import 'datas/list_en.dart' as EN;
import 'datas/list_fr.dart' as FR;
import 'datas/list_de.dart' as DE;

class HusnaPage extends StatefulWidget {
  const HusnaPage({Key? key}) : super(key: key);

  @override
  State<HusnaPage> createState() => _HusnaPageState();
}

class _HusnaPageState extends State<HusnaPage> {
  List<String> name = [];
  List<String> meaning = [];
  BannerAd? myBanner;
  final esmaulhusna = 'esmaulhusna'.tr();

  final audioPlayerController = Get.put(AudioPlayerController());
  var audioPlayer = AudioPlayer();
  var langGet = (window.locale.languageCode == "tr"
      ? TR.data
      : window.locale.languageCode == "fr"
          ? FR.data
          : window.locale.languageCode == "de"
              ? DE.data
              : EN.data);

  @override
  void initState() {
    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {
      setState(() {});
    });

    langGet.forEach((key, value) {
      name.add(key);
      meaning.add(value);
    });
    audioPlayer.onPlayerStateChanged.listen((event) {
      audioPlayerController.playerState.value = event;
    });
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: myBanner != null
            ? Container(
                alignment: Alignment.center,
                child: AdWidget(ad: myBanner!),
                width: myBanner!.size.width.toDouble(),
                height: myBanner!.size.height.toDouble(),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
        appBar: AppBar(
          title: const Text("esmaulhusna"),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            color: Colors.black,
            endIndent: 16,
            indent: 16,
          ),
          itemCount: 99,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  Container(
                    height: 60,
                    width: 350,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 0.1,
                              blurRadius: 20)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Esmaül Hüsna Dinle",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            if (audioPlayerController.playerState.value ==
                                PlayerState.playing) {
                              audioPlayer.pause();
                            } else if (audioPlayerController
                                    .playerState.value ==
                                PlayerState.paused) {
                              audioPlayer.resume();
                            } else {
                              audioPlayer.resume();
                              String? soundUrl = await SupabaseService()
                                  .getSurahSound("Esmaül Hüsna");
                              audioPlayer.play(UrlSource(soundUrl!));
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey)),
                            child: Icon(
                              audioPlayerController.playerState.value ==
                                      PlayerState.paused
                                  ? Icons.play_arrow_rounded
                                  : audioPlayerController.playerState.value ==
                                          PlayerState.stopped
                                      ? Icons.play_arrow_rounded
                                      : Icons.pause,
                              size: 40,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(name[index]),
                    subtitle: Text(meaning[index]),
                  )
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(name[index]),
                  subtitle: Text(meaning[index]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: GestureDetector(
                      onTap: () => Get.to(BackgroundPage(
                            titleTr: '${name[index]} \n ${meaning[index]}',
                            numberOfVerses: "",
                            surahName: "",
                            title: "",
                            viewSurahName: true,
                          )),
                      child: Image.asset(
                        "assets/share_arrow.png",
                        height: 23,
                      )),
                ),
              ],
            );
          },
        ));
  }
}
