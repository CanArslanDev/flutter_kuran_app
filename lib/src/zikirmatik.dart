import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibration/vibration.dart';
import '../helper/ads.dart';
import '../datas/list_tr.dart' as TR;
import '../datas/list_en.dart' as EN;
import '../datas/list_fr.dart' as FR;
import '../datas/list_de.dart' as DE;

class ZikirmatikScreen extends StatefulWidget {
  const ZikirmatikScreen({Key? key}) : super(key: key);

  @override
  State<ZikirmatikScreen> createState() => _ZikirmatikScreenState();
}

class _ZikirmatikScreenState extends State<ZikirmatikScreen> {
  List zikirr = [];

  List anlami = [];
  BannerAd? myBanner;
  var langGetZikir = (window.locale.languageCode == "tr"
      ? TR.zikir
      : window.locale.languageCode == "fr"
          ? FR.zikir
          : window.locale.languageCode == "de"
              ? DE.zikir
              : EN.zikir);

  @override
  void initState() {
    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {
      setState(() {});
    });
    langGetZikir.forEach((key, value) {
      zikirr.add(key);
      anlami.add(value);
    });
    super.initState();
  }

  final zikirmatik = 'zikirmatik'.tr();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: myBanner != null
          ? SizedBox(
              height: 50,
              child: AdWidget(
                ad: myBanner!,
              ),
            )
          : Container(),
      appBar: AppBar(
        title: Text(zikirmatik),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box('zikirmatik').listenable(),
          builder: (context, Box box, widget) {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  endIndent: 16,
                  indent: 16,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                );
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ZikirPage(
                              index: index,
                            ),
                          ),
                        );
                      },
                      trailing: SizedBox(
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Text((box.get('counter$index') ?? 0).toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Get.isDarkMode
                                            ? Colors.white.withOpacity(0.5)
                                            : Colors.black)),
                                CircularProgressIndicator(
                                  strokeWidth: 5,
                                  backgroundColor: Colors.grey.withOpacity(0.5),
                                  value: double.parse(
                                          (box.get('counter$index') ?? 0)
                                              .toString()) /
                                      41,
                                  valueColor: const AlwaysStoppedAnimation(
                                      Colors.green),
                                ),
                              ],
                            ),
                            Text((box.get('round$index') ?? 0).toString(),
                                style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.black)),
                          ],
                        ),
                      ),
                      title: Text(
                        zikirr[index],
                        style: TextStyle(
                            fontSize: 20,
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black),
                      ),
                    ),
                  ],
                );
              },
              itemCount: zikirr.length,
            );
          }),
    );
  }
}

class ZikirPage extends StatefulWidget {
  ZikirPage({Key? key, required this.index}) : super(key: key);
  int index;
  @override
  State<ZikirPage> createState() => _ZikirPageState();
}

bool isVibrate = true;
bool sound = true;

class _ZikirPageState extends State<ZikirPage> {
  BannerAd? myBanner;
  var langGetZikir = (window.locale.languageCode == "tr"
      ? TR.zikir
      : window.locale.languageCode == "fr"
          ? FR.zikir
          : window.locale.languageCode == "de"
              ? DE.zikir
              : EN.zikir);

  @override
  void initState() {
    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List zikirr = [];
    List anlami = [];
    var zikirmatik = 'zikirmatik'.tr();
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh),
        onPressed: () async {
          await Hive.box("zikirmatik").put('counter${widget.index}', 0);
          await Hive.box("zikirmatik").put('round${widget.index}', 0);
        },
      ),
      appBar: AppBar(
        title: Text(zikirmatik),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('zikirmatik').listenable(),
        builder: (context, Box box, wid) {
          langGetZikir.forEach((key, value) {
            zikirr.add(key);
            anlami.add(value);
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        zikirr[widget.index],
                        style: TextStyle(
                            fontSize: 30,
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        anlami[widget.index],
                        style: TextStyle(
                            fontSize: 20,
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black),
                      ),
                    ],
                  ),
                )),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (await Vibration.hasVibrator() == true &&
                          isVibrate == true) {
                        Vibration.vibrate();
                      }
                      Hive.box("zikirmatik").put(
                          "counter${widget.index}",
                          Hive.box("zikirmatik").get("counter${widget.index}",
                                  defaultValue: 0) +
                              1);
                      if (Hive.box("zikirmatik")
                              .get("counter${widget.index}") ==
                          41) {
                        Hive.box("zikirmatik").put("counter${widget.index}", 0);
                        Hive.box("zikirmatik").put(
                            "round${widget.index}",
                            Hive.box("zikirmatik").get("round${widget.index}",
                                    defaultValue: 0) +
                                1);
                      }
                      if (sound == true) {
                        AudioPlayer().play(AssetSource('click.mp3'));
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 132,
                          height: MediaQuery.of(context).size.width - 132,
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            value: double.parse(
                                    (box.get('counter${widget.index}') ?? 0)
                                        .toString()) /
                                41,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.green),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            sound
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        sound = false;
                                      });
                                    },
                                    icon: const Icon(Icons.volume_up))
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        sound = true;
                                      });
                                    },
                                    icon: const Icon(Icons.volume_off)),
                            Text('${box.get('counter${widget.index}') ?? 0}',
                                style: TextStyle(
                                    fontSize: 50,
                                    color: Get.isDarkMode
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.black)),
                            Container(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 4,
                              height: 50,
                            ),
                            Container(
                              width: 10,
                            ),
                            Text(
                                (box.get("round${widget.index}") ?? 0)
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 50,
                                    color: Get.isDarkMode
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.black)),
                            isVibrate
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVibrate = false;
                                      });
                                    },
                                    icon: const Icon(Icons.vibration))
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVibrate = true;
                                      });
                                    },
                                    icon: const Icon(Icons.mobile_off)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ), /*
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text((box.get("round${widget.index}") ?? 0).toString(),
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.black.withOpacity(0.5))),
                    isVibrate
                        ? Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVibrate = false;
                                  });
                                },
                                icon: Icon(Icons.vibration)),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isVibrate = true;
                              });
                              print("object");
                            },
                            icon: Icon(Icons.mobile_off)),
                  ],
                ),
                ElevatedButton(
                  child: Text(
                    'Sıfırla',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () async {
                    await box.put('counter${widget.index}', 0);
                    await box.put('round${widget.index}', 0);
                  },
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }
}
