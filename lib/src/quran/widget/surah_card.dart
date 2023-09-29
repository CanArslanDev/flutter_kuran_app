import 'package:flutter/material.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';

class SurahCard extends StatelessWidget {
  const SurahCard({
    Key? key,
    this.number,
    this.name,
    //this.revelation,
    //this.nameShort,
    this.numberOfVerses,
    this.originalName,
    required this.function,
    this.icon,
  }) : super(key: key);
  final int? number;
  final String? name;
  final int? numberOfVerses;
  final String? originalName;
  final void Function() function;
  final Icon? icon;
  //final String? revelation;
  //final String? nameShort;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [AppShadow.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      "$number",
                      style: AppTextStyle.normal.copyWith(
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              const SizedBox(height: 10),
              Text(
                "$name",
                style: AppTextStyle.title.copyWith(fontSize: 20),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "$originalName",
                style: AppTextStyle.normal.copyWith(fontSize: 14),
              ),
              const SizedBox(width: 10),
              Chip(
                backgroundColor: Theme.of(context).cardColor,
                label: Text(
                  "$numberOfVerses " + "ayet".tr(),
                  style: AppTextStyle.small,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
