import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:quran_app/helper/ads.dart';
import 'package:quran_app/src/hadeeth/model/hadeeths_model.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:quran_app/src/widgets/app_loading.dart';
import 'package:search_page/search_page.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../widgets/rate_msg.dart';
import '../api/fetch_hadeeths.dart';
import 'hadeeth_page.dart';

class HadeethsPage extends StatefulWidget {
  HadeethsPage(
      {Key? key,
      required this.title,
      required this.id,
      required this.hadeethsCount})
      : super(key: key);
  String title;
  int id;
  int hadeethsCount;
  @override
  State<HadeethsPage> createState() => _HadeethsPageState();
}

const int maxFailedLoadAttempts = 3;

class _HadeethsPageState extends State<HadeethsPage> {
  List<Datum>? data;
  int currentPage = 2;
  BannerAd? myBanner;
  @override
  void initState() {
    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {
      setState(() {});
    });
    _createInterstitialAd();
    AdsHelper.loadOpenAd();
    super.initState();
  }

  final box = Get.find<GetStorage>();
  interstitalAdCheck() async {
    if (box.hasData("interstitialAd")) {
      if (box.read("interstitialAd") == 6) {
        AdsHelper().loadInterstitialAd();
        await box.write("interstitialAd", 1);
      } else {
        var count = box.read("interstitialAd");
        await box.write("interstitialAd", count + 1);
      }
    } else {
      await box.write("interstitialAd", 1);
    }
  }

  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;
  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-4828471636798994/7682437259",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  void dispose() {
    _interstitialAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final box = Get.find<GetStorage>();
        if (box.hasData("rateMsgHadeethDetailPage")) {
          if (box.read("rateMsgHadeethDetailPage") == 20) {
            RateMsg().msg();
            await box.write("rateMsgHadeethDetailPage", 1);
          } else {
            var count = box.read("rateMsgHadeethDetailPage");
            await box.write("rateMsgHadeethDetailPage", count + 1);
          }
        } else {
          await box.write("rateMsgHadeethDetailPage", 1);
        }
        return true;
      },
      child: Scaffold(
          bottomNavigationBar: myBanner == null
              ? Container()
              : SizedBox(
                  width: 320, height: 50, child: AdWidget(ad: myBanner!)),
          appBar: AppBar(
              actions: [
                FutureBuilder<HadeethsModel>(
                    future: fetchAllHadeeths(widget.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return IconButton(
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: SearchPage<Datum>(
                                  items: snapshot.data!.data,
                                  searchLabel: 'hadisara'.tr(),
                                  failure: Center(
                                    child: Text('hadisbulunamadi'.tr()),
                                  ),
                                  filter: (person) => [
                                    person.title,
                                  ],
                                  builder: (person) => ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HadeethPage(
                                                    id: int.parse(person.id),
                                                    title: person.title,
                                                  )));
                                    },
                                    title: Text(
                                      person.title,
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.search));
                      } else {
                        return Container();
                      }
                    })
              ],
              title: Text(
                widget.title,
                style: AppTextStyle.bigTitle,
              )),
          body: FutureBuilder<HadeethsModel>(
              future: fetchHadeeths(widget.id, 1),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  currentPage == 2 ? data = snapshot.data!.data : null;
                  return LazyLoadScrollView(
                    onEndOfPage: () async {
                      fetchHadeeths(widget.id, currentPage).then((value) {
                        if (value.data.isEmpty == false) {
                          List<Datum>? tempData;
                          currentPage++;
                          setState(() {
                            tempData = data;
                          });
                          for (var element in value.data) {
                            tempData!.add(element);
                          }
                          setState(() {
                            data = tempData;
                          });
                        } else {}
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                _interstitialAd == null
                                    ? null
                                    : interstitalAdCheck();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HadeethPage(
                                              title: data![index].title,
                                              id: int.parse(data![index].id),
                                            )));
                              },
                              child: FadeInRight(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withOpacity(0.5)
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(10),
                                      child: Text(data![index].title))),
                            );
                          },
                          itemCount: data!.length),
                    ),
                  );
                } else {
                  return const Center(
                    child: AppLoading(),
                  );
                }
              })),
    );
  }
}
