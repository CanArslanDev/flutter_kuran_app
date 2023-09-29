import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_app/helper/ads.dart';
import 'package:quran_app/src/hadeeth/api/fetch_categories.dart';
import 'package:quran_app/src/hadeeth/model/categories_model.dart';
import 'package:quran_app/src/widgets/app_loading.dart';
import 'package:search_page/search_page.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../quran/controller/main_page_controller.dart';
import '../../settings/theme/app_theme.dart';
import 'hadeeths_page.dart';

class HadeethCategoriesPage extends StatefulWidget {
  const HadeethCategoriesPage({Key? key}) : super(key: key);

  @override
  State<HadeethCategoriesPage> createState() => _HadeethCategoriesPageState();
}

const int maxFailedLoadAttempts = 3;

class _HadeethCategoriesPageState extends State<HadeethCategoriesPage> {
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
            interstitalAdCheck();
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
  void initState() {
    super.initState();

    _createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();

    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var controller = Get.put(MainPageController());
        controller.index.value = 0;
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            FutureBuilder<List<CategoriesModel>>(
                future: fetchHadeethCategories(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: SearchPage<CategoriesModel>(
                              items: snapshot.data!,
                              searchLabel: 'kategoriara'.tr(),
                              failure: Center(
                                child: Text('kategoribulunamadi'.tr()),
                              ),
                              filter: (person) => [
                                person.title,
                              ],
                              builder: (person) => ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HadeethsPage(
                                                id: int.parse(person.id),
                                                title: person.title,
                                                hadeethsCount: int.parse(
                                                    person.hadeethsCount),
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
          centerTitle: true,
          title: Text(
            "hadisler".tr(),
            style: AppTextStyle.bigTitle,
          ),
        ),
        body: FutureBuilder<List<CategoriesModel>>(
            future: fetchHadeethCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(
                      // horizontal: 20,
                      vertical: 20,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        child: GestureDetector(
                          onTap: () async {
                            _interstitialAd == null
                                ? null
                                : _showInterstitialAd();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HadeethsPage(
                                          hadeethsCount: int.parse(snapshot
                                              .data![index].hadeethsCount),
                                          title: snapshot.data![index].title,
                                          id: int.parse(
                                              snapshot.data![index].id),
                                        )));
                          },
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        snapshot.data![index].hadeethsCount,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      if (index % 10 == 8 && index != 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: getAd(),
                        );
                      } else {
                        return const SizedBox(height: 20);
                      }
                    },
                  ),
                );
              } else {
                return const Center(child: AppLoading());
              }
            }),
      ),
    );
  }
}
