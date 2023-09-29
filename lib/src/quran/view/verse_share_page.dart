import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import '../controller/surah_share_controller.dart';

class VerseSharePage extends GetView<SurahShareController> {
  VerseSharePage({Key? key}) : super(key: key);
  @override
  var controller = Get.put(SurahShareController());

  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    void share() {
      double pixelRatio = MediaQuery.of(context).devicePixelRatio;

      controller.focus.value = false;
      screenshotController
          .captureFromWidget(photo, pixelRatio: pixelRatio)
          .then((image) async {
        // var response = await ImageGallerySaver.saveImage(image);
        var appDocDir = await getTemporaryDirectory();
        File file =
            await File('${appDocDir.path}/file_name${DateTime.now()}.png')
                .writeAsBytes(image);
//  final result = await ImageGallerySaver.saveFile(imagePath);
        // ShowCapturedWidget(context, image);
        // print("path ${response['filePath']}");

        // ignore: deprecated_member_use
        await Share.shareFiles([(file.path)], text: 'Kuranı Kerim Meali');
      }).catchError((onError) {});
    }

    try {
      controller.background = Get.arguments[0];
      controller.title =
          (Get.arguments[1] == "") ? Get.arguments[2] : Get.arguments[1];
      controller.titleTr = Get.arguments[2];
      controller.surahName = Get.arguments[3];
      controller.numberOfVerses = Get.arguments[4];
      controller.viewSurahName.value = Get.arguments[5];
    } catch (e) {
      controller.background = Get.arguments[0];
      controller.title =
          (Get.arguments[1] == "") ? Get.arguments[2] : Get.arguments[1];
      controller.titleTr = Get.arguments[2];
      controller.surahName = Get.arguments[3];
      controller.numberOfVerses = Get.arguments[4];
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(() => share()),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height / 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              photo,
              SizedBox(
                height: Get.width / 30,
              ),
              translation,
              fontSize,
              getFonts,
              getColors,
              bottomBar,
            ],
          ),
        ),
      ),
    );
  }

  Widget get photo => SizedBox(
        width: Get.width / 1.5,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => controller.focus.value = false,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  controller.background,
                  height: Get.height / 2.1,
                  width: Get.width / 1.5,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.asset(
                          "assets/icon/icon.png",
                          height: Get.height / 30,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          "meal".tr(),
                          style: GoogleFonts.inter(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() => Positioned(
                  top: controller.textPositionY.value,
                  left: 0,
                  child: GestureDetector(
                    onPanUpdate: (tapInfo) {
                      controller.textPositionY.value += tapInfo.delta.dy;
                      controller.focus.value = true;
                    },
                    onTap: () => controller.focus.value = true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.5),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: (controller.focus.value == false)
                                    ? Border.all(
                                        color: Colors.transparent, width: 2)
                                    : Border.all(
                                        color: Colors.white, width: 2)),
                            width: Get.height / 3.35,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.only(
                                right: 10, top: 10, left: 4),
                            child: Column(
                              children: [
                                Obx(() => Text(
                                    (controller.transition.value == false)
                                        ? controller.title
                                        : controller.titleTr.tr(),
                                    textAlign: controller.textAlign.value,
                                    style: controller.textStyle.value.copyWith(
                                        fontSize: controller.fontSize.value,
                                        color: controller.fontColor.value,
                                        shadows: [
                                          (controller.textStroke.value == false)
                                              ? const Shadow()
                                              : Shadow(
                                                  // bottomLeft
                                                  offset:
                                                      const Offset(-1.5, -1.5),
                                                  color: (controller.fontColor
                                                              .value ==
                                                          Colors.white)
                                                      ? Colors.black
                                                      : Colors.white),
                                          (controller.textStroke.value == false)
                                              ? const Shadow()
                                              : Shadow(
                                                  // bottomRight
                                                  offset:
                                                      const Offset(1.5, -1.5),
                                                  color: (controller.fontColor
                                                              .value ==
                                                          Colors.white)
                                                      ? Colors.black
                                                      : Colors.white),
                                          (controller.textStroke.value == false)
                                              ? const Shadow()
                                              : Shadow(
                                                  // topRight
                                                  offset:
                                                      const Offset(1.5, 1.5),
                                                  color: (controller.fontColor
                                                              .value ==
                                                          Colors.white)
                                                      ? Colors.black
                                                      : Colors.white),
                                          (controller.textStroke.value == false)
                                              ? const Shadow()
                                              : Shadow(
                                                  // topLeft
                                                  offset:
                                                      const Offset(-1.5, 1.5),
                                                  color: (controller.fontColor
                                                              .value ==
                                                          Colors.white)
                                                      ? Colors.black
                                                      : Colors.white),
                                          (controller.textShadow.value == false)
                                              ? const Shadow()
                                              : Shadow(
                                                  offset: const Offset(3, 3),
                                                  blurRadius: 5,
                                                  color: (controller.fontColor
                                                              .value ==
                                                          Colors.white)
                                                      ? Colors.black
                                                          .withOpacity(0.6)
                                                      : Colors.white)
                                        ]))),
                                Container(
                                  child: (Get.arguments[1] == "")
                                      ? Container(
                                          child: (controller
                                                      .viewSurahName.value ==
                                                  false)
                                              ? null
                                              : Obx(() => Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 10.0,
                                                      ),
                                                      child: Text(
                                                        controller.surahName,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: controller
                                                            .textStyle.value
                                                            .copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        )
                                      : Obx(() => Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10.0,
                                              ),
                                              child: Text(
                                                "${controller.surahName}, ${controller.numberOfVerses}.${"ayet".tr()}",
                                                textAlign: TextAlign.end,
                                                style: controller
                                                    .textStyle.value
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                              ],
                            ),
                          ),
                          (controller.focus.value == false)
                              ? Container()
                              : Positioned.fill(
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: const Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.add,
                                              size: 15,
                                            ),
                                          ))),
                                ),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      );

  Widget get translation => Container(
        child: (Get.arguments[1] == "")
            ? Container()
            : Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Get.height / 19,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (controller.transition.value == true) {
                                controller.transition.value = false;
                                controller.fonts.value = controller.fontsOrg;
                                controller.textStyle.value =
                                    controller.fonts[0]['font'];
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                height: Get.height / 19,
                                width: Get.width / 5,
                                decoration: BoxDecoration(
                                    color:
                                        (controller.transition.value == false)
                                            ? Colors.white
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                    child: Text(
                                  'arapcameal'.tr(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                if (controller.transition.value == false) {
                                  controller.transition.value = true;
                                  controller.fonts.value = controller.fontsTr;
                                  controller.textStyle.value =
                                      controller.fonts[0]['font'];
                                }
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                height: Get.height / 19,
                                width: Get.width / 5,
                                decoration: BoxDecoration(
                                    color: (controller.transition.value == true)
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                    child: Text(
                                  'arapcamealtr'.tr(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
      );

  AppBar appBar(VoidCallback callback) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent, // Navigation bar
        statusBarColor: Colors.transparent, // Status bar
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 6),
          child: ElevatedButton(
            onPressed: () {
              callback();
            },
            child: Text("share".tr()),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                backgroundColor: Colors.green.shade800,
                elevation: 0),
          ),
        ),
      ],
    );
  }

  Widget get fontSize => Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'fontsize'.tr(),
            style: const TextStyle(fontSize: 14),
          ),
          SizedBox(
            width: Get.width / 1.5,
            child: SliderTheme(
              data: SliderTheme.of(Get.context!).copyWith(
                activeTrackColor: Colors.green.shade900,
                inactiveTrackColor: Colors.grey.shade400,
                trackShape: const RectangularSliderTrackShape(),
                trackHeight: 2.0,
                thumbColor: Colors.green.shade900,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 5.0),
                overlayColor: Colors.red.withAlpha(32),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 28.0),
              ),
              child: Slider(
                value: controller.fontSize.value,
                onChanged: (onChanged) => controller.fontSize.value = onChanged,
                max: 60,
                min: 10,
              ),
            ),
          ),
          Text(
            "${controller.fontSize.value.toInt()} pt",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ));

  Widget get bottomBar => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.textAlign.value == TextAlign.center) {
                      controller.textAlign.value = TextAlign.left;
                    } else if (controller.textAlign.value == TextAlign.left) {
                      controller.textAlign.value = TextAlign.right;
                    } else {
                      controller.textAlign.value = TextAlign.center;
                    }
                  },
                  child: Icon(
                    (controller.textAlign.value == TextAlign.center)
                        ? Icons.format_align_center_sharp
                        : (controller.textAlign.value == TextAlign.left)
                            ? Icons.format_align_left
                            : Icons.format_align_right,
                    color: Colors.green.shade700,
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.textStroke.value =
                      !controller.textStroke.value,
                  child: Icon(
                    Icons.text_fields_outlined,
                    color: (controller.textStroke.value == false)
                        ? Colors.black
                        : Colors.green.shade700,
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.textShadow.value =
                      !controller.textShadow.value,
                  child: Icon(
                    Icons.text_format_outlined,
                    color: (controller.textShadow.value == false)
                        ? Colors.black
                        : Colors.green.shade700,
                  ),
                ),
              ],
            )),
      );

  Widget get getColors => Container(
        height: Get.height / 13,
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1),
                bottom: BorderSide(color: Colors.grey.shade200, width: 1))),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(
              width: 5,
            ),
            for (int i = 0; i < controller.colors.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: GestureDetector(
                  onTap: () =>
                      controller.fontColor.value = controller.colors[i],
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        border: (controller.colors[i] == Colors.white)
                            ? Border.all(color: Colors.black, width: 1)
                            : null,
                        shape: BoxShape.circle,
                        color: controller.colors[i]),
                  ),
                ),
              ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      );

  Widget get getFonts => Obx(() => Container(
        height: Get.height / 13,
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1),
                bottom: BorderSide(color: Colors.grey.shade200, width: 1))),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(
              width: 5,
            ),
            for (int i = 0; i < controller.fonts.length; i++)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: GestureDetector(
                    onTap: () => controller.textStyle.value =
                        controller.fonts[i]['font'],
                    child: Text(
                      controller.fonts[i]['name'],
                      style: controller.fonts[i]['font'],
                    ),
                  ),
                ),
              ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ));
}
