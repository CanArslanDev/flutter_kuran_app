import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onepref/onepref.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_app/src/app.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await OnePref.init();
  Hive.init((await getApplicationDocumentsDirectory()).path);
  Hive.openBox("zikirmatik");
  await dotenv.load(fileName: ".env");
  String? supabaseUrl = dotenv.get("SUPABASE_URL");
  String? supabaseAnonKey = dotenv.get("SUPABASE_ANON_KEY");

  // local notification initialize
  // Notify.initialize();
  AwesomeNotifications().initialize(
    // 'resource://drawable/res_icon_100',
    null,
    [
      NotificationChannel(
        // channelGroupKey: "reminders",
        channelKey: "basic_notif",
        channelName: "Basic Notifications",
        channelDescription: "Basic notifications of hiQuran",
        channelShowBadge: true,
        defaultColor: ColorPalletes.azure,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
        // channelGroupKey: "reminders",
        channelKey: "schedule_notif",
        channelName: "Schedule Notifications",
        channelDescription: "Schedule notifications of hiQuran",
        channelShowBadge: true,
        defaultColor: ColorPalletes.azure,
        importance: NotificationImportance.High,
      ),
    ],
  );

  // firebase initialize
  await Firebase.initializeApp();

  // supabase initialize
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // local storage initialize
  Get.put<GetStorage>(GetStorage());

  MobileAds.instance.initialize();
  MobileAds.instance
      .updateRequestConfiguration(RequestConfiguration(testDeviceIds: [
    "9294224AD450E55786ABF90A765A7374",
    "3B26A728D3DC5A052403EF83F74E6CAC",
    "23A685756D31A62E5FD58B6ECECBA449"
  ]));

  OneSignal.shared.setAppId("cf47b34c-994f-4061-9ede-c2bba87b3767");

  runApp(
    WillPopScope(
      onWillPop: () async => false,
      child: EasyLocalization(
        supportedLocales: const [
          Locale('tr'),
          Locale('en'),
        ],
        path: 'assets/langs',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    ),
  );
}
