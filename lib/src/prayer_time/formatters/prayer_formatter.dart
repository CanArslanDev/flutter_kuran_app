import 'package:easy_localization/easy_localization.dart';

class PrayerFormatter{
  static format(String prayer){
    switch(prayer){
      case "Fajr":
        return "sabah".tr();
      case "Dhuhr":
        return "ogle".tr();
      case "Asr":
        return "ikindi".tr();
      case  "Maghrib":
        return "aksam".tr();
      case "Isha":
        return "yatsi".tr();
      case "Sunrise":
        return "gunes".tr();
    }
  }
}