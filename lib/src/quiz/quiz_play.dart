import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_app/helper/ads.dart';
import 'dart:math' as math;
import 'package:quran_app/src/quiz/quiz_theme.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class QuizPage extends StatefulWidget {
  QuizPage({Key? key, required this.datas}) : super(key: key);
  List datas;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List quests = [];
  Map displayQuest = {};
  Map datas = {};
  int colorIndex = 0;
  bool onClick = false;
  int questInt = 0;
  int clickButton = 0;
  bool finish = false;
  int cevapid = 0;
  bool jokerOne = true;
  bool jokerTwo = true;
  bool jokerOneUse = false;
  bool jokerTwoUse = false;
  bool jokerThreeUse = false;
  int jokerOneInt = 0;
  String image = "";
  List<int> randomList = [0, 1, 2, 3];
  var myBanner = AdsHelper.banner();
  int timerInt = 30;
  Timer? _timer;
  bool timerPause = false;
  AdsHelper myAdReward = AdsHelper();

  @override
  void initState() {
    super.initState();
    start().then((value) => randomQuestGet());
    myBanner.load();
    timer();
  }

  timer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerInt < 1 && !timerPause) {
        AudioPlayer().play(AssetSource('wrong.mp3'));
        setState(() {
          finish = true;
          onClick = true;
          clickButton = -1;
        });
        _timer!.cancel();
      }
      if (timerPause == false) {
        setState(() {
          timerInt--;
        });
      }
    });
  }

  Future start() async {
    quests = widget.datas;
  }

  @override
  void dispose() {
    // Timer'ı iptal etmek için dispose fonksiyonunda cancel metodu çağrılır.
    _timer!.cancel();
    super.dispose();
  }
  //json veri future

  randomQuestGet() {
    //Soru ve Cevapları Rastgele Yerleştirir
    int random = math.Random().nextInt(quests.length);
    displayQuest = quests[random];
    setState(() {
      randomList.shuffle(math.Random());
      questInt++;
      quests.removeAt(random);
      onClick = false;
    });

    //Sorular Bittiğinde Olacaklar
    if (displayQuest.isEmpty || quests.isEmpty) {
      Get.back(
        result: questInt,
      );
      Get.snackbar("", "",
          titleText: Text(
            "nasil".tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          messageText: Text(
            "quizend".tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ));
    }
  }

  alert() {
    setState(() {
      timerPause = true;
    });
    Get.generalDialog(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 300,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                size: 100,
                                color: Colors.white,
                              ),
                            )),
                        flex: 2),
                    Expanded(
                        child: Scaffold(
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            "jokerad".tr(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          )),
                          Center(
                            child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    timerPause = false;
                                    Get.back();
                                  });
                                },
                                child: Text("tamam".tr())),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          );
        },
        barrierColor: Colors.transparent);
  }

  finishAlert() async {
    setState(() {
      timerPause = true;
    });
    timerInt = 30;

    Get.generalDialog(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 300,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            child: const Center(
                              child: Icon(
                                Icons.close,
                                size: 100,
                                color: Colors.white,
                              ),
                            )),
                        flex: 2),
                    Expanded(
                        child: Scaffold(
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        timerPause = false;
                                        Get.back();
                                      });
                                    },
                                    child: Text("geri".tr())),
                                OutlinedButton(
                                    onPressed: () async {
                                      setState(() {
                                        Get.back();
                                      });
                                      await myAdReward.loadInterstitialAd();
                                      await Future.delayed(
                                          const Duration(seconds: 6));
                                      if (myAdReward.isShowReward) {
                                        timerInt = 30;
                                        finish = false;
                                        timerPause = false;
                                        myAdReward.isShowReward =
                                            !myAdReward.isShowReward;
                                        randomQuestGet();
                                        setState(() {
                                          onClick = false;
                                        });
                                      } else {
                                        Get.snackbar("uyari".tr(),
                                            "reklamyuklenemedi".tr());
                                        setState(() {
                                          jokerThreeUse = false;
                                        });
                                      }
                                    },
                                    child: Text("devamet".tr())),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          );
        },
        barrierColor: Colors.transparent);
  }

  final MyTheme _theme = MyTheme();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: onClick
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: finish
                    ? () async {
                        //Oyun Bitiyor ve geriye Skor Değerini Döndürüyor
                        Navigator.pop(context, questInt - 1);
                        int totalwrong = GetStorage().read("totalwrong") ?? 0;
                        await GetStorage().write("totalwrong", totalwrong + 1);
                      }
                    : () async {
                        //Sonraki Sorudan Devam Ediyor
                        jokerOneUse = false;
                        timerPause = false;
                        timerInt = 30;
                        int totalcorrect =
                            GetStorage().read("totalcorrect") ?? 0;
                        await GetStorage()
                            .write("totalcorrect", totalcorrect + 1);
                        randomQuestGet();
                      },
                child: fab(context),
              ),
            )
          : null,
      //Verinin boş olup olmadığını kontrol ediyor
      body: displayQuest.isEmpty || quests.isEmpty
          ? const SizedBox()
          : Stack(
              children: [
                Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/bg.png"),
                          fit: BoxFit.cover)),
                ),
                Column(
                  children: [
                    Expanded(
                      child: SafeArea(
                        child: ListView(
                          children: [
                            questNumber(context),
                            questCard(context),
                            jokerLine(),
                            //Şıklar
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                choices(
                                    context,
                                    randomList[0],
                                    displayQuest["choices"][randomList[0]] ??
                                        ""),
                                choices(
                                    context,
                                    randomList[1],
                                    displayQuest["choices"][randomList[1]] ??
                                        ""),
                                choices(
                                    context,
                                    randomList[2],
                                    displayQuest["choices"][randomList[2]] ??
                                        ""),
                                choices(
                                    context,
                                    randomList[3],
                                    displayQuest["choices"][randomList[3]] ??
                                        "")
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                            )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: myBanner != null
                          ? Container(
                              alignment: Alignment.center,
                              child: AdWidget(ad: myBanner!),
                              width: myBanner!.size.width.toDouble(),
                              height: myBanner!.size.height.toDouble(),
                            )
                          : Container(),
                    )
                  ],
                ),
              ],
            ),
    );
  }

  Padding jokerLine() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          jokerOneFab(),
          jokerTwoFab(),
          jokerThreeFab(),
        ],
      ),
    );
  }

  InkWell jokerOneFab() {
    return InkWell(
      onTap: jokerOne && !finish
          ? () async {
              setState(() {
                jokerOne = false;
              });
              //Burada ilk baş doğru cevabı listeden siliyor sonrada rasgele 2 şıkkı daha sildikten
              //sonra kalan değeri doğru cevapla beraber ekranda gösteriyor
              await myAdReward.loadInterstitialAd();
              await Future.delayed(const Duration(seconds: 6));
              if (myAdReward.isShowReward) {
                alert();
                timerInt = 30;
                myAdReward.isShowReward = !myAdReward.isShowReward;
                List cevaplar = [0, 1, 2, 3];
                cevaplar.removeAt(cevapid);
                cevaplar.removeAt(math.Random().nextInt(3));
                cevaplar.removeAt(math.Random().nextInt(2));
                setState(() {
                  jokerOne = false;
                  jokerOneUse = true;
                  jokerOneInt = cevaplar[0];
                });
              } else {
                Get.snackbar("uyari".tr(), "reklamyuklenemedi".tr());
                setState(() {
                  jokerOne = true;
                });
              }
            }
          : null,
      child: GlassContainer.clearGlass(
        borderRadius: BorderRadius.circular(10000),
        borderColor: Colors.transparent,
        width: 70,
        height: 70,
        blur: 5,
        alignment: Alignment.center,
        color:
            //jokerin önceden kullanılmışmı diye kontrol ediyor
            !jokerOne || finish
                ? _theme.jokerDisColor.withOpacity(0.8)
                : _theme.jokerColor.withOpacity(0.8),
        child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "%50",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 30, color: Colors.white),
            )),
      ),
    );
  }

  InkWell jokerTwoFab() {
    return InkWell(
      onTap: jokerTwo && !finish
          ? () async {
              setState(() {
                jokerTwo = false;
              });
              //Burada ilk baş doğru cevabı listeden siliyor sonrada rasgele 2 şıkkı daha sildikten
              //sonra kalan değeri doğru cevapla beraber ekranda gösteriyor
              await myAdReward.loadInterstitialAd();
              await Future.delayed(const Duration(seconds: 6));
              if (myAdReward.isShowReward) {
                alert();
                timerInt = 30;
                myAdReward.isShowReward = !myAdReward.isShowReward;
                randomQuestGet();
                setState(() {
                  jokerTwo = false;
                  jokerTwoUse = true;
                });
              } else {
                Get.snackbar("uyari".tr(), "reklamyuklenemedi".tr());
                setState(() {
                  jokerTwo = true;
                });
              }
            }
          : null,
      child: GlassContainer.clearGlass(
        borderRadius: BorderRadius.circular(10000),
        borderColor: Colors.transparent,
        width: 70,
        height: 70,
        blur: 5,
        alignment: Alignment.center,
        color:
            //jokerin önceden kullanılmışmı diye kontrol ediyor
            !jokerTwo || finish
                ? _theme.jokerDisColor.withOpacity(0.8)
                : _theme.jokerColor.withOpacity(0.8),
        child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.replay_sharp,
              size: 50,
              color: Colors.white,
            )),
      ),
    );
  }

  InkWell jokerThreeFab() {
    return InkWell(
      onTap: !jokerThreeUse && !finish
          ? () async {
              //sanki doğru cevabı işaretlemişiz gibi değerler atıyor
              setState(() {
                jokerThreeUse = true;
              });
              //Burada ilk baş doğru cevabı listeden siliyor sonrada rasgele 2 şıkkı daha sildikten
              //sonra kalan değeri doğru cevapla beraber ekranda gösteriyor
              await myAdReward.loadInterstitialAd();
              await Future.delayed(const Duration(seconds: 6));
              if (myAdReward.isShowReward) {
                alert();
                timerInt = 30;
                myAdReward.isShowReward = !myAdReward.isShowReward;
                List cevaplar = [0, 1, 2, 3];
                cevaplar.removeAt(cevapid);
                cevaplar.removeAt(math.Random().nextInt(3));
                cevaplar.removeAt(math.Random().nextInt(2));
                setState(() {
                  jokerThreeUse = true;
                  onClick = true;
                  clickButton = cevapid;
                });
              } else {
                Get.snackbar("uyari".tr(), "reklamyuklenemedi".tr());
                setState(() {
                  jokerThreeUse = false;
                });
              }
            }
          : null,
      child: GlassContainer.clearGlass(
        borderRadius: BorderRadius.circular(10000),
        borderColor: Colors.transparent,
        width: 70,
        height: 70,
        blur: 10,
        alignment: Alignment.center,
        color:
            //jokerin önceden kullanılmışmı diye kontrol ediyor
            jokerThreeUse || finish
                ? _theme.jokerDisColor.withOpacity(0.8)
                : _theme.jokerColor.withOpacity(0.8),
        child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "PAS",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 30, color: Colors.white),
            )),
      ),
    );
  }

  Padding questCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GlassContainer.clearGlass(
          borderRadius: BorderRadius.circular(20),
          borderColor: Colors.transparent,
          color: const Color.fromARGB(255, 65, 3, 209).withOpacity(0.4),
          width: MediaQuery.of(context).size.width / 3 * 2.8,
          height: 50 +
              int.parse((displayQuest["question"].length / 50)
                      .toStringAsFixed(0)) *
                  30,
          blur: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayQuest["question"] ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )),
    );
  }

  Widget questNumber(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          SizedBox(
            height: 75,
            width: 75,
            child: CircularStepProgressIndicator(
              totalSteps: 30,
              currentStep: 30 - timerInt,
              stepSize: 1,
              selectedColor: Colors.pink.shade700,
              unselectedColor: Colors.grey.shade600,
              padding: 0,
              selectedStepSize: 8,
              unselectedStepSize: 4,
              roundedCap: (_, __) => true,
              child: const Icon(
                Icons.alarm,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "$questInt",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 50, color: Colors.white),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fab(BuildContext context) {
    return GlassContainer.clearGlass(
      width: 150,
      height: 75,
      color: finish
          ? _theme.backColor.withOpacity(0.5)
          : _theme.jokerColor.withOpacity(0.5),
      borderWidth: 0,
      borderRadius: BorderRadius.circular(1000),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              finish ? "" : "sonraki".tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
            Icon(
              finish ? Icons.arrow_back_ios : Icons.arrow_forward_ios_outlined,
              size: 35,
              color: Colors.white,
            ),
            Text(
              finish ? "geri".tr() : "",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Visibility choices(BuildContext context, int id, String text) {
    //doğru cevap olup olmadığını kontrol ediyor
    bool answer = displayQuest["answer"] == text ? true : false;
    //eğer doğru cevap ise bunu daha sonra kullanmak için bir değere atıyor
    answer == true ? cevapid = id : null;
    return Visibility(
      //burası %50 jokerde silinecek tuşların değerleri
      visible: !(jokerOneUse == true && (cevapid != id && jokerOneInt != id)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            //önce daha önceden tuşlara bastımı diye kontrol ediyor
            //eğer basmamışsa tıklanan tuşu kayıt ediyor cevap yanlış ise oyunu bitiriyor
            timerPause = true;
            if (onClick == false) {
              setState(() {
                onClick = true;
                clickButton = id;
                if (onClick && !answer) {
                  setState(() {
                    finish = true;
                  });
                  AudioPlayer().play(AssetSource('wrong.mp3'));
                  finishAlert();
                } else {
                  AudioPlayer().play(AssetSource('correct.mp3'));
                }
              });
            }
          },
          child: GlassContainer.clearGlass(
            borderRadius: BorderRadius.circular(30),
            borderColor: Colors.white.withOpacity(0.5),
            width: MediaQuery.of(context).size.width / 3 * 2.8,
            height: 100 + int.parse((text.length / 50).toStringAsFixed(0)) * 30,
            //renk ayarları durumlara göre buttonun renkleri
            color: onClick
                ? answer
                    ? _theme.greenColor.withOpacity(0.4)
                    : (clickButton == id)
                        ? _theme.backColor.withOpacity(0.4)
                        : _theme.buttonColor.withOpacity(0.4)
                : _theme.buttonColor.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(color: Colors.white, width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: Icon(
                            onClick
                                ? answer
                                    ? Icons.check
                                    : (clickButton == id)
                                        ? Icons.close
                                        : Icons.close
                                : Icons.quiz_rounded,
                            size: 20,
                            color: onClick ? Colors.white : Colors.transparent,
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

AnimatedContainer myCard(
    {required BuildContext context,
    double? width,
    double? height,
    double opacity = 1,
    String? url,
    required Widget widget,
    Color color = Colors.blue}) {
  return AnimatedContainer(
    duration: const Duration(
      milliseconds: 300,
    ),
    curve: Curves.easeInOut,
    decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        image: url == null
            ? null
            : DecorationImage(
                image: NetworkImage(url), fit: BoxFit.cover, opacity: opacity)),
    width: width,
    height: height,
    child: widget,
  );
}
