import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:like_button/like_button.dart';
import 'package:quran_app/helper/ads.dart';
import 'package:quran_app/services/supabase_service.dart';
import 'package:quran_app/src/profile/controllers/user_controller.dart';
import 'package:quran_app/src/profile/views/signin_page.dart';
import 'package:quran_app/src/quran/controller/audio_player_controller.dart';
import 'package:quran_app/src/quran/controller/surah_controller.dart';
import 'package:quran_app/src/quran/model/surah.dart';
import 'package:quran_app/src/quran/model/translations.dart';
import 'package:quran_app/src/quran/model/verse.dart';
import 'package:quran_app/src/quran/view/player_settings_page.dart';
import 'package:quran_app/src/quran/view/surah_detail_settings_page.dart';
import 'package:quran_app/src/quran/widget/shimmer/surah_detail_page_shimmer.dart';
import 'package:quran_app/src/quran/widget/surah_card.dart';
import 'package:quran_app/src/quran/widget/tafsir_view.dart';
import 'package:quran_app/src/quran/widget/verse_item.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:quran_app/src/widgets/app_loading.dart';
import 'package:quran_app/src/widgets/forbidden_card.dart';
import 'package:quran_app/src/widgets/rate_msg.dart';
import 'package:unicons/unicons.dart';

import '../widget/tefsir_view.dart';

// ignore: must_be_immutable
class SurahDetailPage extends StatefulWidget {
  const SurahDetailPage({Key? key, required this.surah}) : super(key: key);
  final Surah surah;

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  final controller = Get.find<SurahController>();

  final userC = Get.put(UserControllerImpl());

  final audioPlayerController = Get.put(AudioPlayerController());
  final audioPlayerController2 = Get.put(AudioPlayerController());

  Widget tafsirView = const SizedBox();
  int tempAudioIndex = 0;
  int authorId = 102;
  List<Author> authorList = [];
  Author? author;
  bool hakkindaControl = false;
  bool nuzulControl = false;
  bool konuControl = false;
  bool faziletControl = false;
  ValueNotifier<int> widgetsControl = ValueNotifier(-1);
  String hakkinda = "";
  String nuzul = "";
  String konu = "";
  String fazilet = "";
  ValueNotifier<int> playButtonOpacity = ValueNotifier(0);
  var audioPlayer = AudioPlayer();
  var audioPlayer2 = AudioPlayer();
  BannerAd? myBanner;
  bool firstOpening = false;
  SupabaseService supabase = SupabaseService();
  bool favorite = false;
  Duration position = const Duration();
  ValueNotifier<double> positionSecond = ValueNotifier(0);
  ValueNotifier<double> durationSecond = ValueNotifier(0);
  ValueNotifier<double> playback = ValueNotifier(1.0);
  Duration duration = const Duration();
  ScrollController _scrollController = ScrollController();
  _scrollListener() {
    if (_scrollController.position.pixels.toInt() >= 118 &&
        _scrollController.position.pixels.toInt() <= 168) {
      playButtonOpacity.value =
          (_scrollController.position.pixels.toInt() - 118) * 2;
    } else if (_scrollController.position.pixels.toInt() < 118) {
      playButtonOpacity.value = 0;
    } else {
      playButtonOpacity.value = 100;
    }
  }

