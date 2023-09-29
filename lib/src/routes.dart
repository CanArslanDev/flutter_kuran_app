import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:quran_app/src/settings/settings_page.dart';

import 'home/view/home_page.dart';
import 'prayer_time/views/prayer_time_page.dart';
import 'prayer_time/views/qiblat_page.dart';
import 'quran/view/search_surah_page.dart';
import 'quran/view/surah_page.dart';
import 'wrapper.dart';

abstract class Routes {
  static List<GetPage<dynamic>>? pages = [
    GetPage(name: "/", page: () => exitmsg(Wrapper())),
    GetPage(name: "/home", page: () => exitmsg(const HomePage())),
    GetPage(name: "/surah", page: () => exitmsg(SurahPage())),
    GetPage(name: "/prayer-times", page: () => exitmsg(PrayerTimePage())),
    GetPage(name: "/qiblat", page: () => exitmsg(QiblatPage())),
    GetPage(name: "/setting", page: () => exitmsg(const SettingsPage())),
    GetPage(
      name: SearchQuranPage.routeName,
      page: () => exitmsg(SearchQuranPage()),
    )
  ];
}

exitmsg(Widget child) =>
    WillPopScope(onWillPop: () async => false, child: child);
