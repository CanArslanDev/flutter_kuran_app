import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:in_app_review/in_app_review.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quran_app/services/supabase_service.dart';
import 'package:quran_app/src/widgets/rate_msg.dart';

class SoundContentPage extends StatefulWidget {
  const SoundContentPage({Key? key}) : super(key: key);

  @override
  State<SoundContentPage> createState() => _SoundContentPageState();
}

class _SoundContentPageState extends State<SoundContentPage> {
  String jsonString = '''
    
  ''';

  List<String> currentList = [];
  bool isSubList = false;
  List previousList = [];
  List previousTextList = ['Sesli İçerikler'];
  String appbarText = 'Sesli dini içerik ve kitap';
  ValueNotifier<bool> loading = ValueNotifier(false);
  @override
  void initState() {
    loadDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (await inAppReview.isAvailable()) {
        //   inAppReview.openStoreListing();
        // }
        // return false;
        await RateMsg().msg().then((value) {
          return value;
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appbarText),
          leading: isSubList
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _handleBackButton,
                )
              : null,
        ),
        body: ValueListenableBuilder(
          valueListenable: loading,
          builder: (context, bool value, child) {
            if (value) {
              return ListView(
                children: _buildListItems(),
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildListItems() {
    List<Widget> items = [];
    for (String baslik in currentList) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      bool control = false;
      List<dynamic> liste = json[baslik] ?? [];
      if (json.containsKey(baslik)) {
        control = true;
      }
      items.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              _handleContainerTap(baslik);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 5),
                    )
                  ]),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 270,
                          child: Text(
                            baslik,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: GoogleFonts.inter(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          child: control
                              ? Text(
                                  "Bölüm Sayısı: ${liste.length.toString()}",
                                  style: TextStyle(fontSize: 16),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return items;
  }

  loadDatabase() async {
    var content = await SupabaseService().getSoundContentList();
    jsonString = json.encode(content);
    print(jsonString);
    currentList = List.from(jsonDecode(jsonString)['basliklar']);
    loading.value = true;
  }

  void _handleContainerTap(String baslik) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    if (json.containsKey(baslik)) {
      List<dynamic> liste = json[baslik] ?? [];

      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.leftToRight,
              child: SoundContentSubPage(
                  appBarText: baslik,
                  currentList: List.from(liste),
                  jsonString: jsonString)));
    } else {
      if (json['values'].containsKey(baslik)) {
        dynamic deger = json['values'][baslik];
        if (deger is int) {
          List tempList = [];
          try {
            tempList = List.from(json[json['values'][baslik + "_name"]]);
          } catch (e) {
            tempList = [];
          }
          _navigateToSoundContentPlayer(deger,
              List.from(json[json['values'][baslik + "_content"]]), tempList);
        }
      }
    }
  }

  void _handleBackButton() {
    setState(() {
      currentList = List.from(previousList[previousList.length - 1]);
      previousList.removeLast();
      // appbarText = previousTextList[previousTextList.length - 1];
      // if (previousTextList.length > 1) {audiosName
      //   previousTextList.removeLast();
      // }
      if (previousList.isEmpty) {
        isSubList = false;
        // appbarText = 'Sesli Vaaz - Kitap - Dua';
      }
    });
  }

  void _navigateToSoundContentPlayer(
      int index, List<String> audios, audiosName) {
    Get.to(SoundContentPlayer(
      audios: audios,
      initialIndex: index,
      audiosName: audiosName,
    ));
  }
}

class SoundContentSubPage extends StatefulWidget {
  const SoundContentSubPage(
      {Key? key,
      required this.appBarText,
      required this.currentList,
      required this.jsonString})
      : super(key: key);
  final String appBarText;
  final List<String> currentList;
  final String jsonString;
  @override
  State<SoundContentSubPage> createState() => _SoundContentSubPageState();
}

class _SoundContentSubPageState extends State<SoundContentSubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarText),
      ),
      body: ListView(
        children: _buildListItems(),
      ),
    );
  }

  List<Widget> _buildListItems() {
    List<Widget> items = [];

    // Basliklar listesindeki değerlerin üzerinde dön
    for (String baslik in widget.currentList) {
      Map<String, dynamic> json = jsonDecode(widget.jsonString);
      bool control = false;
      List<dynamic> liste = json[baslik] ?? [];
      if (json.containsKey(baslik)) {
        control = true;
      }
      items.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              _handleContainerTap(baslik);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 5),
                    )
                  ]),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 270,
                          child: Text(
                            baslik,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: GoogleFonts.inter(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          child: control
                              ? Text(
                                  "Bölüm Sayısı: ${liste.length.toString()}",
                                  style: TextStyle(fontSize: 16),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return items;
  }

  void _handleContainerTap(String baslik) {
    // JSON'ı dönüştür
    Map<String, dynamic> json = jsonDecode(widget.jsonString);

    // Baslıkla eşleşen bir liste bulunuyor mu kontrol et
    if (json.containsKey(baslik)) {
      print("object");
      List<dynamic> liste = json[baslik] ?? [];
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.leftToRight,
              child: SoundContentSubPage(
                  appBarText: baslik,
                  currentList: List.from(liste),
                  jsonString: widget.jsonString)));
      // Get.to(SoundContentSubPage(
      //     appBarText: baslik,
      //     currentList: List.from(liste),
      //     jsonString: widget.jsonString));
      // setState(() {
      //   previousList.add(List.from(currentList));
      //   if (previousList.length > 1) {
      //     previousTextList.add(appbarText);
      //   }
      //   appbarText = baslik;
      //   currentList = List.from(liste);
      //   isSubList = true;
      // });
    } else {
      // values içinde baslıkla eşleşen bir değer var mı kontrol et
      if (json['values'].containsKey(baslik)) {
        dynamic deger = json['values'][baslik];
        if (deger is int) {
          List tempList = [];
          try {
            tempList = List.from(json[json['values'][baslik + "_name"]]);
          } catch (e) {
            tempList = [];
          }
          _navigateToSoundContentPlayer(deger,
              List.from(json[json['values'][baslik + "_content"]]), tempList);
        }
      }
    }
  }

  void _navigateToSoundContentPlayer(
      int index, List<String> audios, audiosName) {
    print("r33 $audiosName");
    Get.to(SoundContentPlayer(
      audios: audios,
      initialIndex: index,
      audiosName: audiosName,
    ));
  }
}

