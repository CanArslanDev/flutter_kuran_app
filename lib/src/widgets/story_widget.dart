import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_app/services/network_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_view/story_view.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import '../../helper/ads.dart';

ValueNotifier<String> loading = ValueNotifier("");

story(var e, var list) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3),
    child: ZoomTapAnimation(
      onTap: () async {
        if (loading.value == "") {
          loading.value = e;
          List added = [];
          bool called = false;
          for (int i = 0; i < list.length; i++) {
            if (called == true) {
              if (list[i].toString().endsWith(".jpg") == true) {
                added.add([list[i]]);
              } else {
                added.add([list[i], 999]);
                // added.add([
                //   await getYouTubeVideoUrl(list[i]),
                //   await getYouTubeVideoDuration(list[i])
                // ]);
              }
            } else {
              if (list[i] == e) {
                called = true;
                if (list[i].toString().endsWith(".jpg") == true) {
                  added.add([list[i]]);
                } else {
                  added.add([list[i], 999]);
                  // added.add([
                  //   await getYouTubeVideoUrl(list[i]),
                  //   await getYouTubeVideoDuration(list[i])
                  // ]);
                }
              }
            }
          }
          loading.value = "";
          Get.to(StoryWidget(
            content: added,
          ));
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: (e == loading) ? Colors.transparent : Colors.green,
            shape: BoxShape.circle),
        child: ValueListenableBuilder(
          valueListenable: loading,
          builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: (e.toString().endsWith(".jpg") == false)
                  ? CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green,
                      child: (e == value)
                          ? CircularProgressIndicator(
                              color: Colors.green.shade600,
                            )
                          : const Icon(
                              Icons.slow_motion_video_rounded,
                              color: Colors.white,
                            ),
                      backgroundImage: NetworkImage(e),
                    )
                  : CircleAvatar(
                      radius: 30,
                      child: (e == value)
                          ? const CircularProgressIndicator(
                              color: Colors.green,
                            )
                          : null,
                      backgroundImage: NetworkImage(e),
                    ),
            );
          },
        ),
      ),

      // child: Stack(
      //   children: [
      //     Container(
      //       decoration: BoxDecoration(
      //           color: (e == loading) ? Colors.transparent : Colors.green,
      //           shape: BoxShape.circle),
      //       child: Padding(
      //         padding: const EdgeInsets.all(3.0),
      //         child: (e.toString().endsWith(".jpg") == false)
      //             ? FutureBuilder(
      //                 future: getBlurredThumbnailDataFromVideoUrl(e, 30),
      //                 builder: (context, snapshot) {
      //                   return AnimatedOpacity(
      //                     opacity: (snapshot.hasData) ? 1.0 : 0.0,
      //                     duration: const Duration(milliseconds: 400),
      //                     child: (snapshot.hasData)
      //                         ? CircleAvatar(
      //                             radius: 30,
      //                             child:
      //                                 (e.toString().endsWith(".jpg") == true)
      //                                     ? null
      //                                     : const Icon(
      //                                         Icons.slow_motion_video_rounded,
      //                                         size: 30,
      //                                       ),
      //                             backgroundImage: MemoryImage(
      //                                 snapshot.data! as Uint8List),
      //                           )
      //                         : CircleAvatar(
      //                             radius: 30,
      //                             child:
      //                                 (e.toString().endsWith(".jpg") == true)
      //                                     ? null
      //                                     : const Icon(
      //                                         Icons.slow_motion_video_rounded,
      //                                         size: 30,
      //                                       ),
      //                             backgroundImage: NetworkImage(e),
      //                           ),
      //                   );
      //                 },
      //               )
      //             : CircleAvatar(
      //                 radius: 30,
      //                 child: (e.toString().endsWith(".jpg") == true)
      //                     ? null
      //                     : const Icon(Icons.slow_motion_video_rounded),
      //                 backgroundImage: NetworkImage(e),
      //               ),
      //       ),
      //     ),

      //   ],
      // ),
    ),
  );
}

// Future<Uint8List> getBlurredThumbnailDataFromVideoUrl(
//     String videoUrl, int blurAmount) async {
//   final yt = YoutubeExplode();
//   final video = await yt.videos.get(videoUrl);

//   final thumbnailUrl = video.thumbnails.highResUrl;
//   final response = await http.get(Uri.parse(thumbnailUrl));
//   final bytes = response.bodyBytes;

//   final image = img.decodeImage(bytes);
//   final blurredImage = img.gaussianBlur(image!, radius: blurAmount);

//   final blurredThumbnailData = img.encodeJpg(blurredImage);

//   yt.close();

//   return Uint8List.fromList(blurredThumbnailData);
// }

Future<int> getYouTubeVideoDuration(String videoUrl) async {
  final yt = YoutubeExplode();

  try {
    var video = await yt.videos.get(videoUrl);
    var duration = video.duration;

    var durationInSeconds = duration!.inSeconds;
    return durationInSeconds;
  } catch (e) {
    return 0;
  } finally {
    yt.close();
  }
}

