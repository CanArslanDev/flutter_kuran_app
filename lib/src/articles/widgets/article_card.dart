import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';

import '../../quran/view/background_page.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    Key? key,
    required this.title,
    required this.content,
    required this.author,
    this.height,
    this.share,
    this.color,
  }) : super(key: key);

  final String title;
  final String content;
  final String author;
  final double? height;
  final bool? share;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 320,
      //height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        // vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [AppShadow.card],
        border: Get.isDarkMode
            ? null
            : Border.all(
                color: color ?? Colors.grey.shade100,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: Image.asset(
                    "assets/icon/icon.png",
                    width: 30,
                  )),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  author,
                  style: AppTextStyle.small,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                child: (share == null)
                    ? null
                    : GestureDetector(
                        onTap: () => Get.to(BackgroundPage(
                              titleTr: content,
                              numberOfVerses: "0",
                              surahName: title,
                              title: "",
                              viewSurahName: true,
                            )),
                        child: Image.asset(
                          "assets/share_arrow.png",
                          height: 23,
                        )),
              ),
              IconButton(
                  onPressed: () {
                    Share.share(
                      "$title\n\n$content",
                    );
                  },
                  icon: const Icon(Icons.share))
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyle.title,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: AppTextStyle.normal,
            //maxLines: 2,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