class SoundContentPlayer extends StatefulWidget {
  final List<String> audios;
  final int initialIndex;
  final List audiosName;
  SoundContentPlayer(
      {required this.audios,
      required this.initialIndex,
      required this.audiosName});

  @override
  _SoundContentPlayerState createState() => _SoundContentPlayerState();
}

class _SoundContentPlayerState extends State<SoundContentPlayer> {
  late AudioPlayer audioPlayer;
  int currentIndex = 0;
  double playbackSpeed = 1.0;
  ValueNotifier<bool> playing = ValueNotifier(false);
  ValueNotifier<double> playback = ValueNotifier(1.0);
  ValueNotifier<double> positionSecond = ValueNotifier(0);
  ValueNotifier<double> durationSecond = ValueNotifier(0);
  Duration position = const Duration();
  Duration duration = const Duration();
  var playerState = PlayerState.stopped.obs;
  bool titleOpening = false;
  ValueNotifier<String> title = ValueNotifier("");
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setPlaybackRate(playbackSpeed);
    audioPlayer.play(UrlSource(widget.audios[widget.initialIndex]));
    currentIndex = widget.initialIndex;

    audioPlayer.onDurationChanged.listen((Duration p) {
      duration = p;
      durationSecond.value = duration.inMilliseconds.toDouble();
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      position = p;
      positionSecond.value = position.inMilliseconds.toDouble();
    });
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  void _play() {
    if (duration.inSeconds == 0) {
      Get.snackbar("Lütfen Bekleyin", "Lütfen bekleyin, ses dosyası açılıyor");
    }
    audioPlayer.resume();
    playing.value = true;
  }

  void _pause() {
    audioPlayer.pause();
    playing.value = false;
  }

  void _stop() {
    audioPlayer.pause();
    Duration newPosition = const Duration(milliseconds: 0);
    audioPlayer.seek(newPosition);
  }

  void _next() {
    if (currentIndex < widget.audios.length - 1) {
      currentIndex++;
      audioPlayer.stop();
      if (widget.audiosName.isNotEmpty) {
        title.value = widget.audiosName[currentIndex];
      }
      Timer(Duration(milliseconds: 300),
          () => audioPlayer.play(UrlSource(widget.audios[currentIndex])));
    } else {
      Get.snackbar('Hata', 'Sonraki şarkı bulunamadı.');
    }
  }

