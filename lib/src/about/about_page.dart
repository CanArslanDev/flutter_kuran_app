import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/src/about/options.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade500,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade500,
        title: Text("Hakkımızda"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Container(
            color: Colors.indigo.shade400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      child: Image.asset(
                        'assets/icon/icon.png',
                        width: 100,
                      ),
                    ),
                  ),
                  Text(
                    'Kuranı Kerim Türkçe Meali',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Amacımız:',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'İslam\'ın en kolay şekilde öğrenilmesidir!',
                    style: GoogleFonts.inter(
                        color: Colors.cyan.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: Get.width / 1.2,
                    child: Text(
                      '\'Kuranı Kerim Türkçe Meali\' uygulamasının kolay ve anlaşılır olmasına özen gösterdik. '
                      'Hadisi şerifte: Kim bir hayra (iyiliğe) vesile olursa o kimseye hayrı yapan kimsenin ecri gibi ecir vardır. '
                      'Dualarınızı eksik etmeyiniz '
                      '\'O Allah yoluna ki göklerde ne var yerde ne varsa hep Onundur Dikkat edin Bütün işler döner sonunda Allaha varır Şûrâ Suresi 53. Ayet',
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.inter(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  ...List.generate(
                    generalOptions.length,
                    (index) => Column(
                      children: [
                        Divider(
                          height: 40,
                        ),
                        generalOptionCard(
                          // imagePath: generalOptions[index].imagePath,
                          index,
                          generalOptions[index].imagePath,
                          generalOptions[index].title,
                          generalOptions[index].subtitle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  generalOptionCard(
      int index, String imagePath, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          Share.share(
              "https://play.google.com/store/apps/details?id=com.kuran.mealii");
        }
      },
      child: Container(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                imagePath,
                width: Get.width / 10,
                color: const Color(0xFF0AFFA1).withOpacity(0.8),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width / 1.35,
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: Get.width / 1.35,
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
