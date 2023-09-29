import 'package:equatable/equatable.dart';

class PrayerTime extends Equatable {
  final DateTime? shubuh;
  final DateTime? sunrise;
  final DateTime? dhuhur;
  final DateTime? ashar;
  final DateTime? maghrib;
  final DateTime? isya;
  final DateTime? middleOfTheNight;
  final DateTime? lastThirdOfTheNight;

  const PrayerTime({
    this.shubuh,
    this.sunrise,
    this.dhuhur,
    this.ashar,
    this.maghrib,
    this.isya,
    this.middleOfTheNight,
    this.lastThirdOfTheNight,
  });

  @override
  List<Object?> get props => [
        shubuh,
        sunrise,
        dhuhur,
        ashar,
        maghrib,
        isya,
        middleOfTheNight,
        lastThirdOfTheNight,
      ];
}

