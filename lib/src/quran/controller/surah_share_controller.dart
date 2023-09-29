import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class SurahShareController extends GetxController {
  Rx<TextStyle> textStyle = GoogleFonts.inter().obs;
  String background = "";
  String title = "";
  String titleTr = "";
  String surahName = "";
  String numberOfVerses = "";
  Rx<bool> viewSurahName = false.obs;
  Rx<bool> transition = false.obs;
  Rx<double> fontSize = 18.0.obs;
  Rx<Color> fontColor = const Color(0xFFFFFFFF).obs;
  Rx<TextAlign> textAlign = TextAlign.center.obs;
  Rx<bool> textStroke = false.obs;
  Rx<bool> textShadow = false.obs;
  Rx<bool> focus = false.obs;
  RxList fonts = [
    {'font': GoogleFonts.inter(), 'name': 'Inter'},
    {'font': GoogleFonts.notoNaskhArabic(), 'name': 'NotoNaskhArabic'},
    {'font': GoogleFonts.oswald(), 'name': 'Oswald'},
    {'font': GoogleFonts.robotoMono(), 'name': 'RobotoMono'},
    {'font': GoogleFonts.gabriela(), 'name': 'Gabriela'},
    {'font': GoogleFonts.turretRoad(), 'name': 'TurretRoad'},
    {'font': GoogleFonts.styleScript(), 'name': 'StyleScript'},
    {'font': GoogleFonts.oleoScript(), 'name': 'OeloScript'},
  ].obs;
  RxList fontsOrg = [
    {'font': GoogleFonts.inter(), 'name': 'Inter'},
    {'font': GoogleFonts.notoNaskhArabic(), 'name': 'NotoNaskhArabic'},
    {'font': GoogleFonts.oswald(), 'name': 'Oswald'},
    {'font': GoogleFonts.robotoMono(), 'name': 'RobotoMono'},
    {'font': GoogleFonts.gabriela(), 'name': 'Gabriela'},
    {'font': GoogleFonts.turretRoad(), 'name': 'TurretRoad'},
    {'font': GoogleFonts.styleScript(), 'name': 'StyleScript'},
    {'font': GoogleFonts.oleoScript(), 'name': 'OeloScript'},
  ].obs;
  RxList fontsTr = [
    {'font': GoogleFonts.manrope(), 'name': 'Manrope'},
    {'font': GoogleFonts.mansalva(), 'name': 'Mansalva'},
    {'font': GoogleFonts.arya(), 'name': 'Arya'},
    {'font': GoogleFonts.allison(), 'name': 'Allison'},
    {'font': GoogleFonts.almendra(), 'name': 'Almendra'},
    {'font': GoogleFonts.teko(), 'name': 'Teko'},
    {'font': GoogleFonts.rampartOne(), 'name': 'RampartOne'},
    {'font': GoogleFonts.akayaTelivigala(), 'name': 'AkayaTelivigala'},
    {'font': GoogleFonts.spicyRice(), 'name': 'SpicyRice'},
  ].obs;
  List colors = [
    Colors.black,
    Colors.grey.shade900,
    Colors.grey.shade700,
    Colors.white,
    Colors.pink.shade100,
    Colors.brown.shade400,
    Colors.blue.shade900,
    Colors.green.shade400,
    Colors.amber.shade700,
    Colors.green.shade900,
    Colors.cyan.shade900,
    Colors.lightBlue.shade900,
  ];
  RxDouble textPositionY = (Get.width / 2.7).obs;

  @override
  void onInit() async {
    super.onInit();
    Permission.manageExternalStorage.request();
    Permission.storage.request();
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }
  }
}
