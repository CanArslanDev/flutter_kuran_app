import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:unicons/unicons.dart';

import '../../../services/supabase_service.dart';
import '../../profile/controllers/user_controller.dart';
import '../../profile/views/signin_page.dart';
import '../../widgets/forbidden_card.dart';
import '../view/background_page.dart';

class VerseItem extends StatefulWidget {
  const VerseItem({
    Key? key,
    this.verse,
    this.textTranslation,
    this.verseNumber,
    this.transcription,
    this.author,
    this.surahName,
    required this.onTapSeeTafsir,
    this.surahNumber,
    required this.onTapSeeTefsir,
  }) : super(key: key);
  final String? verse;
  final String? textTranslation;
  final int? surahNumber;
  final int? verseNumber;
  final String? transcription;
  final String? author;
  final String? surahName;
  final void Function() onTapSeeTafsir;
  final void Function() onTapSeeTefsir;

  @override
  State<VerseItem> createState() => _VerseItemState();
}

class _VerseItemState extends State<VerseItem> {
  bool firstOpening = false;

  SupabaseService supabase = SupabaseService();

  final userC = Get.put(UserControllerImpl());

  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    initDatabaseData() async {
      favorite = await supabase.getSurahFavoritesData("SurahFavorites",
          userC.user.id.toString(), widget.surahNumber!, widget.verseNumber!);
      if (firstOpening == false) {
        if (mounted) {
          setState(() {
            firstOpening = true;
          });
        }
      }
    }

    // controller.resetVerses();
    initDatabaseData();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppShadow.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.surahName}",
                style: AppTextStyle.normal.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      "${widget.verseNumber}",
                      style: AppTextStyle.normal.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "${widget.author}",
                style: AppTextStyle.normal.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                "${widget.verse}",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Uthmani",
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${widget.transcription}",
            style: AppTextStyle.normal.copyWith(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.textTranslation!.replaceAll(RegExp('\\[.*?\\]'), ''),
            style: AppTextStyle.normal.copyWith(fontSize: 14),
            textAlign: TextAlign.start,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 10),
                child: GestureDetector(
                  onTap: () => Get.to(BackgroundPage(
                    titleTr: widget.textTranslation!
                        .replaceAll(RegExp('\\[.*?\\]'), ''),
                    title: widget.verse!,
                    surahName: widget.surahName!,
                    numberOfVerses: widget.verseNumber.toString(),
                  )),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green.shade100, shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        "assets/share_icon.png",
                        width: Get.width / 23,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 10),
                child: GestureDetector(
                  onTap: () => Get.to(BackgroundPage(
                    titleTr: widget.textTranslation!
                        .replaceAll(RegExp('\\[.*?\\]'), ''),
                    title: widget.verse!,
                    surahName: widget.surahName!,
                    numberOfVerses: widget.verseNumber.toString(),
                  )),
                  child: GestureDetector(
                    onTap: () {
                      if (userC.user.id == null) {
                        Get.dialog(ForbiddenCard(
                          onPressed: () {
                            Get.back();
                            Get.to(SignInPage(), routeName: '/login');
                          },
                        ));
                      } else {
                        if (favorite == true) {
                          supabase.deleteSurahFavorite(userC.user.id.toString(),
                              widget.surahNumber!.toInt(), widget.verseNumber!);
                          setState(() {
                            favorite = !favorite;
                          });
                        } else {
                          supabase.setSurahFavorite(userC.user.id.toString(),
                              widget.surahNumber!.toInt(), widget.verseNumber!);
                          setState(() {
                            favorite = !favorite;
                          });
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green.shade100, shape: BoxShape.circle),
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            favorite == true
                                ? Icons.favorite
                                : UniconsLine.heart,
                            color: Colors.green.shade700,
                            size: 20,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: context.locale.languageCode == "tr",
            child: InkWell(
              onTap: widget.onTapSeeTefsir,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [AppShadow.card],
                ),
                child: Center(
                  child: Text(
                    "Kuran Yolu Tefsiri Oku",
                    style: AppTextStyle.normal.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: context.locale.languageCode == "tr",
            child: InkWell(
              onTap: widget.onTapSeeTafsir,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [AppShadow.card],
                ),
                child: Center(
                  child: Text(
                    "arapcaanlam".tr(),
                    style: AppTextStyle.normal.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
