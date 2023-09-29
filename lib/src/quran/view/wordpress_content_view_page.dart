import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';

import '../../../helper/ads.dart';

class WordpressContentViewPage extends StatefulWidget {
  const WordpressContentViewPage(
      {Key? key,
      required this.title,
      required this.description,
      required this.date,
      required this.image,
      required this.link})
      : super(key: key);
  final String title;
  final String description;
  final String date;
  final String image;
  final String link;

  @override
  State<WordpressContentViewPage> createState() =>
      _WordpressContentViewPageState();
}

class _WordpressContentViewPageState extends State<WordpressContentViewPage> {
  BannerAd? myBanner;
  @override
  void initState() {
    super.initState();
    try {
      myBanner = AdsHelper.banner();
      myBanner!.load().then((value) {});
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
          child: (myBanner == null)
              ? null
              : SizedBox(
                  width: double.parse(myBanner!.size.width.toString()),
                  height: double.parse(myBanner!.size.height.toString()),
                  child: AdWidget(ad: myBanner!))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(widget.image),
              Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: HtmlWidget(widget.description)),
              Text(widget.date),
              GestureDetector(
                onTap: () => Share.share(widget.link),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 1,
                          color: Colors.black.withOpacity(0.2),
                        )
                      ]),
                  child: SizedBox(
                    width: 250,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "https://kuranikerim.app/wp-content/uploads/2023/06/logo.webp",
                            height: 50,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "İçeriği Paylaş",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
