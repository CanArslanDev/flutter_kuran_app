import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:quran_app/bricks/my_widgets/my_button.dart';
import 'package:quran_app/services/supabase_service.dart';
import 'package:quran_app/src/profile/controllers/user_controller.dart';
import 'package:quran_app/src/profile/views/signin_page.dart';
import 'package:quran_app/src/quran/controller/surah_controller.dart';
import 'package:quran_app/src/quran/model/surah.dart';
import 'package:quran_app/src/quran/view/pdf_viewer_page.dart';
import 'package:quran_app/src/quran/view/surah_detail_page.dart';
import 'package:quran_app/src/quran/widget/confirm_delete_favorite.dart';
import 'package:quran_app/src/quran/widget/pdf_card.dart';
import 'package:quran_app/src/quran/widget/shimmer/surah_card_shimmer.dart';
import 'package:quran_app/src/quran/widget/surah_item.dart';
import 'package:quran_app/src/quran/widget/verse_item.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:quran_app/src/widgets/wordpress_list.dart';
import 'package:http/http.dart' as http;
import 'package:unicons/unicons.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../hadeeth/pages/hadeeth_page.dart';
import '../controller/main_page_controller.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool loaded = true;
  final userC = Get.put(UserControllerImpl());
  List favorites = [];
  List pdfFavorites = [];
  List restApiFavorites = [];
  List restApiJsonData = [];
  List hadeethFavorites = [];
  final surahC = Get.put(SurahController());
  // final surahFavoriteC = Get.put(SurahFavoriteController());

  listFavorites() async {
    favorites = await surahC.fetchListOfSurahWithData();
    setState(() {
      loaded = false;
    });
  }

  listPdfFavorites() async {
    pdfFavorites =
        await SupabaseService().pdfGetFavoritesByUserId(userC.user.id!);
    setState(() {
      loaded = false;
    });
  }

  restApiPdfFavorites() async {
    restApiFavorites =
        await SupabaseService().restApiGetFavoritesByUserId(userC.user.id!);
    setState(() {
      loaded = false;
    });
  }

  hadeethFavoritesList() async {
    hadeethFavorites =
        await SupabaseService().hadeethGetFavoritesByUserId(userC.user.id!);
    setState(() {
      loaded = false;
    });
  }

  fetchJsonData() async {
    final response = await http
        .get(Uri.parse('https://kuranikerim.app/wp-json/wp/v2/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonDataValue = jsonDecode(response.body);

      // Gelen verileri işleyin
      for (var data in jsonDataValue) {
        final String title = data['title']['rendered'];
        final String link = data['link'];
        final String content = data['content']['rendered'];
        final String date = data['date'];

        DateTime dateTime = DateTime.parse(date);
        String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
        String image = data['yoast_head_json']['og_image'][0]['url'];

        // İşlenen verileri kullanın
        restApiJsonData.add([title, content, image, formattedDate, link]);
      }
      setState(() {});
    } else {}
  }

  @override
  initState() {
    if (userC.user.id != null) {
      if (surahC.surahFavorites.isEmpty) {
        surahC.fetchSurahFavorites(userC.user.id!);
      }
    }
    listPdfFavorites();
    listFavorites();
    restApiPdfFavorites();
    fetchJsonData();
    hadeethFavoritesList();
    super.initState();
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
          title: Text(
            "favoriler".tr(),
            style: AppTextStyle.bigTitle,
          ),
          actions: [
            Obx(
              () => userC.user.email == null
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        Get.dialog(ConfirmDeleteFavorite(
                          message: "favkaldir".tr(),
                          onCancel: () => Get.back(),
                          onDelete: () {
                            surahC.removeAllFromFavorite(userC.user.id!);
                            SupabaseService()
                                .restApiDeleteUserFavorites(userC.user.id!);
                            SupabaseService()
                                .pdfDeleteUserFavorites(userC.user.id!);
                          },
                        ));
                      },
                      icon: const Icon(
                        UniconsLine.trash,
                      ),
                    ),
            ),
            const SizedBox(width: 8),
          ],
          centerTitle: true,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => userC.user.email == null
                ? FadeIn(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/illustration/cannot-access-state.svg",
                            width: 190,
                          ),
                          const SizedBox(height: 40),
                          Text(
                            "birsorun".tr(),
                            style: AppTextStyle.bigTitle,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "oncegiris".tr(),
                            style: AppTextStyle.normal.copyWith(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          MyButton(
                            width: MediaQuery.of(context).size.width * 0.7,
                            text: "login".tr(),
                            onPressed: () => Get.to(SignInPage()),
                          ),
                        ],
                      ),
                    ),
                  )
                : loaded
                    ? ListView(
                        children: const [
                          SurahCardShimmer(amount: 5),
                        ],
                      )
                    : favorites.isEmpty &&
                            pdfFavorites.isEmpty &&
                            restApiFavorites.isEmpty &&
                            hadeethFavorites.isEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/illustration/empty-state-list-1.svg",
                                  width: 200,
                                ),
                                const SizedBox(height: 40),
                                Text(
                                  "favyok".tr(),
                                  style: AppTextStyle.bigTitle,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "favsureyok".tr(),
                                  style: AppTextStyle.normal.copyWith(
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 1500));
                              surahC.fetchSurahFavorites(userC.user.id!);
                            },
                            backgroundColor: Theme.of(context).cardColor,
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 3,
                            triggerMode: RefreshIndicatorTriggerMode.onEdge,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0;
                                      i < hadeethFavorites.length;
                                      i++)
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HadeethPage(
                                                      title: hadeethFavorites[i]
                                                          ['title'] as String,
                                                      id: hadeethFavorites[i]
                                                          ['hadeeth_id'] as int,
                                                    )));
                                      },
                                      child: FadeInRight(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                              child: Text(hadeethFavorites[i]
                                                  ['title']))),
                                    ),
                                  for (int i = 0;
                                      i < restApiFavorites.length;
                                      i++)
                                    restApiWidget(i),
                                  for (int i = 0; i < pdfFavorites.length; i++)
                                    GestureDetector(
                                        onTap: () => Get.to(PdfViewerPage(
                                            pdfUrl: pdfFavorites[i]['links'],
                                            title: pdfFavorites[i]['title'])),
                                        child: PDFCard(
                                            title: pdfFavorites[i]['title'])),
                                  for (int i = 0; i < favorites.length; i++)
                                    (favorites[i]['item_name'] != null)
                                        ? FadeInDown(
                                            child: InkWell(
                                              highlightColor: Colors.white12,
                                              splashColor: Colors.white12,
                                              onTap: () {
                                                surahC.setRecenlySurah(surahC
                                                    .surahFavorites
                                                    .toList()[i]);
                                                Surah surah = Surah(
                                                    name: favorites[i]
                                                        ['item_name'],
                                                    nameOriginal: favorites[i]
                                                        ['item_name_original'],
                                                    number: int.parse(
                                                        favorites[i]
                                                                ['item_number']
                                                            .toString()),
                                                    numberOfVerses: int.parse(
                                                        favorites[i][
                                                                'item_number_verses']
                                                            .toString()));
                                                Get.to(SurahDetailPage(
                                                    surah: surah));
                                              },
                                              child: SurahItem(
                                                number: int.parse(favorites[i]
                                                    ['item_number']),
                                                name: favorites[i]['item_name'],
                                                numberOfVerses: int.parse(
                                                    favorites[i]
                                                        ['item_number_verses']),
                                                nameOriginal: favorites[i]
                                                    ['item_name_original'],
                                              ),
                                            ),
                                          )
                                        : FadeInDown(
                                            child: VerseItem(
                                              onTapSeeTafsir: () {},
                                              onTapSeeTefsir: () {},
                                              verse: favorites[i]['verse'],
                                              surahName: favorites[i]
                                                  ['verse_surah_name'],
                                              surahNumber: favorites[i]
                                                  ['verse_surah_number'],
                                              verseNumber: favorites[i]
                                                  ['verse_number'],
                                              author: "",
                                              transcription: favorites[i]
                                                  ['verse_transcription'],
                                              textTranslation: favorites[i]
                                                  ['verse_text_transcription'],
                                            ),
                                          )
                                ],
                              ),
                              // child: ListView.separated(
                              //   shrinkWrap: true,
                              //   padding: const EdgeInsets.symmetric(
                              //     horizontal: 20,
                              //     vertical: 20,
                              //   ),
                              //     return Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         FadeInDown(
                              //           child: Slidable(
                              //             closeOnScroll: true,
                              //             startActionPane: ActionPane(
                              //               extentRatio: 0.3,
                              //               motion: const ScrollMotion(),
                              //               children: [
                              //                 SlidableAction(
                              //                   onPressed: (context) {
                              //                     print(userC.user.id.toString());
                              //                     Get.dialog(
                              //                         ConfirmDeleteFavorite(
                              //                       message:
                              //                           "\"${surahC.surahFavorites.toList()[i].name}\" " +
                              //                               "favsurekaldir".tr(),
                              //                       onCancel: () => Get.back(),
                              //                       onDelete: () {
                              //                         surahC
                              //                             .removeFromFavorite(
                              //                               userC.user.id!,
                              //                               surahC.surahFavorites
                              //                                   .toList()[i],
                              //                             )
                              //                             .then((value) =>
                              //                                 Get.back());
                              //                       },
                              //                     ));
                              //                   },
                              //                   backgroundColor: Colors.red,
                              //                   foregroundColor: Colors.white,
                              //                   icon: UniconsLine.trash,
                              //                   autoClose: true,
                              //                   borderRadius:
                              //                       BorderRadius.circular(20),
                              //                 ),
                              //                 const SizedBox(width: 16),
                              //               ],
                              //             ),
                              //             endActionPane: ActionPane(
                              //               extentRatio: 0.3,
                              //               motion: const ScrollMotion(),
                              //               children: [
                              //                 const SizedBox(width: 16),
                              //                 SlidableAction(
                              //                   onPressed: (context) {
                              //                     Get.dialog(
                              //                         ConfirmDeleteFavorite(
                              //                       message:
                              //                           "\"${surahC.surahFavorites.toList()[i].name}\" " +
                              //                               "favsurekaldir".tr(),
                              //                       onCancel: () => Get.back(),
                              //                       onDelete: () {
                              //                         surahC
                              //                             .removeFromFavorite(
                              //                               userC.user.id!,
                              //                               surahC.surahFavorites
                              //                                   .toList()[i],
                              //                             )
                              //                             .then((value) =>
                              //                                 Get.back());
                              //                       },
                              //                     ));
                              //                   },
                              //                   backgroundColor: Colors.red,
                              //                   foregroundColor: Colors.white,
                              //                   icon: UniconsLine.trash,
                              //                   autoClose: true,
                              //                   borderRadius:
                              //                       BorderRadius.circular(20),
                              //                 ),
                              //               ],
                              //             ),
                              //             child: InkWell(
                              //               highlightColor: Colors.white12,
                              //               splashColor: Colors.white12,
                              //               onTap: () {
                              //                 surahC.setRecenlySurah(surahC
                              //                     .surahFavorites
                              //                     .toList()[i]);
                              //                 Get.to(
                              //                   SurahDetailPage(
                              //                     surah: surahC.surahFavorites
                              //                         .toList()[i],
                              //                   ),
                              //                   routeName: 'surah-detail',
                              //                 );
                              //               },
                              //               child: SurahItem(
                              //                 number: surahC.surahFavorites
                              //                     .toList()[i]
                              //                     .number,
                              //                 name: surahC.surahFavorites
                              //                     .toList()[i]
                              //                     .name!,
                              //                 numberOfVerses: surahC
                              //                     .surahFavorites
                              //                     .toList()[i]
                              //                     .numberOfVerses,
                              //                 nameOriginal: surahC.surahFavorites
                              //                     .toList()[i]
                              //                     .nameOriginal,
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     );
                              //   },
                              //   separatorBuilder: (ctx, i) {
                              //     return const SizedBox(height: 10);
                              //   },
                              //   itemCount: surahC.surahFavorites.length,
                              // ),
                            ),
                          ),
          ),
        ),
      ),
    );
  }

  Widget restApiWidget(int i) {
    try {
      return RestApiWidget(
          title: restApiFavorites[i]['title'],
          index: restApiFavorites[i]['index'],
          description: restApiJsonData[restApiFavorites[i]['index']][1],
          image: restApiFavorites[i]['image'],
          date: restApiFavorites[i]['date'],
          links: restApiFavorites[i]['links'],
          loadUser: true,
          userId: userC.user.id!);
    } catch (e) {
      return const SizedBox();
    }
  }
}
