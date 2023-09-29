import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_app/services/supabase_service.dart';
import 'package:quran_app/src/quran/view/pdf_viewer_page.dart';

import '../../../helper/ads.dart';
import '../widget/pdf_card.dart';

class PDFListPage extends StatefulWidget {
  const PDFListPage({Key? key}) : super(key: key);

  @override
  State<PDFListPage> createState() => _PDFListPageState();
}

class _PDFListPageState extends State<PDFListPage> {
  BannerAd? myBanner;
  @override
  void initState() {
    try {
      myBanner = AdsHelper.banner();
      myBanner!.load().then((value) {});
    } catch (e) {}
    super.initState();
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
      appBar: AppBar(
        title: Text("İslami Kitaplar"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: FutureBuilder(
          future: SupabaseService().fetchPDFBooks(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List links = snapshot.data![0];
              List titles = snapshot.data![1];
              return Column(
                children: [
                  for (int i = 0; i < links.length; i++)
                    GestureDetector(
                      onTap: () => Get.to(PdfViewerPage(
                        pdfUrl: links[i],
                        title: titles[i],
                      )),
                      child: PDFCard(
                        title: titles[i],
                      ),
                    )
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      )),
    );
  }
}
