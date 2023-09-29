// ignore_for_file: file_names, library_prefixes

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'helper/ads.dart';
import 'datas/list_tr.dart' as TR;
import 'datas/list_en.dart' as EN;
import 'datas/list_fr.dart' as FR;
import 'datas/list_de.dart' as DE;

class QAPage extends StatefulWidget {
  const QAPage({Key? key}) : super(key: key);

  @override
  State<QAPage> createState() => _QAPageState();
}

class _QAPageState extends State<QAPage> {
  BannerAd? myBanner;
  List soru = [];
  bool isAdLoaded = false;
  List cevap = [];
  var langGet = (window.locale.languageCode == "tr"
      ? TR.qa
      : window.locale.languageCode == "fr"
          ? FR.qa
          : window.locale.languageCode == "de"
              ? DE.qa
              : EN.qa);

  @override
  void initState() {
    langGet.forEach((key, value) {
      soru.add(key);
      cevap.add(value);
    });

    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: const Text("Soru Cevap"),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          if (index % 10 == 9 && index != 0) {
            return Column(
              children: [
                const Divider(
                  color: Colors.black,
                  endIndent: 16,
                  indent: 16,
                ),
                getAd(),
                const Divider(
                  color: Colors.black,
                  endIndent: 16,
                  indent: 16,
                ),
              ],
            );
          }
          return const Divider(
            color: Colors.black,
            endIndent: 16,
            indent: 16,
          );
        },
        itemCount: soru.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(soru[index]),
            subtitle: Text(cevap[index]),
          );
        },
      ),
    );
  }
}
