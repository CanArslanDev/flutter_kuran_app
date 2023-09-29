// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:quran_app/src/quran/controller/surah_controller.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';

class TefsirView extends StatefulWidget {
  TefsirView(
      {Key? key,
      required this.closeShow,
      required this.surahNumber,
      required this.surahName,
      required this.verseTitle})
      : super(key: key);
  final String? surahName;
  final String? verseTitle;
  final int? surahNumber;
  final void Function() closeShow;

  @override
  State<TefsirView> createState() => _TefsirViewState();
}

class _TefsirViewState extends State<TefsirView> {
  final controller = Get.find<SurahController>();
  String tefsir = "";
  @override
  void initState() {
    getApiAbout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      maxChildSize: 0.95,
      minChildSize: 0.25,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.surahName}",
                    style: GoogleFonts.inter(
                      fontSize: 23,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.closeShow,
                    icon: const Icon(
                      Icons.highlight_remove_rounded,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${widget.surahName}",
                                style: GoogleFonts.inter(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 23,
                                ),
                              ),
                              Container(
                                height: 25,
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text(
                                  "${widget.surahNumber}.Ayet",
                                  style: GoogleFonts.inter(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.verseTitle!,
                              style: GoogleFonts.inter(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Tefsir",
                            style: GoogleFonts.inter(
                              fontSize: 22,
                            ),
                          ),
                          tefsir == ""
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  tefsir,
                                  maxLines: 100,
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: Colors.grey.shade600),
                                ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  getApiAbout() async {
    Response response = await get(Uri.parse(
        "https://api.kimbuldu.com.tr/getsureapi.php?sureadi=${widget.surahName!.toLowerCase()}&datatipi=tefsir&ayetno=${widget.surahNumber}"));
    String data = jsonDecode(json.encode(response.body));
    String temp = "";
    bool run = false;
    for (int i = 0; i < data.length; i++) {
      if (data[i] == "{" && data[i - 1] == ':' || run == true) {
        temp += data[i];
        run = true;
        if (data[i] == "}") {
          run = false;
          break;
        }
      }
    }
    temp += ',{"tefsir_baslangic":1},{"tefsir_bitis":1}]}';
    print(temp);
    Map valueMap = json.decode(temp);
    setState(() {
      tefsir = valueMap["tefsirler"][0]["tefsir"].toString();
    });
  }
}

/*
Flexible(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Text(
                        "Tafsir Ayat ke - $numberInSurah",
                        style: AppTextStyle.title,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "$textTafsir",
                          style: AppTextStyle.normal.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
*/
