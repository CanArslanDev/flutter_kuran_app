import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioPlayerController extends GetxController {
  // for state of playing Audio
  var isPlay = false.obs;

  void setPlay(bool value) {
    isPlay.value = value;
  }

  var audioPlayer = AudioPlayer();
  var playerState = PlayerState.stopped.obs;
  var duration = 0.obs;

  play({required List<String> url}) async {
    for (var i = 0; i < url.length; i++) {
      await audioPlayer.play(UrlSource(url[i]));

      fetchDuration();
      setPlay(true);
      // Get.snackbar("Waahh", "Successfully playing audio");

      await Future.delayed(Duration(milliseconds: duration.value + 500));
    }
  }

  pause() async {
    await audioPlayer.pause();
  }

  changeState() {
    audioPlayer.onPlayerStateChanged.listen((event) {
      playerState.value = event;
    });
  }

  fetchDuration() async {
    Duration? dur = await audioPlayer.getDuration();
    duration.value = dur!.inSeconds;
    audioPlayer.onDurationChanged.listen((event) {
      log(event.inMilliseconds.toString());
    });
  }

  stop() async {
    await audioPlayer.stop();
    setPlay(false);
  }
}