Future<String> getYouTubeVideoUrl(String videoUrl) async {
  final yt = YoutubeExplode();
  try {
    var video = await yt.videos.get(videoUrl);
    var manifest = await yt.videos.streamsClient.getManifest(video.id);

    var streamInfo = manifest.muxed.withHighestBitrate();
    var mp4Url = streamInfo.url.toString();
    return mp4Url;
  } catch (e) {
    return "";
  } finally {
    yt.close();
  }
}

class StoryViewPage extends StatelessWidget {
  const StoryViewPage(
      {Key? key,
      required this.content1,
      required this.content2,
      required this.content3})
      : super(key: key);
  final List content1;
  final List content2;
  final List content3;
  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        story(content1[0], content1),
        story(content2[0], content2),
        story(content3[0], content3),
      ]),
    );
  }
}

class StoryWidget extends StatefulWidget {
  const StoryWidget({Key? key, required this.content}) : super(key: key);
  final List content;
  @override
  _StoryWidgetState createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  final storyController = StoryController();
  List type = [];
  List<StoryItem?> storyItems = [];
  int index = 0;
  @override
  void initState() {
    widget.content.map(
      (e) {
        if (e[0].toString().endsWith(".jpg") == true) {
          type.add(["jpg", e[0]]);
          storyItems.add(
            StoryItem.pageImage(
              url: e[0],
              key: Key(type.length.toString()),
              controller: storyController,
            ),
          );
        } else {
          type.add(["video"]);
          storyItems.add(
            StoryItem.pageVideo(
              e[0],
              key: Key(type.length.toString()),
              duration: Duration(seconds: e[1]),
              controller: storyController,
            ),
          );
        }
      },
    ).toList();
    try {
      if (widget.content[0][1] == 999) {
        initVideo();
      }
    } catch (e) {}
    super.initState();
  }

  initVideo() {
    List tempList = [];
    List<StoryItem?> tempStoryItems = [];
    widget.content.map((e) async {
      var videoUrl = await getYouTubeVideoUrl(e[0]);
      var duration = await getYouTubeVideoDuration(e[0]);
      tempList.add(["video"]);
      tempStoryItems.add(
        StoryItem.pageVideo(
          videoUrl,
          key: Key(type.length.toString()),
          duration: Duration(seconds: e[1]),
          controller: storyController,
        ),
      );
      if (tempStoryItems.length == widget.content.length) {
        setState(() {
          storyItems = tempStoryItems;
          type = tempList;
        });
      }
    }).toList();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StoryView(
            storyItems: storyItems,
            onStoryShow: (s) async {
              if (index != 0) {
                onTapMethod(false);
              }
              String key = s.view.key.toString();
              String storyId = key.substring(
                key.indexOf("'") + 1,
                key.lastIndexOf("'"),
              );
              index = int.parse(storyId) - 1;
            },
            onComplete: () {
              Navigator.pop(context);
            },
            progressPosition: ProgressPosition.top,
            repeat: false,
            controller: storyController,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  onTapMethod(true);
                },
                child: Container(
                  height: Get.height,
                  width: Get.width / 1.2,
                  color: Colors.white.withOpacity(0),
                ),
              ),
            ),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomRight,
            child: (type[index][0] != "jpg")
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, bottom: 20),
                        child: GestureDetector(
                          onTap: () async {
                            storyController.pause();
                            Uint8List image = await NetworkService()
                                .downloadImage(type[index][1]);
                            // var response = await ImageGallerySaver.saveImage(image);
                            var appDocDir = await getTemporaryDirectory();
                            File file = await File(
                                    '${appDocDir.path}/file_name${DateTime.now()}.png')
                                .writeAsBytes(image);
//  final result = await ImageGallerySaver.saveFile(imagePath);
                            // ShowCapturedWidget(context, image);
                            // print("path ${response['filePath']}");

                            // ignore: deprecated_member_use
                            await Share.shareFiles([(file.path)],
                                text: 'Kuranı Kerim Meali');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.grey.shade900, width: 2)),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, bottom: 20),
                        child: GestureDetector(
                          onTap: () async {
                            await NetworkService()
                                .saveImageToGallery(type[index][1]);
                            Get.snackbar(
                                "dosyaindirildi".tr(), "dosyakaydedildi".tr());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.grey.shade900, width: 2)),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ))
        ],
      ),
    );
  }

  onTapMethod(bool loaded) async {
    bool loadedAd = false;
    final box = Get.find<GetStorage>();
    if (box.hasData("interstitialAdStoryView")) {
      if (box.read("interstitialAdStoryView") == 10) {
        loadedAd = true;
        // AdsHelper().loadInterstitialAd();
        await box.write("interstitialAdStoryView", 1);
      } else {
        var count = box.read("interstitialAdStoryView");
        await box.write("interstitialAdStoryView", count + 1);
      }
    } else {
      await box.write("interstitialAdStoryView", 1);
    }
    if (loadedAd == true) {
      AdsHelper().loadInterstitialAd();
      if (loaded == true) {
        storyController.next();
      }
      Timer(const Duration(seconds: 2), () {
        storyController.pause();
      });
      Timer(const Duration(seconds: 10), () {
        storyController.play();
      });
    } else {
      if (loaded == true) {
        storyController.next();
      }
    }
  }
}