  @override
  void initState() {
    initDatabaseData();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    if (window.locale.languageCode == "tr") {
      setState(() {
        authorId = 105;
      });
    }
    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {
      setState(() {});
    });
    authorList = controller.listOfAuthor.toList();
    audioPlayer.onPlayerStateChanged.listen((event) {
      audioPlayerController.playerState.value = event;
    });
    audioPlayer2.onPlayerStateChanged.listen((event) {
      audioPlayerController2.playerState.value = event;
    });
    audioPlayer.onDurationChanged.listen((Duration p) {
      duration = p;
      durationSecond.value = duration.inMilliseconds.toDouble();
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      if (controller.audioName.value !=
              "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}" ||
          tempAudioIndex != controller.verseSoundIndex.value) {
        tempAudioIndex = controller.verseSoundIndex.value;
        audioPlayer.stop();
        controller.audioName.value =
            "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";
        Timer(
            const Duration(milliseconds: 300),
            () => audioPlayer.play(UrlSource(controller.verseSounds["content"]
                [controller.verseSoundIndex.value])));
      }
      position = p;
      positionSecond.value = position.inMilliseconds.toDouble();
    });
    audioPlayer.onPlayerComplete.listen((event) {
      int count = 0;
      if (controller.verseSoundRepeatIndex.value == 1) {
        count = 2;
      } else if (controller.verseSoundRepeatIndex.value == 2) {
        count = 3;
      } else if (controller.verseSoundRepeatIndex.value == 3) {
        count = 5;
      } else if (controller.verseSoundRepeatIndex.value == 4) {
        count = 10;
      }

      controller.verseSoundRepeatControllerIndex.value++;
      if (controller.verseSoundRepeatControllerIndex.value < count &&
          count != 0) {
        positionSecond.value = 0;
        tempAudioIndex = controller.verseSoundIndex.value;
        audioPlayer.stop();
        Timer(const Duration(milliseconds: 300), () {
          controller.audioName.value =
              "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";
          audioPlayer.play(UrlSource(controller.verseSounds["content"]
              [controller.verseSoundIndex.value]));
        });
      } else {
        if (controller.nextSound.value == true) {
          positionSecond.value = 0;
          if (controller.verseSoundIndex.value ==
              controller.verseSounds['names'].length) {
            controller.verseSoundIndex.value = 0;
          } else {
            controller.verseSoundIndex.value++;
          }
          controller.verseSoundRepeatControllerIndex.value = 0;
          tempAudioIndex = controller.verseSoundIndex.value;
          audioPlayer.stop();
          Timer(const Duration(milliseconds: 300), () {
            controller.audioName.value =
                "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";
            audioPlayer.play(UrlSource(controller.verseSounds["content"]
                [controller.verseSoundIndex.value]));
          });
        }
        controller.verseSoundRepeatControllerIndex.value = 0;
      }
    });
    getApiAbout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final box = Get.find<GetStorage>();
        if (box.hasData("rateMsgSurahDetailPage")) {
          if (box.read("rateMsgSurahDetailPage") == 20) {
            RateMsg().msg();
            await box.write("rateMsgSurahDetailPage", 1);
          } else {
            var count = box.read("rateMsgSurahDetailPage");
            await box.write("rateMsgSurahDetailPage", count + 1);
          }
        } else {
          await box.write("rateMsgSurahDetailPage", 1);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "kuran".tr(),
            style: AppTextStyle.bigTitle,
          ),
          actions: [
            ValueListenableBuilder(
              valueListenable: playButtonOpacity,
              builder: (context, int value, child) => SizedBox(
                child: value == 0
                    ? Container()
                    : IconButton(
                        onPressed: () {
                          if (firstOpening == true) {
                            controller.openPlayer.value = true;
                            if (audioPlayerController.playerState.value ==
                                PlayerState.playing) {
                              audioPlayer.pause();
                              controller.playAudio1.value = false;
                            } else if (audioPlayerController
                                    .playerState.value ==
                                PlayerState.paused) {
                              tempAudioIndex = controller.verseSoundIndex.value;
                              controller.audioName.value =
                                  "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";
                              audioPlayer.play(UrlSource(
                                  controller.verseSounds["content"]
                                      [controller.verseSoundIndex.value]));
                              controller.playAudio1.value = true;
                            } else {
                              tempAudioIndex = controller.verseSoundIndex.value;
                              controller.audioName.value =
                                  "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";

                              audioPlayer.play(UrlSource(
                                  controller.verseSounds["content"]
                                      [controller.verseSoundIndex.value]!));
                              controller.playAudio1.value = true;
                            }
                          } else {
                            Get.snackbar("Hata", "Okuyucu Yüklenemedi");
                          }
                        },
                        icon: Obx(() => Icon(
                              audioPlayerController.playerState.value !=
                                      PlayerState.playing
                                  ? Icons.play_arrow_rounded
                                  : Icons.pause,
                              size: 35,
                              color: Colors.white.withOpacity(value / 100),
                            )),
                      ),
              ),
            ),
            LikeButton(
              likeBuilder: (bool isLiked) {
                return Icon(
                  favorite == true
                      ? Icons.favorite
                      : !Get.isDarkMode && isLiked
                          ? Icons.favorite
                          : Get.isDarkMode || !isLiked
                              ? UniconsLine.heart
                              : UniconsLine.heart,
                  color: isLiked && Get.isDarkMode
                      ? Colors.redAccent
                      : Colors.white,
                );
              },
              circleColor: CircleColor(
                start: Colors.white,
                end: !Get.isDarkMode
                    ? Theme.of(context).primaryColor
                    : Colors.redAccent,
              ),
              bubblesColor: BubblesColor(
                dotPrimaryColor: !Get.isDarkMode
                    ? Theme.of(context).primaryColor
                    : Colors.red,
                dotSecondaryColor: Colors.white,
              ),
              isLiked: controller.isFavorite(widget.surah),
              onTap: (isLiked) async {
                if (userC.user.id != null) {
                  if (favorite == true) {
                    // final result =
                    //     await controller.removeFromFavorite(106, widget.surah);
                    // final res = await Supabase.instance.client
                    //     .from('SurahFavorites')
                    //     .insert({
                    //   "user_id": userC.user.id,
                    //   "surah_id": 200,
                    //   "verse_id": 1
                    // }).execute();
                    supabase.deleteSurahFavorite(userC.user.id.toString(),
                        widget.surah.number!.toInt(), 0);
                    setState(() {
                      favorite = !favorite;
                    });
                  } else {
                    supabase.setSurahFavorite(userC.user.id.toString(),
                        widget.surah.number!.toInt(), 0);
                    setState(() {
                      favorite = !favorite;
                    });
                  }
                } else {
                  // Get.to(const FavoritePage(), routeName: '/favorite');
                  Get.dialog(ForbiddenCard(
                    onPressed: () {
                      Get.back();
                      Get.to(SignInPage(), routeName: '/login');
                    },
                  ));
                  return false;
                }
              },
            ),
            const SizedBox(width: 10),
            GestureDetector(
                onTap: () => Get.to(const SurahDetailSettingsPage()),
                child: Icon(Icons.settings)),
            const SizedBox(width: 20),
          ],
          centerTitle: true,
          elevation: 1,
        ),
        bottomNavigationBar: Obx(() {
          if (controller.openPlayer.value == true) {
            return SizedBox(
              height: 170,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              controller.verseSounds['images']
                                  [controller.verseSoundIndex.value]),
                        ),
                        SizedBox(
                          width: Get.width / 1.6,
                          child: Text(
                            controller.audioName.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            audioPlayer.stop();
                            controller.openPlayer.value = false;
                          },
                          child: const Icon(
                            Icons.close,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        thumbColor: Theme.of(context).primaryColor,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor:
                            Theme.of(context).primaryColor.withOpacity(0.3),
                        trackShape: const RectangularSliderTrackShape(),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7.0,
                        ),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: positionSecond,
                        builder: (context, double value, child) {
                          return Slider(
                            value: value,
                            min: 0.0,
                            max: duration.inMilliseconds.toDouble(),
                            onChanged: (value) => onSliderChanged(value),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (playback.value == 1.0) {
                              playback.value = 1.5;
                              audioPlayer.setPlaybackRate(1.5);
                            } else if (playback.value == 1.5) {
                              playback.value = 2.0;
                              audioPlayer.setPlaybackRate(2.0);
                            } else if (playback.value == 2.0) {
                              playback.value = 1.0;
                              audioPlayer.setPlaybackRate(1.0);
                            }
                          },
                          child: ValueListenableBuilder(
                            valueListenable: playback,
                            builder: (context, value, child) => Text(
                              "${value}X",
                              style: GoogleFonts.inter(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                positionSecond.value = 0;
                                controller
                                    .verseSoundRepeatControllerIndex.value = 0;
                                if (controller.verseSoundIndex.value == 0) {
                                  controller.verseSoundIndex.value =
                                      controller.verseSounds['names'].length;
                                } else {
                                  controller.verseSoundIndex.value--;
                                }
                                controller
                                    .verseSoundRepeatControllerIndex.value = 0;
                                tempAudioIndex =
                                    controller.verseSoundIndex.value;
                                audioPlayer.stop();
                                Timer(const Duration(milliseconds: 300), () {
                                  controller.audioName.value =
                                      "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";
                                  audioPlayer.play(UrlSource(
                                      controller.verseSounds["content"]
                                          [controller.verseSoundIndex.value]));
                                });
                              },
                              child: const Icon(
                                Icons.skip_previous_rounded,
                                size: 45,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (controller.audioName.value !=
                                        "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}" ||
                                    tempAudioIndex !=
                                        controller.verseSoundIndex.value) {
                                  tempAudioIndex =
                                      controller.verseSoundIndex.value;
                                  audioPlayer.stop();
                                  Timer(const Duration(milliseconds: 300), () {
                                    controller.audioName.value =
                                        "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";
                                    audioPlayer.play(UrlSource(controller
                                            .verseSounds["content"]
                                        [controller.verseSoundIndex.value]));
                                  });
                                } else if (audioPlayerController
                                        .playerState.value ==
                                    PlayerState.playing) {
                                  audioPlayer.pause();
                                } else {
                                  audioPlayer.resume();
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    audioPlayerController.playerState.value !=
                                            PlayerState.playing
                                        ? Icons.play_arrow_rounded
                                        : Icons.pause,
                                    size: 45,
                                    color: Colors.white,
                                  )),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                positionSecond.value = 0;
                                controller
                                    .verseSoundRepeatControllerIndex.value = 0;
                                if (controller.verseSoundIndex.value ==
                                    controller.verseSounds['names'].length -
                                        1) {
                                  controller.verseSoundIndex.value = 0;
                                } else {
                                  controller.verseSoundIndex.value++;
                                }
                                controller
                                    .verseSoundRepeatControllerIndex.value = 0;
                                tempAudioIndex =
                                    controller.verseSoundIndex.value;
                                audioPlayer.stop();
                                Timer(const Duration(milliseconds: 300), () {
                                  controller.audioName.value =
                                      "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";
                                  audioPlayer.play(UrlSource(
                                      controller.verseSounds["content"]
                                          [controller.verseSoundIndex.value]));
                                });
                              },
                              child: const Icon(
                                Icons.skip_next,
                                size: 45,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Get.to(const PlayerSettingsPage()),
                          child: const Icon(
                            Icons.menu,
                            size: 38,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
        body: FutureBuilder(
          future: controller.fetchSurahByID(widget.surah.number, authorId),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading();
            } else if (!snapshot.hasData) {
              return const SurahDetailPageShimmer();
            } else {
              // print(controller.verses[1].translation!.author);
              return Obx(() {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          const SizedBox(height: 20),
                          SurahCard(
                            number: widget.surah.number,
                            name: "${widget.surah.name}",
                            numberOfVerses: widget.surah.numberOfVerses,
                            originalName: widget.surah.nameOriginal,
                            function: () async {
                              // controller.playAudio2.value = false;
                              // audioPlayer2.pause();
                              if (controller.audioName.value !=
                                      "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}" ||
                                  tempAudioIndex !=
                                      controller.verseSoundIndex.value) {
                                tempAudioIndex =
                                    controller.verseSoundIndex.value;
                                audioPlayer.stop();
                                controller.audioName.value =
                                    "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";
                                Timer(
                                    const Duration(milliseconds: 300),
                                    () => audioPlayer.play(UrlSource(controller
                                            .verseSounds["content"]
                                        [controller.verseSoundIndex.value])));
                              }
                              if (audioPlayerController.playerState.value ==
                                  PlayerState.playing) {
                                audioPlayer.pause();
                                controller.playAudio1.value = false;
                              } else if (audioPlayerController
                                      .playerState.value ==
                                  PlayerState.paused) {
                                tempAudioIndex =
                                    controller.verseSoundIndex.value;
                                controller.audioName.value =
                                    "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";
                                audioPlayer.play(UrlSource(
                                    controller.verseSounds["content"]
                                        [controller.verseSoundIndex.value]));
                                controller.playAudio1.value = true;
                              } else {
                                tempAudioIndex =
                                    controller.verseSoundIndex.value;
                                controller.audioName.value =
                                    "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";

                                audioPlayer.play(UrlSource(
                                    controller.verseSounds["content"]
                                        [controller.verseSoundIndex.value]!));
                                controller.playAudio1.value = true;
                              }
                            },
                            // function2: () async {
                            //   // controller.playAudio2.value = false;
                            //   // audioPlayer2.pause();
                            //   if (controller.audioName.value !=
                            //       "${widget.surah.name.toString()} - Meal") {
                            //     controller.audioName.value =
                            //         "${widget.surah.name.toString()} - Meal";
                            //     audioPlayer.stop();
                            //     Timer(
                            //         const Duration(milliseconds: 300),
                            //         () => audioPlayer.play(
                            //             UrlSource(controller.audioUrl.first)));
                            //   } else if (audioPlayerController
                            //           .playerState.value ==
                            //       PlayerState.playing) {
                            //     audioPlayer.pause();
                            //     controller.playAudio1.value = false;
                            //   } else if (audioPlayerController
                            //           .playerState.value ==
                            //       PlayerState.paused) {
                            //     controller.audioName.value =
                            //         "${widget.surah.name.toString()} - Meal";
                            //     String? soundUrl = await SupabaseService()
                            //         .getSurahSound(
                            //             widget.surah.name.toString());
                            //     audioPlayer.play(UrlSource(soundUrl!));
                            //     controller.playAudio1.value = true;
                            //   } else {
                            //     controller.audioName.value =
                            //         "${widget.surah.name.toString()} - Meal";
                            //     String? soundUrl = await SupabaseService()
                            //         .getSurahSound(
                            //             widget.surah.name.toString());
                            //     audioPlayer.play(UrlSource(soundUrl!));
                            //     controller.playAudio1.value = true;
                            //   }
                            //   // controller.playAudio1.value = false;
                            //   // audioPlayer.pause();
                            //   // if (audioPlayerController2.playerState.value ==
                            //   //     PlayerState.playing) {
                            //   //   controller.playAudio2.value = false;
                            //   //   audioPlayer2.pause();
                            //   // } else if (audioPlayerController2
                            //   //         .playerState.value ==
                            //   //     PlayerState.paused) {
                            //   //   controller.audioName.value =
                            //   //       "${widget.surah.name.toString()} - Meal";
                            //   //   audioPlayer2
                            //   //       .play(UrlSource(controller.audioUrl.first));
                            //   //   controller.playAudio2.value = true;
                            //   // } else {
                            //   //   controller.audioName.value =
                            //   //       "${widget.surah.name.toString()} - Meal";
                            //   //   audioPlayer2
                            //   //       .play(UrlSource(controller.audioUrl.first));
                            //   //   controller.playAudio2.value = true;
                            //   // }
                            // },
                            icon: audioPlayerController.playerState.value ==
                                        PlayerState.playing &&
                                    controller.audioName.value ==
                                        "${widget.surah.name.toString()} - Arapça"
                                ? Icon(
                                    Icons.pause,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.play_arrow_rounded,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                            // icon2: audioPlayerController.playerState.value ==
                            //             PlayerState.playing &&
                            //         controller.audioName.value ==
                            //             "${widget.surah.name.toString()} - Meal"
                            //     ? const Icon(Icons.pause)
                            //     : const Icon(Icons.play_arrow_rounded),
                          ),
                          // const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        "Müfessirler",
                                        style: GoogleFonts.inter(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          context.locale.languageCode == "tr",
                                      child: DropdownButton<Author>(
                                        value: author ??
                                            (window.locale.languageCode == "tr"
                                                ? authorList[10]
                                                : authorList[23]),
                                        items: authorList
                                            .map((item) => DropdownMenuItem(
                                                value: item,
                                                child: SizedBox(
                                                  width: 104,
                                                  child: Text(
                                                    item.name!.toString(),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                )))
                                            .toList(),
                                        hint: Text("mealyazar".tr()),
                                        onChanged: (a) {
                                          setState(() {
                                            author = a!;
                                            authorId = a.id!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Visibility(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (firstOpening == true) {
                                      controller.openPlayer.value = true;
                                      if (audioPlayerController
                                              .playerState.value ==
                                          PlayerState.playing) {
                                        audioPlayer.pause();
                                        controller.playAudio1.value = false;
                                      } else if (audioPlayerController
                                              .playerState.value ==
                                          PlayerState.paused) {
                                        print("1");
                                        tempAudioIndex =
                                            controller.verseSoundIndex.value;
                                        controller.audioName.value =
                                            "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";
                                        audioPlayer.play(UrlSource(controller
                                                .verseSounds["content"][
                                            controller.verseSoundIndex.value]));
                                        controller.playAudio1.value = true;
                                      } else {
                                        print("2");
                                        tempAudioIndex =
                                            controller.verseSoundIndex.value;
                                        controller.audioName.value =
                                            "${widget.surah.name.toString()} - ${controller.verseSounds['names'][controller.verseSoundIndex.value]}";

                                        audioPlayer.play(UrlSource(
                                            controller.verseSounds["content"][
                                                controller
                                                    .verseSoundIndex.value]!));
                                        controller.playAudio1.value = true;
                                      }
                                    } else {
                                      Get.snackbar(
                                          "Hata", "Okuyucu Yüklenemedi");
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.2)),
                                    child: Obx(() => Icon(
                                          audioPlayerController
                                                      .playerState.value ==
                                                  PlayerState.playing
                                              ? Icons.pause
                                              : Icons.play_arrow_rounded,
                                          color: Theme.of(context).primaryColor,
                                          size: 30,
                                        )),
                                  ),
                                ),
                                visible: context.locale.languageCode == "tr",
                              ),
                            ],
                          ),
                          aboutSurah(),
                          if (!snapshot.hasData) const SurahDetailPageShimmer(),
                          for (var verse in controller.verses)
                            FadeInDown(
                              from: 50,
                              child: VerseItem(
                                surahNumber: widget.surah.number,
                                surahName: verse.surahName,
                                verseNumber: verse.verseNumber,
                                verse: verse.verse,
                                transcription: verse.transcription,
                                textTranslation: verse.translation!.text,
                                author: verse.translation!.author,
                                onTapSeeTafsir: () {
                                  if (controller.showTafsir.value) {
                                    controller.showTafsir.value = false;
                                  }

                                  controller.showTafsir.value = true;
                                  _buildTafsirView(verse);
                                },
                                onTapSeeTefsir: () {
                                  if (controller.showTafsir.value) {
                                    controller.showTafsir.value = false;
                                  }

                                  controller.showTafsir.value = true;
                                  _buildTefsirView(verse);
                                },
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: myBanner != null
                          ? Container(
                              alignment: Alignment.center,
                              child: AdWidget(ad: myBanner!),
                              width: myBanner!.size.width.toDouble(),
                              height: myBanner!.size.height.toDouble(),
                            )
                          : Container(),
                    ),
                    if (controller.showTafsir.value) tafsirView,
                  ],
                );
              });
            }
          },
        ),
      ),
    );
  }

  aboutSurah() {
    return Column(
      children: [
        Obx(
          () => SizedBox(
            child: controller.showKuranContenWidget1.value == false
                ? null
                : Visibility(
                    visible: context.locale.languageCode == "tr",
                    child: InkWell(
                      onTap: () {
                        if (widgetsControl.value == 0) {
                          widgetsControl.value = -1;
                        } else {
                          widgetsControl.value = 0;
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [AppShadow.card],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: ValueListenableBuilder(
                            valueListenable: widgetsControl,
                            builder: (context, value, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hakkında",
                                  style: AppTextStyle.normal.copyWith(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  hakkinda,
                                  maxLines: value == 0 ? 200 : 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.normal.copyWith(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                Container(
                                  color: Colors.white.withOpacity(0),
                                  child: Text(
                                    value == 0 ? "Küçült" : "Devamını Oku",
                                    style: AppTextStyle.normal.copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(
          () => SizedBox(
            child: controller.showKuranContenWidget2.value == false
                ? null
                : Visibility(
                    visible: context.locale.languageCode == "tr",
                    child: InkWell(
                      onTap: () {
                        if (widgetsControl.value == 1) {
                          widgetsControl.value = -1;
                        } else {
                          widgetsControl.value = 1;
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [AppShadow.card],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: ValueListenableBuilder(
                            valueListenable: widgetsControl,
                            builder: (context, value, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nüzul",
                                  style: AppTextStyle.normal.copyWith(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  nuzul,
                                  maxLines: value == 1 ? 200 : 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.normal.copyWith(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                Container(
                                  color: Colors.white.withOpacity(0),
                                  child: Text(
                                    value == 1 ? "Küçült" : "Devamını Oku",
                                    style: AppTextStyle.normal.copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(
          () => SizedBox(
            child: controller.showKuranContenWidget3.value == false
                ? null
                : Visibility(
                    visible: context.locale.languageCode == "tr",
                    child: InkWell(
                      onTap: () {
                        if (widgetsControl.value == 2) {
                          widgetsControl.value = -1;
                        } else {
                          widgetsControl.value = 2;
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [AppShadow.card],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: ValueListenableBuilder(
                            valueListenable: widgetsControl,
                            builder: (context, value, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Konu",
                                  style: AppTextStyle.normal.copyWith(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  konu,
                                  maxLines: value == 2 ? 200 : 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.normal.copyWith(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                Container(
                                  color: Colors.white.withOpacity(0),
                                  child: Text(
                                    value == 2 ? "Küçült" : "Devamını Oku",
                                    style: AppTextStyle.normal.copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(
          () => SizedBox(
            child: controller.showKuranContenWidget4.value == false
                ? null
                : Visibility(
                    visible: context.locale.languageCode == "tr",
                    child: InkWell(
                      onTap: () {
                        if (widgetsControl.value == 3) {
                          widgetsControl.value = -1;
                        } else {
                          widgetsControl.value = 3;
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [AppShadow.card],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: ValueListenableBuilder(
                            valueListenable: widgetsControl,
                            builder: (context, value, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fazileti",
                                  style: AppTextStyle.normal.copyWith(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  fazilet,
                                  maxLines: value == 3 ? 200 : 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.normal.copyWith(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                Container(
                                  color: Colors.white.withOpacity(0),
                                  child: Text(
                                    value == 3 ? "Küçült" : "Devamını Oku",
                                    style: AppTextStyle.normal.copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  initDatabaseData() async {
    if (userC.user.id != null) {
      favorite = await supabase.getSurahFavoritesData(
          "SurahFavorites", userC.user.id.toString(), widget.surah.number!, 0);
    }
    Map<String, dynamic> tempSound =
        await supabase.getVerseList(widget.surah.name.toString().toLowerCase());
    controller.verseSounds.value = tempSound;
    firstOpening = true;
  }

  void onSliderChanged(double value) {
    Duration newPosition = Duration(milliseconds: value.toInt());
    audioPlayer.seek(newPosition);
  }

  getApiAbout() async {
    Response response = await get(Uri.parse(
        "https://api.kimbuldu.com.tr/getsureapi.php?sureadi=${widget.surah.name!.toLowerCase()}&datatipi=hakkinda&ayetno=${widget.surah.number}"));
    String data = jsonDecode(json.encode(response.body));
    String temp = "";
    bool run = false;
    for (int I = 0; I < data.length; I++) {
      if (data[I] == "{" && data[I - 1] == ':' || run == true) {
        temp += data[I];
        run = true;
        if (data[I] == "}") {
          run = false;
          break;
        }
      }
    }
    Map valueMap = json.decode(temp);
    Response response2 = await get(Uri.parse(
        "https://api.kimbuldu.com.tr/getsureapi.php?sureadi=${widget.surah.name!.toLowerCase()}&datatipi=nuzul&ayetno=${widget.surah.number}"));
    String data2 = jsonDecode(json.encode(response2.body));
    String temp2 = "";
    bool run2 = false;
    for (int I = 0; I < data2.length; I++) {
      if (data2[I] == "{" && data2[I - 1] == ':' || run2 == true) {
        temp2 += data2[I];
        run2 = true;
        if (data2[I] == "}") {
          run2 = false;
          break;
        }
      }
    }
    Map valueMap2 = json.decode(temp2);
    Response response3 = await get(Uri.parse(
        "https://api.kimbuldu.com.tr/getsureapi.php?sureadi=${widget.surah.name!.toLowerCase()}&datatipi=konu&ayetno=${widget.surah.number}"));
    String data3 = jsonDecode(json.encode(response3.body));
    String temp3 = "";
    bool run3 = false;
    for (int I = 0; I < data3.length; I++) {
      if (data3[I] == "{" && data3[I - 1] == ':' || run3 == true) {
        temp3 += data3[I];
        run3 = true;
        if (data3[I] == "}") {
          run3 = false;
          break;
        }
      }
    }
    Map valueMap3 = json.decode(temp3);
    Response response4 = await get(Uri.parse(
        "https://api.kimbuldu.com.tr/getsureapi.php?sureadi=${widget.surah.name!.toLowerCase()}&datatipi=fazilet&ayetno=${widget.surah.number}"));
    String data4 = jsonDecode(json.encode(response4.body));
    String temp4 = "";
    bool run4 = false;
    for (int I = 0; I < data4.length; I++) {
      if (data4[I] == "{" && data4[I - 1] == ':' || run4 == true) {
        temp4 += data4[I];
        run4 = true;
        if (data4[I] == "}") {
          run4 = false;
          break;
        }
      }
    }
    Map valueMap4 = json.decode(temp4);
    hakkinda = valueMap["hakkinda"].toString();
    nuzul = valueMap2["nuzul"].toString();
    konu = valueMap3["konu"].toString();
    fazilet = valueMap4["fazilet"].toString();
    if (mounted) {
      setState(() {
        hakkinda = valueMap["hakkinda"].toString();
        nuzul = valueMap2["nuzul"].toString();
        konu = valueMap3["konu"].toString();
        fazilet = valueMap4["fazilet"].toString();
      });
    }
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

  _buildTefsirView(Verse verse) {
    tafsirView = TefsirView(
        verseTitle: verse.verse,
        surahNumber: verse.verseNumber,
        surahName: verse.surahName,
        closeShow: () {
          controller.showTafsir.value = false;
          controller.resetWords();
          controller.resetTranslations();
        });
  }

  @override
  void dispose() {
    controller.openPlayer.value = false;
    audioPlayer.dispose();
    super.dispose();
  }
}
