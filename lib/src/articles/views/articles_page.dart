import 'dart:convert';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/src/articles/widgets/article_card.dart';
import 'package:quran_app/src/articles/widgets/article_card_shimmer.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../helper/ads.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  BannerAd? myBanner;
  @override
  void initState() {
    super.initState();
    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {
      setState(() {});
    });

    randomVerileriCek();
  }

  @override
  Widget build(BuildContext context) {
    //articleC.loadArticle();

    return Scaffold(
        bottomNavigationBar: myBanner == null
            ? Container()
            : SizedBox(width: 320, height: 50, child: AdWidget(ad: myBanner!)),
        appBar: AppBar(
          title: Text(
            "ahsvf".tr(),
            style: AppTextStyle.bigTitle,
          ),
          centerTitle: true,
          elevation: 1,
          // actions: [
          //   IconButton(
          //     onPressed: () => Get.toNamed(SearchQuranPage.routeName),
          //     icon: const Icon(
          //       UniconsLine.search,
          //     ),
          //   ),
          //   const SizedBox(width: 8),
          // ],
        ),
        body: cekildi == false
            ? ListView.separated(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(
                  // horizontal: 20,
                  vertical: 20,
                ),
                itemBuilder: (context, i) {
                  return const ArticleCardShimmer();
                },
                separatorBuilder: (context, i) {
                  return const SizedBox(height: 20);
                },
                itemCount: 3,
              )
            : ListView.separated(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                itemBuilder: (context, i) {
                  return FadeInDown(
                    from: 50,
                    child: ArticleCard(
                      share: true,
                      height: 450,
                      title: i == 0
                          ? result['ayet']
                          : i == 1
                              ? result['hadis']
                              : i == 2
                                  ? result['soz']
                                  : result['fihrist'],
                      content: i == 0
                          ? result['ayet_info']
                          : i == 1
                              ? result['hadis_info']
                              : i == 2
                                  ? result['soz_info']
                                  : result['fihrist_info'],
                      author: i == 0
                          ? 'Ayet'
                          : i == 1
                              ? "Hadis"
                              : i == 2
                                  ? "Hikmetli Sözler"
                                  : "Kuran Fihristi",
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return const SizedBox(height: 20);
                },
                itemCount: 4,
              ));
  }

  bool cekildi = false;
  Map result = {};
  void randomVerileriCek() async {
    try {
      //random ayet çek:
      /*   String url = "http://54.79.48.6/ayetler/sureler?apikey=1234567890";
      var response0 = await http.get(Uri.parse(url));
      print("response ayet0:${response0.body}");

      List basliklar = json.decode(response0.body);
      Random random = new Random();
      int randomBaslik = random.nextInt(basliklar.length);
      Map jsonBaslik = basliklar[randomBaslik];
      String url2 = jsonBaslik['link'];
      url="http://54.79.48.6/ayetler?apikey=1234567890";
      var response1 = await http.get(Uri.parse(url+"&link=$url2"));
      List listItems = json.decode(response1.body);
      int randomItem = random.nextInt(listItems.length);
      Map jsonAyet = listItems[randomItem];

      print("response ayet1:${response1.body}");


      //random hadis çek
      url = "http://54.79.48.6/hadisler?apikey=1234567890";
      response0 = await http.get(Uri.parse(url));
      print("response ayet0:${response0.body}");

      basliklar = json.decode(response0.body);
      randomBaslik = random.nextInt(basliklar.length);
      jsonBaslik = basliklar[randomBaslik];
      url2 = jsonBaslik['link'];
      response1 = await http.get(Uri.parse("$url&link=$url2"));
      print("response ayet1:${response1.body}");

      listItems = json.decode(response1.body);
      randomItem = random.nextInt(listItems.length);
      Map jsonHadis = listItems[randomItem];

      //random soz çek
      url = "http://54.79.48.6/sozler?apikey=1234567890";
      response0 = await http.get(Uri.parse(url));
      print("response ayet0:${response0.body}");

      basliklar = json.decode(response0.body);
      randomBaslik = random.nextInt(basliklar.length);
      jsonBaslik = basliklar[randomBaslik];
      url2 = jsonBaslik['link'];
      response1 = await http.get(Uri.parse("$url&link=$url2"));
      print("response ayet1:${response1.body}");

      listItems = json.decode(response1.body);
      randomItem = random.nextInt(listItems.length);
      Map jsonSoz = listItems[randomItem];

      //random fihrist çek
      url = "http://54.79.48.6/fihrist?harf=a&apikey=1234567890";
      response0 = await http.get(Uri.parse(url));
      print("response ayet0:${response0.body}");

      basliklar = json.decode(response0.body);
      randomBaslik = random.nextInt(basliklar.length);
      jsonBaslik = basliklar[randomBaslik];
      url2 = jsonBaslik['link'];
      response1 = await http.get(Uri.parse("$url&link=$url2"));
      print("response ayet1:${response1.body}");

      listItems = json.decode(response1.body);
      randomItem = random.nextInt(listItems.length);
      Map jsonFihrist = listItems[randomItem];*/
      var response = await http.get(Uri.parse(
          "https://jovial-curran.45-158-12-188.plesk.page/api/v1/random?apikey=123"));
      Map jsono = json.decode(response.body);

      result['ayet'] = jsono['ayet']['ayetNo'];
      result['ayet_info'] = jsono['ayet']['ayet'];
      result['hadis'] = jsono['hadis']['baslik'];
      result['hadis_info'] = jsono['hadis']['hadis'];
      result['soz'] = jsono['söz']['kisi'];
      result['soz_info'] = jsono['söz']['soz'];

      List fihristler = jsono['fihrist'];
      String fihristTitle = fihristler[0]['baslik'];
      String fihristText = "";

      for (int i = 0; i < fihristler.length; i++) {
        Map element = fihristler[i];
        fihristText += element['fihrist'] + "\n" + element['ayet'];
        if (i + 1 != fihristler.length) {
          fihristText += "\n\n";
        }
      }

      result['fihrist'] =
          "'$fihristTitle' " + "alakaliayet".tr(); //jsonFihrist['ayet'];
      result['fihrist_info'] = fihristText; //jsonFihrist['fihrist'];

      setState(() {
        cekildi = true;
      });
    } catch (e) {
      debugPrint("errorx:$e");
    }
  }
}
