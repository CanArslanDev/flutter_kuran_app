import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_app/helper/ads.dart';
import 'package:quran_app/src/quiz/quiz_play.dart';
import 'package:glass_kit/glass_kit.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({Key? key}) : super(key: key);

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  List gameList = [];
  List gameImg = [];
  List dataNormal = [];
  List dataHard = [];
  Map mainData = {};
  var myBanner = AdsHelper.banner();

  @override
  void initState() {
    super.initState();
    start();
    if (GetStorage().read("skor") == null) {
      GetStorage().write("skor", 0);
    }
    myBanner.load();
  }

  Future start() async {
    final String responseNormal = await rootBundle
        .loadString('assets/quiz/normal_' + 'langCode'.tr() + '.json');
    final List decodedDataNormal = json.decode(responseNormal);
    final String responseHard = await rootBundle
        .loadString('assets/quiz/hard_' + 'langCode'.tr() + '.json');
    final List decodedDataHard = json.decode(responseHard);
    setState(() {
      dataNormal = decodedDataNormal;
      dataHard = decodedDataHard;
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          background(context),
          Column(
            children: [
              Expanded(
                child: SafeArea(
                  child: Stack(
                    children: [
                      imageCami(),
                      ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "quiztitle".tr(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize: 50, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          image(context),
                          games(context),
                          skor(context),
                          stats(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Center(
              //   child: myBanner != null
              //       ? Container(
              //           alignment: Alignment.center,
              //           child: AdWidget(ad: myBanner!),
              //           width: myBanner!.size.width.toDouble(),
              //           height: myBanner!.size.height.toDouble(),
              //         )
              //       : Container(),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Row stats(BuildContext context) {
    int totalWrong = GetStorage().read("totalwrong") ?? 0;
    int totalCorrect = GetStorage().read("totalcorrect") ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GlassContainer.clearGlass(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green.withOpacity(0.75),
            borderColor: Colors.white.withOpacity(0.5),
            height: 120,
            width: MediaQuery.of(context).size.width / 2.4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    totalCorrect.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 50, color: Colors.white),
                  ),
                  Text(
                    "toplamdogru".tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 24, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GlassContainer.clearGlass(
            borderRadius: BorderRadius.circular(20),
            color: Colors.red.withOpacity(0.75),
            borderColor: Colors.white.withOpacity(0.5),
            height: 120,
            width: MediaQuery.of(context).size.width / 2.4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    totalWrong.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 50, color: Colors.white),
                  ),
                  Text(
                    "toplamyanlis".tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 24, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row skor(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GlassContainer.clearGlass(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.15),
            height: 120,
            width: MediaQuery.of(context).size.width / 1.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    GetStorage().read("skor").toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 50, color: Colors.white),
                  ),
                  Text(
                    "skor".tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 30, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column imageCami() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Center(
          child: Image.asset(
            "assets/cami.png",
            fit: BoxFit.fitWidth,
            scale: 2,
          ),
        )
      ],
    );
  }

  Container background(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg.png"), fit: BoxFit.cover)),
    );
  }

  Padding image(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GlassContainer.clearGlass(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.1),
        borderColor: Colors.white.withOpacity(0.5),
        width: MediaQuery.of(context).size.width / 1.2,
        height: 200,
        child: myCard(
          context: context,
          color: Colors.transparent,
          widget: Lottie.asset("assets/quizani.json"),
        ),
      ),
    );
  }

  Wrap games(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(2, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Get.to(QuizPage(datas: index == 0 ? dataNormal : dataHard),
                      curve: Curves.easeOut)
                  ?.then((value) {
                start();
                if (GetStorage().read("skor") < value) {
                  setState(() {
                    GetStorage().write("skor", value);
                  });
                }
              });
            },
            child: GlassContainer.clearGlass(
                borderRadius: BorderRadius.circular(20),
                borderColor: Colors.white.withOpacity(0.5),
                color: index == 0
                    ? const Color.fromARGB(255, 65, 3, 209).withOpacity(0.4)
                    : const Color.fromARGB(255, 255, 0, 0).withOpacity(0.4),
                height: 75,
                blur: 10,
                width: (MediaQuery.of(context).size.width / 2 - 20),
                child: Stack(
                  children: [
                    Center(
                        child: Text(
                      index == 0 ? "normal".tr() : "zor".tr(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    )),
                  ],
                )),
          ),
        );
      }),
    );
  }
}
