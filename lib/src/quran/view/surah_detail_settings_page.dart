import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock/wakelock.dart';
import '../controller/audio_player_controller.dart';
import '../controller/surah_controller.dart';

class SurahDetailSettingsPage extends StatefulWidget {
  const SurahDetailSettingsPage({Key? key}) : super(key: key);

  @override
  State<SurahDetailSettingsPage> createState() =>
      _SurahDetailSettingsPageState();
}

class _SurahDetailSettingsPageState extends State<SurahDetailSettingsPage> {
  final controller = Get.find<SurahController>();
  bool readerOpen = false;
  bool repeatOpen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Kuran Ayarları",
          style: GoogleFonts.inter(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sayfa Ayarları",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  kuranWidgetAbout1,
                  kuranWidgetAbout2,
                  kuranWidgetAbout3,
                  kuranWidgetAbout4
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Oynatıcı Ayarları",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [reader, repeat, screen, nextSound],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get reader => Column(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              readerOpen = !readerOpen;
            }),
            child: SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Okuyucu",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                controller.verseSounds['names']
                                    [controller.verseSoundIndex.value],
                                style: GoogleFonts.inter(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          )),
                      AnimatedRotation(
                          turns: readerOpen ? 0.25 : 0,
                          duration: const Duration(seconds: 2),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: const Icon(Icons.arrow_forward_ios_rounded)),
                    ]),
              ),
            ),
          ),
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(bottom: 1, left: 1, right: 1),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Container(
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: AnimatedSize(
                duration: const Duration(seconds: 2),
                reverseDuration: const Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: readerOpen ? null : 0,
                  width: 240,
                  child: Obx(() => Column(
                        children: [
                          for (int i = 0;
                              i < controller.verseSounds['names'].length;
                              i++)
                            controller.verseSounds['mealTabIndex'][0] == i
                                ? Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Meal",
                                            style:
                                                GoogleFonts.inter(fontSize: 17),
                                          ),
                                        ),
                                      ),
                                      readerWidget(i),
                                    ],
                                  )
                                : controller.verseSounds['mealTabIndex'][1] == i
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Arapça",
                                                style: GoogleFonts.inter(
                                                    fontSize: 17),
                                              ),
                                            ),
                                          ),
                                          readerWidget(i),
                                        ],
                                      )
                                    : readerWidget(i),
                        ],
                      )),
                ),
              ),
            ),
          )
        ],
      );
  Widget readerWidget(int i) {
    return GestureDetector(
      onTap: () => controller.verseSoundIndex.value = i,
      child: Container(
        decoration: BoxDecoration(
            color: controller.verseSoundIndex.value == i
                ? Colors.blue.withOpacity(0.2)
                : null,
            borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(controller.verseSounds['images'][i]),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(controller.verseSounds['names'][i]),
          ],
        ),
      ),
    );
  }

  Widget get repeat => Column(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              repeatOpen = !repeatOpen;
            }),
            child: SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ayeti Yeniden Çal",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                controller.repeatSoundList[
                                    controller.verseSoundRepeatIndex.value],
                                style: GoogleFonts.inter(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          )),
                      AnimatedRotation(
                          turns: repeatOpen ? 0.25 : 0,
                          duration: const Duration(seconds: 2),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: const Icon(Icons.arrow_forward_ios_rounded)),
                    ]),
              ),
            ),
          ),
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(bottom: 1, left: 1, right: 1),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Container(
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: AnimatedSize(
                duration: const Duration(seconds: 2),
                reverseDuration: const Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: repeatOpen ? null : 0,
                  width: 240,
                  child: Obx(() => Column(
                        children: [
                          for (int i = 0;
                              i < controller.repeatSoundList.length;
                              i++)
                            GestureDetector(
                              onTap: () {
                                controller
                                    .verseSoundRepeatControllerIndex.value = 0;
                                controller.verseSoundRepeatIndex.value = i;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: controller
                                                .verseSoundRepeatIndex.value ==
                                            i
                                        ? Colors.blue.withOpacity(0.2)
                                        : null,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 7),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(controller.repeatSoundList[i])),
                              ),
                            ),
                        ],
                      )),
                ),
              ),
            ),
          )
        ],
      );

  Widget get screen => Container(
        height: 70,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ekran her zaman açık",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Transform.scale(
                scale: 0.8,
                child: Obx(() => CupertinoSwitch(
                    value: controller.alwaysOnScreen.value,
                    onChanged: (value) {
                      controller.alwaysOnScreen.value =
                          !controller.alwaysOnScreen.value;
                      Wakelock.toggle(enable: controller.alwaysOnScreen.value);
                    }))),
          ]),
        ),
      );
  Widget get nextSound => Container(
        height: 70,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sonraki okuyucuya geç",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Transform.scale(
                scale: 0.8,
                child: Obx(() => CupertinoSwitch(
                    value: controller.nextSound.value,
                    onChanged: (value) {
                      controller.nextSound.value = !controller.nextSound.value;
                    }))),
          ]),
        ),
      );

  Widget get kuranWidgetAbout1 => Container(
        height: 70,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hakkında açıklamasını kapat",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Transform.scale(
                scale: 0.8,
                child: Obx(() => CupertinoSwitch(
                    value: controller.showKuranContenWidget1.value,
                    onChanged: (value) {
                      controller.showKuranContenWidget1.value =
                          !controller.showKuranContenWidget1.value;
                    }))),
          ]),
        ),
      );

  Widget get kuranWidgetAbout2 => Container(
        height: 70,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nüzul açıklamasını kapat",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Transform.scale(
                scale: 0.8,
                child: Obx(() => CupertinoSwitch(
                    value: controller.showKuranContenWidget2.value,
                    onChanged: (value) {
                      controller.showKuranContenWidget2.value =
                          !controller.showKuranContenWidget2.value;
                    }))),
          ]),
        ),
      );

  Widget get kuranWidgetAbout3 => Container(
        height: 70,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Konusu açıklamasını kapat",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Transform.scale(
                scale: 0.8,
                child: Obx(() => CupertinoSwitch(
                    value: controller.showKuranContenWidget3.value,
                    onChanged: (value) {
                      controller.showKuranContenWidget3.value =
                          !controller.showKuranContenWidget3.value;
                    }))),
          ]),
        ),
      );

  Widget get kuranWidgetAbout4 => Container(
        height: 70,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Fazileti açıklamasını kapat",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Transform.scale(
                scale: 0.8,
                child: Obx(() => CupertinoSwitch(
                    value: controller.showKuranContenWidget4.value,
                    onChanged: (value) {
                      controller.showKuranContenWidget4.value =
                          !controller.showKuranContenWidget4.value;
                    }))),
          ]),
        ),
      );
}
