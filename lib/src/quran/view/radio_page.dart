import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_app/src/quran/controller/radio_page_controller.dart';

class RadioPage extends GetView<RadioPageController> {
  const RadioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RadioPageController controller = Get.put(RadioPageController());
    return Obx(() => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'radyo'.tr(),
              style:
                  GoogleFonts.inter(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          body: SizedBox(
              height: Get.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        radioTitleVoid,
                        loadRadio,
                      ],
                    ),
                  )),
                  bottomBar,
                ],
              )),
          // body: Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       ElevatedButton(
          //           onPressed: () {
          //             controller.isPlaying ? controller.radioPlayer.pause() : controller.radioPlayer.play();
          //           },
          //           child: Text(controller.isPlaying ? "Durdur" : "Çal")),
          //       Row(
          //         children: [
          //           ElevatedButton(
          //               onPressed: () {
          //                 controller.changeRadioIndex(false);
          //               },
          //               child: Text("Radyo değiştir")),
          //           ElevatedButton(
          //               onPressed: () {
          //                 controller.changeRadioIndex(true);
          //               },
          //               child: Text("Radyo değiştir"))
          //         ],
          //       )
          //     ],
          //   ),
          // ),
        ));
  }

  Widget get bottomBar => Column(
        children: [
          SizedBox(
              width: double.parse(controller.myBanner!.size.width.toString()),
              height: double.parse(controller.myBanner!.size.height.toString()),
              child: AdWidget(ad: controller.myBanner!)),
          Container(
            height: 150,
            decoration: BoxDecoration(
                border: const Border(
                    top: BorderSide(color: Color(0xFFCCCCCC), width: 2)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFD9D9D9).withOpacity(0),
                      const Color(0xFFD9D9D9)
                    ])),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => controller.changeRadioIndex(false),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: const Color(0xFF00D254),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                            "assets/radio_page/previous_icon.svg"),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.isPlaying.value
                        ? controller.radioPlayer.pause()
                        : controller.radioPlayer.play(),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF00D254),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SvgPicture.asset(controller.isPlaying.value
                            ? "assets/radio_page/pause_icon.svg"
                            : "assets/radio_page/play_icon.svg"),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.changeRadioIndex(true),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: const Color(0xFF00D254),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:
                            SvgPicture.asset("assets/radio_page/next_icon.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget get radioTitleVoid => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "radyolar".tr(),
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 33),
          ),
          Text(
            "radyodinlesayfa".tr(),
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.6),
                fontSize: 24),
          ),
        ],
      );

  Widget get loadRadio => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          for (int i = 0; i < controller.radios.length; i++)
            InkWell(
              onTap: () => controller.setRadioIndex(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 20, // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.network(
                              controller.radios[i]['icon'],
                              height: 40,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            controller.radios[i]['title'],
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          controller.radioIndex == i &&
                                  controller.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow_rounded,
                          size: 40,
                          color: const Color(0xFF00D254),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
}
