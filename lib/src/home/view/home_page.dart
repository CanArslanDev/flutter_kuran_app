// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_app/bricks/my_widgets/dotted_loading_indicator.dart';
import 'package:quran_app/bricks/my_widgets/notebook_icon.dart';
import 'package:quran_app/name_page.dart';
import 'package:quran_app/qaPage.dart';
import 'package:quran_app/src/articles/controllers/article_controller.dart';
import 'package:quran_app/src/articles/views/articles_page.dart';
import 'package:quran_app/src/articles/widgets/article_card.dart';
import 'package:quran_app/src/articles/widgets/article_card_shimmer.dart';
import 'package:quran_app/src/home/controller/home_controller.dart';
import 'package:quran_app/src/home/view/home_settings_page.dart';
import 'package:quran_app/src/prayer_time/controllers/prayer_time_controller.dart';
import 'package:quran_app/src/prayer_time/views/prayer_time_page.dart';
import 'package:quran_app/src/prayer_time/widgets/prayer_time_card.dart';
import 'package:quran_app/src/prayer_time/widgets/prayer_time_card_shimmer.dart';
import 'package:quran_app/src/profile/controllers/user_controller.dart';
import 'package:quran_app/src/profile/views/profile_page.dart';
import 'package:quran_app/src/quiz/quiz_homepage.dart';
import 'package:quran_app/src/quran/controller/surah_controller.dart';
import 'package:quran_app/src/quran/view/pdf_page.dart';
import 'package:quran_app/src/quran/view/radio_page.dart';
import 'package:quran_app/src/quran/view/surah_detail_page.dart';
import 'package:quran_app/src/quran/view/surah_page.dart';
import 'package:quran_app/src/settings/controller/settings_controller.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:quran_app/src/widgets/app_card.dart';
import 'package:quran_app/src/widgets/exit_msg.dart';
import 'package:quran_app/src/widgets/friday_mesages.dart';
import 'package:quran_app/src/zikirmatik.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';
import '../../../helper/ads.dart';
import '../../../husna_page.dart';
import 'package:quran_app/datas/list_tr.dart' as TR;
import 'package:quran_app/datas/list_en.dart' as EN;
import 'package:quran_app/datas/list_fr.dart' as FR;
import 'package:quran_app/datas/list_de.dart' as DE;
import '../../../services/supabase_service.dart';
import '../../purchase/views/in_app_purchase_page.dart';
import '../../quiz/history_quiz_homepage.dart';
import '../../sound_content/sound_content_page.dart';
import '../../widgets/story_widget.dart';
import '../../widgets/wordpress_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

ValueNotifier<int> imageRnd = ValueNotifier(Random().nextInt(49) + 1);
int rnd = Random().nextInt(49) + 1;

class _HomePageState extends State<HomePage> {
  final userC = Get.put(UserControllerImpl());

  final homeC = Get.put(HomeController());

  final prayerTimeC = Get.put(PrayerTimeControllerImpl());

  final _settingsController = Get.put(SettingsController());

  final surahC = Get.put(SurahController());
  ValueNotifier<List> kuranCardList = ValueNotifier([]);
  final articleC = Get.put(ArticleController());
  AppUpdateInfo? _updateInfo;
  BannerAd? myBanner;
  List name = [];
  List meaning = [];
  List isim = [];
  List<List> isimAnlam = [];
  List erkek = [];
  List<List> erkekAnlam = [];
  List soru = [];
  List cevap = [];
  ValueNotifier<bool> cekildi1 = ValueNotifier(false);
  ValueNotifier<Map> result = ValueNotifier({});
  var langGetData = (window.locale.languageCode == "tr"
      ? TR.data
      : window.locale.languageCode == "fr"
          ? FR.data
          : window.locale.languageCode == "de"
              ? DE.data
              : EN.data);
  var langGetqa = (window.locale.languageCode == "tr"
      ? TR.qa
      : window.locale.languageCode == "fr"
          ? FR.qa
          : window.locale.languageCode == "de"
              ? DE.qa
              : EN.qa);

