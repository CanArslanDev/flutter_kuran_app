import 'dart:convert';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart';
import 'package:quran_app/helper/ads.dart';
import 'package:quran_app/src/home/view/home_page.dart';
import 'package:quran_app/src/prayer_time/views/qiblat_page.dart';
import 'package:quran_app/src/quran/controller/main_page_controller.dart';
import 'package:quran_app/src/quran/view/favorite_page.dart';
import 'package:quran_app/src/quran/view/surah_page.dart';
import 'package:quran_app/src/routes.dart';
import 'package:quran_app/src/settings/controller/settings_controller.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:quran_app/src/wrapper.dart';
import 'package:unicons/unicons.dart';
import 'package:wiredash/wiredash.dart';

import 'hadeeth/pages/categories_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  final settingC = Get.put(SettingsController());

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Future<bool> myInterceptor(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    Get.defaultPopGesture;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wiredash(
        projectId: "kuran-g5yio1q",
        secret: "Hi3mkhddtGGJA5cTJZAsM5HpUTQKCnFJ",
        options: const WiredashOptionsData(
          locale: Locale('tr', 'TR'),
        ),
        theme: WiredashThemeData(
          brightness:
              settingC.isDarkMode.value ? Brightness.dark : Brightness.light,
        ),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: "Kuranı Kerim Meali",
          darkTheme: AppTheme.dark,
          theme: AppTheme.light,
          // home: SignInPage(),
          home: Wrapper(),
          // home: HomePage(),
          // home: UploadAvatarPage(),
          // home: MainPage(),
          // initialRoute: "/",
          getPages: Routes.pages,
        ),
      ),
    );
  }
}

class MainPage extends GetView<MainPageController> with WidgetsBindingObserver {
  final box = Get.find<GetStorage>();
  final List<Widget> _pages = [
    const HomePage(),
    SurahPage(),
    // PrayerTimePage(),
    const HadeethCategoriesPage(),
    QiblatPage(),
    // SettingsPage(),
    const FavoritePage(),
    // ProfilePage(),
  ];

  MainPage({Key? key}) : super(key: key);

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

  @override
  var controller = Get.put(MainPageController());
  @override
  Widget build(BuildContext context) {
    controller.myBanner!.dispose();
    controller.myBanner!.load().then((value) {});
    return Obx(() => Scaffold(
          body: _pages[controller.index.value],
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              controller.myBanner != null
                  ? Container(
                      alignment: Alignment.center,
                      child: AdWidget(ad: controller.myBanner!),
                      width: controller.myBanner?.size.width.toDouble(),
                      height: controller.myBanner?.size.height.toDouble(),
                    )
                  : Container(),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [AppShadow.card],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: GNav(
                      rippleColor: Colors.grey[300]!,
                      hoverColor: Colors.grey[100]!,
                      gap: 8,
                      activeColor: Theme.of(context).primaryColor,
                      iconSize: 24,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 12),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      color: Colors.grey,
                      tabMargin: const EdgeInsets.only(top: 4),
                      textStyle: AppTextStyle.normal.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                      tabs: [
                        GButton(
                          icon: UniconsLine.home_alt,
                          text: "anasayfa".tr(),
                        ),
                        GButton(
                          icon: UniconsLine.book_open,
                          text: "kuran".tr(),
                        ),
                        GButton(
                          icon: UniconsLine.books,
                          text: 'hadisler'.tr(),
                        ),
                        GButton(
                          icon: UniconsLine.compass,
                          text: 'kible'.tr(),
                        ),
                        GButton(
                          icon: UniconsLine.heart,
                          text: 'favoriler'.tr(),
                        ),
                      ],
                      selectedIndex: controller.index.value,
                      onTabChange: (index) {
                        controller.index.value = index;
                        interstitalAdCheck();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