  void onSliderChanged(double value) {
    Duration newPosition = Duration(milliseconds: value.toInt());
    audioPlayer.seek(newPosition);
  }

  void _previous() {
    if (currentIndex > 0) {
      currentIndex--;
      audioPlayer.stop();
      if (widget.audiosName.isNotEmpty) {
        title.value = widget.audiosName[currentIndex];
      }
      Timer(Duration(milliseconds: 300),
          () => audioPlayer.play(UrlSource(widget.audios[currentIndex])));
    } else {
      Get.snackbar('Hata', 'Önceki şarkı bulunamadı.');
    }
  }

  void _setPlaybackSpeed(double speed) {
    setState(() {
      playbackSpeed = speed;
    });
    audioPlayer.setPlaybackRate(speed);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audiosName.isNotEmpty) {
      titleOpening = true;
      title.value = widget.audiosName[currentIndex];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Bölüm içeriği'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // IconButton(
            //   icon: Icon(audioPlayer.state == PlayerState.playing
            //       ? Icons.pause
            //       : Icons.play_arrow),
            //   onPressed: _playPause,
            // ),
            // IconButton(
            //   icon: Icon(Icons.stop),
            //   onPressed: _stop,
            // ),
            // IconButton(
            //   icon: Icon(Icons.skip_previous),
            //   onPressed: _previous,
            // ),
            // IconButton(
            //   icon: Icon(Icons.skip_next),
            //   onPressed: _next,
            // ),
            // SizedBox(height: 20),
            // Text('Playback Speed'),
            // Slider(
            //   value: playbackSpeed,
            //   min: 0.5,
            //   max: 2.0,
            //   divisions: 7,
            //   onChanged: _setPlaybackSpeed,
            // ),
            // Text('${playbackSpeed.toStringAsFixed(1)}x'),
            Padding(
              padding: EdgeInsets.only(
                  top: titleOpening ? 20.0 : 90.0, left: 20, right: 20),
              child: Column(
                children: [
                  SizedBox(
                    child: titleOpening
                        ? Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15)),
                            child: ValueListenableBuilder(
                              valueListenable: title,
                              builder: (context, String value, child) {
                                return Center(
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                );
                              },
                            ),
                          )
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: positionSecond,
                        builder: (context, double value, child) {
                          return Text(
                              "${position.inMinutes.toString().length == 1 ? "0" + position.inMinutes.toString() : position.inMinutes.toString()}:${position.inSeconds > 60 ? (position.inSeconds - 60 * position.inMinutes).toString().length == 1 ? "0" + (position.inSeconds - 60 * position.inMinutes).toString() : (position.inSeconds - 60 * position.inMinutes).toString() : position.inSeconds.toString().length == 1 ? "0" + position.inSeconds.toString() : position.inSeconds.toString()}",
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.bold));
                        },
                      ),
                      ValueListenableBuilder(
                        valueListenable: durationSecond,
                        builder: (context, double value, child) {
                          return Text(
                            "${duration.inMinutes.toString().length == 1 ? "0" + duration.inMinutes.toString() : duration.inMinutes.toString()}:${duration.inSeconds > 60 ? (duration.inSeconds - 60 * duration.inMinutes).toString().length == 1 ? "0" + (duration.inSeconds - 60 * duration.inMinutes).toString() : (duration.inSeconds - 60 * duration.inMinutes).toString() : duration.inSeconds.toString().length == 1 ? "0" + duration.inSeconds.toString() : duration.inSeconds.toString()}",
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _previous,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade400,
                                    shape: BoxShape.circle),
                                child: ValueListenableBuilder(
                                  valueListenable: playing,
                                  builder: (context, bool value, child) => Icon(
                                    Icons.skip_previous_rounded,
                                    size: 45,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: _pause,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue.shade600,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.pause,
                                  size: 55,
                                  color: Colors.white,
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: _play,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  size: 75,
                                  color: Colors.white,
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: _stop,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red.shade800,
                                    shape: BoxShape.circle),
                                child: ValueListenableBuilder(
                                  valueListenable: playing,
                                  builder: (context, bool value, child) => Icon(
                                    Icons.stop,
                                    size: 55,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: _next,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade400,
                                    shape: BoxShape.circle),
                                child: ValueListenableBuilder(
                                  valueListenable: playing,
                                  builder: (context, bool value, child) => Icon(
                                    Icons.skip_next,
                                    size: 45,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
