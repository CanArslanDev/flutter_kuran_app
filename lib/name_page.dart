// ignore_for_file: library_prefixes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'helper/ads.dart';
import 'datas/list_tr.dart' as TR;
import 'datas/list_en.dart' as EN;
import 'datas/list_fr.dart' as FR;
import 'datas/list_de.dart' as DE;

class NamePage extends StatefulWidget {
  const NamePage({Key? key}) : super(key: key);

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  List erkekIsim = [];
  List erkekIsimAnlam = [];
  List kizIsim = [];
  List kizIsimAnlam = [];
  BannerAd? myBanner;
  var langGetNames = (window.locale.languageCode == "tr"
      ? TR.names
      : window.locale.languageCode == "fr"
          ? FR.names
          : window.locale.languageCode == "de"
              ? DE.names
              : EN.names);
  var langGetNamesErkekIsimleri = (window.locale.languageCode == "tr"
      ? TR.names
      : window.locale.languageCode == "fr"
          ? FR.names
          : window.locale.languageCode == "de"
              ? DE.names
              : EN.names);
  @override
  void initState() {
    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {
      setState(() {});
    });
    for (var element in langGetNames) {
      kizIsim.add(element.values.first);
      List anlamlar = element.values.toList();
      kizIsimAnlam.add(anlamlar);
    }
    for (var element in langGetNamesErkekIsimleri) {
      erkekIsim.add(element.values.first);
      List anlamlar = element.values.toList();
      erkekIsimAnlam.add(anlamlar);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var names = "names".tr();
    var girlNames = "girlNames".tr();
    var boyNames = "boyNames".tr();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          title: Text(names),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Çocuğunuza İsimler",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.black,
                  endIndent: 16,
                  indent: 16,
                );
              },
              itemCount: kizIsim.length,
              itemBuilder: (context, index) {
                if (index % 10 == 0 && index != 0) {
                  BannerAd? myBannerVoid = AdsHelper.banner();
                  myBannerVoid?.load();
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: AdWidget(ad: myBannerVoid!),
                        width: myBannerVoid.size.width.toDouble(),
                        height: myBannerVoid.size.height.toDouble(),
                      ),
                      ListTile(
                        title: Text(kizIsim[index]),
                        subtitle: Text(kizIsimAnlam[index]
                            .toString()
                            .replaceAll("[ ", "")
                            .replaceAll("[", "")
                            .replaceAll("]", "")),
                      ),
                    ],
                  );
                } else {
                  return ListTile(
                    title: Text(kizIsim[index]),
                    subtitle: Text(kizIsimAnlam[index]
                        .toString()
                        .replaceAll("[ ", "")
                        .replaceAll("[", "")
                        .replaceAll("]", "")),
                  );
                }
              },
            ),
            ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.black,
                  endIndent: 16,
                  indent: 16,
                );
              },
              itemCount: erkekIsim.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(erkekIsim[index]),
                  subtitle: Text(erkekIsimAnlam[index]
                      .toString()
                      .replaceAll("[ ", "")
                      .replaceAll("[", "")
                      .replaceAll("]", "")),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