  var langGetNames = (window.locale.languageCode == "tr"
      ? TR.names
      : window.locale.languageCode == "fr"
          ? FR.names
          : window.locale.languageCode == "de"
              ? DE.names
              : EN.names);
  var langGetErkekIsimleri = (window.locale.languageCode == "tr"
      ? TR.erkekIsimleri
      : window.locale.languageCode == "fr"
          ? FR.erkekIsimleri
          : window.locale.languageCode == "de"
              ? DE.erkekIsimleri
              : EN.erkekIsimleri);

  int rnd99 = Random().nextInt(99);
  int rnd3157 = Random().nextInt(1265);
  int rnd460 = Random().nextInt(460);
  @override
  void initState() {
    randomVerileriCek();
    initializeKuranCardJson();
    langGetqa.forEach((key, value) {
      soru.add(key);
      cevap.add(value);
    });
    langGetData.forEach((key, value) {
      name.add(key);
      meaning.add(value);
    });
    myBanner = AdsHelper.square();
    myBanner!.load().then((value) {
      setState(() {});
    });
    for (var element in langGetNames) {
      isim.add(element.values.first);
      List anlamlar = element.values.toList();
      final val = anlamlar.remove(element.values.first);
      isimAnlam.add(anlamlar);
    }
    for (var element in langGetErkekIsimleri) {
      erkek.add(element.values.first);
      List anlamlar = element.values.toList();
      erkekAnlam.add(anlamlar);
    }
    super.initState();
    randomAyetCek();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });

      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) {});
      } else {}
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await ExitMsg().msg(context).then((value) {
          return value;
        });
        return false;
      },
      child: Scaffold(
        body: SafeArea(
            child: Obx(() => RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      rnd = Random().nextInt(49) + 1;
                    });
                    await Future.delayed(const Duration(milliseconds: 1500));

                    prayerTimeC.getLocation().then((_) {
                      prayerTimeC.cT
                          .restart(duration: prayerTimeC.leftOver.value);
                    });

                    articleC.loadArticleforHome();
                  },
                  backgroundColor: Theme.of(context).cardColor,
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 3,
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  child: ScrollEdgeListener(
                    edge: ScrollEdge.start,
                    edgeOffset: 300,
                    continuous: false,
                    debounce: const Duration(milliseconds: 100),
                    dispatch: false,
                    listener: () {
                      setState(() {
                        rnd = Random().nextInt(49) + 1;
                      });
                    },
                    child: ListView(
                      children: [
                        const SizedBox(height: 16),
                        appbar,
                        stories,
                        prayerCard,
                        firstAd,
                        fridayMessages,
                        quizCard,
                        quizHistoryCard,
                        const SizedBox(height: 10),
                        readKuran,
                        SizedBox(
                          child: homeC.homePageTesbihatCard.value == false
                              ? null
                              : AppCard(
                                  vMargin: 20,
                                  hPadding: 30,
                                  border:
                                      Border.all(width: 2, color: Colors.blue),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/illustration/rosary.svg",
                                            height: 20,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "tesbihat".tr(),
                                            style: AppTextStyle.small.copyWith(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              "resulullahdualar".tr(),
                                              style: AppTextStyle.bigTitle
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          Image.asset(
                                            "assets/illustration/rosary.png",
                                            height: 70,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () => Get.to(ZikirmatikScreen()),
                                        child: Container(
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [AppShadow.card],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "zikirmatik".tr(),
                                              style:
                                                  AppTextStyle.normal.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          child: homeC.homePagePDFCard.value == false
                              ? null
                              : AppCard(
                                  vMargin: 20,
                                  hPadding: 30,
                                  border:
                                      Border.all(width: 2, color: Colors.blue),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            UniconsLine.book_open,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "islamikitap".tr(),
                                            style: AppTextStyle.small.copyWith(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              "islamikitapbilgi".tr(),
                                              style: AppTextStyle.bigTitle
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          Image.asset(
                                            "assets/pdf_icon.png",
                                            height: 90,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            Get.to(const PDFListPage()),
                                        child: Container(
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [AppShadow.card],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "kitaplaragit".tr(),
                                              style:
                                                  AppTextStyle.normal.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          child: homeC.homePagePostCard.value == false
                              ? null
                              : AppCard(
                                  vMargin: 20,
                                  hPadding: 30,
                                  border:
                                      Border.all(width: 2, color: Colors.blue),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            UniconsLine.book_open,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "islamipaylasim".tr(),
                                            style: AppTextStyle.small.copyWith(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              "islamipaylasimbilgi".tr(),
                                              style: AppTextStyle.bigTitle
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.asset(
                                              "assets/restapi_card_bg.jpeg",
                                              height: 90,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () => Get.to(
                                            const WordpressRestApiList()),
                                        child: Container(
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [AppShadow.card],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "paylasimlaragit".tr(),
                                              style:
                                                  AppTextStyle.normal.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          child: homeC.homePagePostCard.value == false
                              ? null
                              : AppCard(
                                  vMargin: 20,
                                  hPadding: 30,
                                  border:
                                      Border.all(width: 2, color: Colors.blue),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            UniconsLine.book_open,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Sesli İçerikler".tr(),
                                            style: AppTextStyle.small.copyWith(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Sesli İçerikler".tr(),
                                                  style: AppTextStyle.bigTitle
                                                      .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                Text(
                                                  "Sesli vaaz - kitap - dua"
                                                      .tr(),
                                                  style: AppTextStyle.normal
                                                      .copyWith(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // ClipRRect(
                                          //   borderRadius:
                                          //       BorderRadius.circular(20),
                                          //   child: Image.asset(
                                          //     "assets/restapi_card_bg.jpeg",
                                          //     height: 90,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () => Get.to(SoundContentPage()),
                                        child: Container(
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [AppShadow.card],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "İçeriklere Git".tr(),
                                              style:
                                                  AppTextStyle.normal.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          child: homeC.homePageAyetCard.value == false
                              ? null
                              : ValueListenableBuilder(
                                  valueListenable: cekildi1,
                                  builder: (context, bool value, child) =>
                                      SizedBox(
                                    child: value == false
                                        ? Container()
                                        : Column(
                                            children: [
                                              for (int i = 0; i < 4; i++)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: FadeInDown(
                                                    from: 50,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: i == 0
                                                            ? Colors
                                                                .red.shade400
                                                            : i == 1
                                                                ? Colors.green
                                                                    .shade400
                                                                : i == 2
                                                                    ? Colors
                                                                        .amber
                                                                        .shade300
                                                                    : Colors
                                                                        .blue
                                                                        .shade400,
                                                        border: Border.all(
                                                            color: Colors.blue,
                                                            width: 2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          20,
                                                        ),
                                                      ),
                                                      child: ArticleCard(
                                                        share: true,
                                                        height: 450,
                                                        color: i == 0
                                                            ? Colors
                                                                .red.shade400
                                                            : i == 1
                                                                ? Colors.green
                                                                    .shade400
                                                                : i == 2
                                                                    ? Colors
                                                                        .amber
                                                                        .shade300
                                                                    : Colors
                                                                        .blue
                                                                        .shade400,
                                                        title: i == 0
                                                            ? result
                                                                .value['ayet']
                                                            : i == 1
                                                                ? result.value[
                                                                    'hadis']
                                                                : i == 2
                                                                    ? result.value[
                                                                        'soz']
                                                                    : result.value[
                                                                        'fihrist'],
                                                        content: i == 0
                                                            ? result.value[
                                                                'ayet_info']
                                                            : i == 1
                                                                ? result.value[
                                                                    'hadis_info']
                                                                : i == 2
                                                                    ? result.value[
                                                                        'soz_info']
                                                                    : result.value[
                                                                        'fihrist_info'],
                                                        author: i == 0
                                                            ? 'Ayet'
                                                            : i == 1
                                                                ? "Hadis"
                                                                : i == 2
                                                                    ? "Hikmetli Sözler"
                                                                    : "Kuran Fihristi",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                  ),
                                ),
                        ),
                        // SizedBox(
                        //   child: homeC.homePageAyetCard.value == false
                        //       ? null
                        //       : Visibility(
                        //           visible: context.locale.languageCode == "tr",
                        //           child: Column(
                        //             children: [
                        //               const SizedBox(height: 30),
                        //               Padding(
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 20),
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     Text(
                        //                       "gununahsf".tr(),
                        //                       style: AppTextStyle.bigTitle
                        //                           .copyWith(
                        //                         fontSize: 13,
                        //                       ),
                        //                     ),
                        //                     InkWell(
                        //                       onTap: () => Get.to(
                        //                           () => const ArticlesPage()),
                        //                       child: Text(
                        //                         "tumunugor".tr(),
                        //                         style:
                        //                             AppTextStyle.small.copyWith(
                        //                           color: Theme.of(context)
                        //                               .primaryColor,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               const SizedBox(
                        //                 height: 20,
                        //               ),
                        //               cekildi == false
                        //                   ? const Padding(
                        //                       padding: EdgeInsets.symmetric(
                        //                           vertical: 16),
                        //                       child: ArticleCardShimmer(),
                        //                     )
                        //                   : FadeInRight(
                        //                       from: 50,
                        //                       child: Padding(
                        //                         padding: const EdgeInsets.only(
                        //                             bottom: 10),
                        //                         child: Padding(
                        //                           padding: const EdgeInsets
                        //                                   .symmetric(
                        //                               horizontal: 16),
                        //                           child: ArticleCard(
                        //                             title: jsonoRandomAyet[
                        //                                 'title'],
                        //                             content:
                        //                                 jsonoRandomAyet['text'],
                        //                             author: "gununayeti".tr(),
                        //                             share: true,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //               const SizedBox(
                        //                 height: 30,
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        // ),
                        SizedBox(
                          child: homeC.homePageRadioCard.value == false
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Radyo",
                                        style: AppTextStyle.bigTitle.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          child: homeC.homePageRadioCard.value == false
                              ? null
                              : FadeInRight(
                                  from: 50,
                                  child: AppCard(
                                    border: Border.all(
                                        color: Colors.blue, width: 2),
                                    vMargin: 10,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Image.asset(
                                                      "assets/radio_page/radio_icon.png",
                                                      height: 120,
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      SizedBox(
                                                        width: 200,
                                                        height: 80,
                                                        child: Text(
                                                          "radyodinle".tr(),
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 22),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      InkWell(
                                                        onTap: () => Get.to(
                                                            const RadioPage()),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            boxShadow: [
                                                              AppShadow.card
                                                            ],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "radyodinlebuton"
                                                                  .tr(),
                                                              style:
                                                                  AppTextStyle
                                                                      .normal
                                                                      .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(
                          child: homeC.homePageEsmaulhusnaCard.value == false
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "esmaulhusna".tr(),
                                        style: AppTextStyle.bigTitle.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            Get.to(() => const HusnaPage()),
                                        child: Text(
                                          "tumisimler".tr(),
                                          style: AppTextStyle.small.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: homeC.homePageEsmaulhusnaCard.value == false
                              ? null
                              : FadeInRight(
                                  from: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Colors.blue, width: 2),
                                        ),
                                        child: ArticleCard(
                                          share: true,
                                          title: name[rnd],
                                          content: meaning[rnd],
                                          author: "guzelisimler".tr() + " ",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          child: homeC.homePageBabyCard.value == false
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "gununismi".tr(),
                                        style: AppTextStyle.bigTitle.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            Get.to(() => const NamePage()),
                                        child: Text(
                                          "tumisimler".tr(),
                                          style: AppTextStyle.small.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: homeC.homePageBabyCard.value == false
                              ? null
                              : FadeInRight(
                                  from: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Container(
                                          //width: 320,
                                          //height: height,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            // vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [AppShadow.card],
                                            border: Border.all(
                                                color: Colors.blue, width: 2),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              36),
                                                      child: Image.asset(
                                                        "assets/icon/icon.png",
                                                        width: 30,
                                                      )),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      "erkekkizisim".tr(),
                                                      style: AppTextStyle.small,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () => Share.share(
                                                          " ${"kadinisim".tr()}: ${isim[rnd3157]}\nAnlamı: ${isimAnlam[rnd3157].toString().replaceAll("[ ", "").replaceAll("[", "").replaceAll("]", "")}\n \n Erkek İsmi: ${erkek[rnd3157]}\nAnlamı: ${erkekAnlam[rnd3157].toString().replaceAll("[ ", "").replaceAll("[", "").replaceAll("]", "")}"),
                                                      icon: const Icon(
                                                          Icons.share))
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                "kadinisim".tr(),
                                                style: AppTextStyle.bigTitle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                isim[rnd3157],
                                                style: AppTextStyle.title,
                                                maxLines: 2,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                isimAnlam[rnd3157]
                                                    .toString()
                                                    .replaceAll("[ ", "")
                                                    .replaceAll("[", "")
                                                    .replaceAll("]", ""),
                                                style: AppTextStyle.normal,
                                                //maxLines: 2,
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                "Erkek İsmi:",
                                                style: AppTextStyle.bigTitle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                erkek[rnd3157],
                                                style: AppTextStyle.title,
                                                maxLines: 2,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                erkekAnlam[rnd3157]
                                                    .toString()
                                                    .replaceAll("[ ", "")
                                                    .replaceAll("[", "")
                                                    .replaceAll("]", ""),
                                                style: AppTextStyle.normal,
                                                //maxLines: 2,
                                              ),
                                              const SizedBox(height: 20),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          child: homeC.homePageQuestionCard.value == false
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "gununsorusu".tr(),
                                        style: AppTextStyle.bigTitle.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            Get.to(() => const QAPage()),
                                        child: Text(
                                          "tumsorular".tr(),
                                          style: AppTextStyle.small.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: homeC.homePageQuestionCard.value == false
                              ? null
                              : FadeInRight(
                                  from: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blue, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ArticleCard(
                                          title: soru[rnd460],
                                          content: cevap[rnd460]
                                              .toString()
                                              .replaceAll("[ ", "")
                                              .replaceAll("[", "")
                                              .replaceAll("]", ""),
                                          author: "soruvecevap".tr(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          child: homeC.homePageImageCard.value == false
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Stack(
                                    children: [
                                      ValueListenableBuilder(
                                          valueListenable: imageRnd,
                                          builder: (BuildContext context,
                                              int counterValue, child) {
                                            return SizedBox(
                                              width: double.infinity,
                                              height: 350,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Image.asset(
                                                    "assets/random_image_" +
                                                        getLang() +
                                                        "/1 copy ${0 + counterValue}.jpg",
                                                    fit: BoxFit.cover,
                                                    alignment: Alignment.center,
                                                  )),
                                            );
                                          }),
                                      Positioned.fill(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15.0, top: 15),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () async {
                                              ByteData bytes = await rootBundle
                                                  .load("assets/random_image_" +
                                                      getLang() +
                                                      "/1 copy ${0 + imageRnd.value}.jpg");
                                              final Uint8List list =
                                                  bytes.buffer.asUint8List();
                                              final Directory
                                                  temporaryDirectory =
                                                  await getTemporaryDirectory();

                                              /// getTemporaryDirectory() is from path_provider
                                              final String path =
                                                  "${temporaryDirectory.path}/image.jpg";
                                              File(path).writeAsBytesSync(list);

                                              /// Type of qrImage is Uint8List
                                              await Share.shareFiles([path]);
                                            },
                                            child: Icon(
                                              Icons.share,
                                              color: Color.fromARGB(
                                                  255, 233, 20, 5),
                                            ),
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          child: homeC.homePageImageCard.value == false
                              ? null
                              : Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () => imageRnd.value =
                                        Random().nextInt(49) + 1,
                                    child: Container(
                                      width: Get.width / 2,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight:
                                                  Radius.circular(15))),
                                      child: Center(
                                        child: Text(
                                          "Resim Değiştir",
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }

  Widget get quizHistoryCard => SizedBox(
        child: homeC.homePageQuizHistoryCard.value == false
            ? null
            : Visibility(
                visible: context.locale.toLanguageTag() == "tr",
                child: FadeInLeft(
                  from: 50,
                  child: AppCard(
                    vPadding: 16,
                    vMargin: 10,
                    border: Border.all(color: Colors.blue, width: 2),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        UniconsLine.book_open,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "quiz".tr(),
                                        style: AppTextStyle.small.copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "anasayfaquiztarih".tr(),
                                    style: AppTextStyle.bigTitle.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "anasayfaquizaciklama".tr(),
                                    style: AppTextStyle.normal,
                                  )
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   child: Image.asset(
                            //     "assets/illustration/quiz.png",
                            //     fit: BoxFit.fitWidth,
                            //   ),
                            //   width: 100,
                            // ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(const HistoryQuizHomePage());
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [AppShadow.card],
                            ),
                            child: Center(
                              child: Text(
                                "quiztitle".tr(),
                                style: AppTextStyle.normal.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );

  Widget get readKuran => SizedBox(
        child: homeC.homePageKuranCard.value == false
            ? null
            : FadeInLeft(
                from: 50,
                child: AppCard(
                  vPadding: 16,
                  border: Border.all(width: 2, color: Colors.blue),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      UniconsLine.book_open,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "sonokuma".tr(),
                                      style: AppTextStyle.small.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Obx(
                                  () => Text(
                                    surahC.recenlySurah.name != null
                                        ? "kuran".tr()
                                        : "birazbekle".tr(),
                                    style: AppTextStyle.bigTitle.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ValueListenableBuilder(
                                  valueListenable: kuranCardList,
                                  builder: (context, List value, child) {
                                    return value == []
                                        ? Obx(
                                            () => surahC.recenlySurah.name !=
                                                    null
                                                ? Text(
                                                    surahC.recenlySurah.name!
                                                            .toString() +
                                                        " " +
                                                        "suresi".tr(),
                                                    style: AppTextStyle.normal,
                                                  )
                                                : Text(
                                                    "kuranokumadi".tr(),
                                                    style: AppTextStyle.small,
                                                  ),
                                          )
                                        : Text(
                                            kuranCardList.value[Random()
                                                .nextInt(kuranCardList
                                                    .value.length)],
                                            style: AppTextStyle.normal,
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(child: Icon3DFb13(), width: 100),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          if (surahC.recenlySurah.name != null) {
                            Get.to(
                              SurahDetailPage(
                                surah: surahC.recenlySurah,
                              ),
                            );
                          } else {
                            Get.to(SurahPage());
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [AppShadow.card],
                          ),
                          child: Center(
                            child: Obx(
                              () => Text(
                                surahC.recenlySurah.name != null
                                    ? "tekraroku".tr()
                                    : "kuranoku".tr(),
                                style: AppTextStyle.normal.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      );

  Widget get quizCard => SizedBox(
        child: homeC.homePageQuizCard.value == false
            ? null
            : Visibility(
                visible: context.locale.toLanguageTag() == "tr",
                child: FadeInLeft(
                  from: 50,
                  child: AppCard(
                    vPadding: 16,
                    vMargin: 10,
                    border: Border.all(color: Colors.blue, width: 2),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        UniconsLine.book_open,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "quiz".tr(),
                                        style: AppTextStyle.small.copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "anasayfaquiz".tr(),
                                    style: AppTextStyle.bigTitle.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "anasayfaquizaciklama".tr(),
                                    style: AppTextStyle.normal,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Image.asset(
                                "assets/illustration/quiz.png",
                                fit: BoxFit.fitWidth,
                              ),
                              width: 100,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(const QuizHomePage());
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [AppShadow.card],
                            ),
                            child: Center(
                              child: Text(
                                "quiztitle".tr(),
                                style: AppTextStyle.normal.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );

  Widget get fridayMessages => SizedBox(
        child: homeC.homePageStoryCard.value == false
            ? null
            : const FridayMessages(
                fridayControl: true,
              ),
      );

  Widget get stories => SizedBox(
        child: homeC.homePageStoryCard.value == false
            ? null
            : Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 20),
                child: FutureBuilder(
                  future: SupabaseService().fetchContentFromSupabase(),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      return StoryViewPage(
                        content1: snapshot.data![0],
                        content2: snapshot.data![1],
                        content3: snapshot.data![2],
                      );
                    } else {
                      return const SizedBox(
                        height: 70,
                      );
                    }
                  },
                ),
              ),
      );

  initializeKuranCardJson() async {
    String data = await rootBundle.loadString('assets/kuran_card.json');
    var jsonResult = json.decode(data);
    kuranCardList.value = jsonResult['titles'];
    print(jsonResult);
    print(jsonResult.runtimeType);
  }

  Widget get prayerCard => SizedBox(
        child: homeC.homePagePrayerCard.value == false
            ? null
            : FadeInRight(
                from: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () => prayerTimeC.isLoadLocation.value
                        ? const PrayerTimeCardShimmer()
                        : GestureDetector(
                            onTap: () => Get.to(
                              PrayerTimePage(),
                            ),
                            child: Hero(
                              tag: 'prayer_time_card',
                              child: PrayerTimeCard(prayerTimeC: prayerTimeC),
                            ),
                          ),
                  ),
                ),
              ),
      );

  Widget get firstAd => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: myBanner != null
              ? Container(
                  alignment: Alignment.center,
                  child: AdWidget(ad: myBanner!),
                  width: myBanner!.size.width.toDouble(),
                  height: myBanner!.size.height.toDouble(),
                )
              : Container(),
        ),
      );

  Widget get appbar => Padding(
        padding: const EdgeInsets.only(right: 20, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => ProfilePage()),
                  child: Obx(
                    () => (userC.user.photoUrl != null)
                        ? Hero(
                            tag: "avatar",
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                userC.user.photoUrl.toString(),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                loadingBuilder: (ctx, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }

                                  return Center(
                                    child: SizedBox(
                                      height: 36,
                                      child: DottedCircularProgressIndicatorFb(
                                        currentDotColor:
                                            _settingsController.isDarkMode.value
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .background
                                                    .withOpacity(0.3)
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.3),
                                        defaultDotColor: _settingsController
                                                .isDarkMode.value
                                            ? Theme.of(context)
                                                .scaffoldBackgroundColor
                                            : Theme.of(context).primaryColor,
                                        numDots: 7,
                                        dotSize: 3,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Hero(
                            tag: "avatarIcon",
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                // color: Colors.red,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.menu,
                                // size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "sa".tr(),
                      style: AppTextStyle.small.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    Obx(
                      () => Text(
                        userC.user.name ?? "kullari".tr(),
                        style: AppTextStyle.title,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
                onPressed: () => Get.to(const HomePageSettings()),
                icon: const Icon(Icons.settings)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ZikirmatikScreen()));
              },
              child: Image.asset(
                "assets/tasbih.png",
                width: 30,
                height: 30,
                color: Theme.of(context).iconTheme.color ?? Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_settingsController.isDarkMode.value) {
                  final box = Get.find<GetStorage>();
                  var primaryColorName = box.read('primaryColor');

                  if (primaryColorName != null) {
                    _settingsController.setTheme(primaryColorName);
                  } else {
                    var listColor = _settingsController.listColor;
                    var listColorName = _settingsController.listColorName;
                    var primaryColor = _settingsController.primaryColor.value;

                    for (var i = 0; i <= 4; i++) {
                      if (listColor[i] == primaryColor) {
                        _settingsController.setTheme(listColorName[i]);
                      }
                    }
                  }
                } else {
                  _settingsController.setDarkMode(true);
                }
              },
              child: Icon(
                _settingsController.isDarkMode.value
                    ? UniconsLine.moon
                    : UniconsLine.sun,
                color: Theme.of(context).iconTheme.color ?? Colors.white,
              ),
            ),
          ],
        ),
      );

  String getLang() {
    if (window.locale.languageCode == "tr") {
      return "tr";
    } else if (window.locale.languageCode == "fr") {
      return "fr";
    } else if (window.locale.languageCode == "de") {
      return "de";
    } else {
      return "en";
    }
  }

  Map jsonoRandomAyet = {};
  bool cekildi = false;

  void randomAyetCek() async {
    var response = await http.get(Uri.parse(
      "https://jovial-curran.45-158-12-188.plesk.page/api/v1/random?apikey=123",
    ));
    jsonoRandomAyet = json.decode(response.body)['ayet'];

    jsonoRandomAyet['text'] = jsonoRandomAyet['ayet'];
    jsonoRandomAyet['title'] = jsonoRandomAyet['ayetNo'];
    setState(() {
      cekildi = true;
    });
  }

  Image img() {
    int min = 0;
    Random rnd1 = Random();
    return Image.asset(
        "assets/random_image/1 copy ${min + rnd1.nextInt(50 - 0)}.jpg");
  }

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

      result.value['ayet'] = jsono['ayet']['ayetNo'];
      result.value['ayet_info'] = jsono['ayet']['ayet'];
      result.value['hadis'] = jsono['hadis']['baslik'];
      result.value['hadis_info'] = jsono['hadis']['hadis'];
      result.value['soz'] = jsono['söz']['kisi'];
      result.value['soz_info'] = jsono['söz']['soz'];

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

      result.value['fihrist'] =
          "'$fihristTitle' " + "alakaliayet".tr(); //jsonFihrist['ayet'];
      result.value['fihrist_info'] = fihristText; //jsonFihrist['fihrist'];

      cekildi1.value = true;
    } catch (e) {
      debugPrint("errorx:$e");
    }
  }
}
