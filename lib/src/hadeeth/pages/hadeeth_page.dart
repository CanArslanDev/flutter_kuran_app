import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:like_button/like_button.dart';
import 'package:quran_app/services/supabase_service.dart';
import 'package:quran_app/src/hadeeth/api/fetch_hadeeth.dart';
import 'package:quran_app/src/hadeeth/model/hadeeth_model.dart';
import 'package:quran_app/src/profile/views/signin_page.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:quran_app/src/widgets/app_loading.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:unicons/unicons.dart';
import '../../../helper/ads.dart';
import '../../profile/controllers/user_controller.dart';
import '../../quran/view/background_page.dart';
import '../../widgets/forbidden_card.dart';

class HadeethPage extends StatefulWidget {
  HadeethPage({Key? key, required this.title, required this.id})
      : super(key: key);
  String title;
  int id;
  @override
  State<HadeethPage> createState() => _HadeethPageState();
}

class _HadeethPageState extends State<HadeethPage> {
  BannerAd? myBanner;
  final userC = Get.put(UserControllerImpl());
  ValueNotifier<bool> favorite = ValueNotifier(false);
  SupabaseService supabase = SupabaseService();
  @override
  void initState() {
    getFavoriteValue();
    myBanner = AdsHelper.banner();
    myBanner!.load().then((value) {
      setState(() {});
    });

    AdsHelper.loadOpenAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: myBanner == null
            ? Container()
            : SizedBox(
                width: double.parse(myBanner!.size.width.toString()),
                height: double.parse(myBanner!.size.height.toString()),
                child: AdWidget(ad: myBanner!)),
        appBar: AppBar(
          title: Text("hadis".tr()),
          actions: [
            ValueListenableBuilder(
              valueListenable: favorite,
              builder: (context, bool value, child) => LikeButton(
                likeBuilder: (bool isLiked) {
                  return Icon(
                    value
                        ? Icons.favorite
                        : !Get.isDarkMode && isLiked
                            ? Icons.favorite
                            : Get.isDarkMode || !isLiked
                                ? UniconsLine.heart
                                : UniconsLine.heart,
                    color: isLiked && Get.isDarkMode
                        ? Colors.redAccent
                        : Colors.white,
                  );
                },
                circleColor: CircleColor(
                  start: Colors.white,
                  end: !Get.isDarkMode
                      ? Theme.of(context).primaryColor
                      : Colors.redAccent,
                ),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: !Get.isDarkMode
                      ? Theme.of(context).primaryColor
                      : Colors.red,
                  dotSecondaryColor: Colors.white,
                ),
                isLiked: false,
                onTap: (isLiked) async {
                  if (userC.user.id != null) {
                    if (value) {
                      supabase.hadeethRemoveFromFavorites(
                          userC.user.id as int, widget.id);
                      favorite.value = false;
                      // setState(() {
                      //   favorite = !favorite;
                      // });
                    } else {
                      supabase.setHadeethFavorite(
                          userC.user.id as int, widget.id, widget.title);
                      favorite.value = true;
                      // supabase.setSurahFavorite(userC.user.id.toString(),
                      //     widget.surah.number!.toInt(), 0);
                      // setState(() {
                      //   favorite = !favorite;
                      // });
                    }
                  } else {
                    // Get.to(const FavoritePage(), routeName: '/favorite');
                    Get.dialog(ForbiddenCard(
                      onPressed: () {
                        Get.back();
                        Get.to(SignInPage(), routeName: '/login');
                      },
                    ));
                    return false;
                  }
                },
              ),
            ),
            FutureBuilder<HadeethModel>(
                future: fetchHadeeth(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.to(BackgroundPage(
                                titleTr: snapshot.data!.title,
                                numberOfVerses: "0",
                                surahName: snapshot.data!.attribution.substring(
                                    1, snapshot.data!.attribution.length - 1),
                                title: "",
                                viewSurahName: true,
                              ));
                            },
                            icon: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                              child: Image.asset("assets/share_arrow.png"),
                            )),
                        IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: snapshot.data!.hadeeth));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("hadiskopya".tr())));
                            },
                            icon: const Icon(Icons.copy)),
                        IconButton(
                            onPressed: () {
                              Share.share(snapshot.data!.hadeeth);
                            },
                            icon: const Icon(Icons.share))
                      ],
                    );
                  } else {
                    return Container();
                  }
                })
          ],
        ),
        body: FutureBuilder<HadeethModel>(
          future: fetchHadeeth(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    FadeInRight(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "hadis".tr(),
                              style: AppTextStyle.bigTitle,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(snapshot.data!.grade.substring(
                                        1, snapshot.data!.grade.length - 1)),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    FadeInRight(
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
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            child: Text(snapshot.data!.title))),
                    FadeInRight(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
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
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          child: Text(snapshot.data!.attribution.substring(
                              1, snapshot.data!.attribution.length - 1)),
                        ),
                      ),
                    ),
                    FadeInRight(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "aciklama".tr(),
                          style: AppTextStyle.bigTitle,
                        ),
                      ),
                    ),
                    FadeInRight(
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
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          child: Text(snapshot.data!.explanation)),
                    )
                  ],
                ),
              );
            } else {
              return const Center(child: AppLoading());
            }
          },
        ));
  }

  getFavoriteValue() async {
    favorite.value = await SupabaseService()
        .isFavoriteHadeeth(userC.user.id as int, widget.id);
  }
}
