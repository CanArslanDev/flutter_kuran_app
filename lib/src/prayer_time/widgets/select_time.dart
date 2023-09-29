import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:group_button/group_button.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../bricks/my_widgets/my_button.dart';

class SelectTime extends StatelessWidget {
  final Function()? onPressed;
  final Function(String, int, bool)? onSelected;
  final GroupButtonController controller;
  const SelectTime(
      {Key? key, this.onPressed, required this.controller, this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        boxShadow: [AppShadow.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "namazvakithatirlatici".tr(),
            style: AppTextStyle.title.copyWith(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "hatirlatmabildirim".tr(),
            style: AppTextStyle.normal.copyWith(
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          GroupButton(
            controller: controller,
            buttons: const [
              'Namaz Vaktinde',
              "5 Dakika kala",
              "10 Dakika kala",
              "15 Dakika kala",
              "20 Dakika kala",
              "45 Dakika kala",
            ],
            maxSelected: 1,
            onSelected: onSelected,
            options: GroupButtonOptions(
              mainGroupAlignment: MainGroupAlignment.start,
              borderRadius: BorderRadius.circular(10),
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.15),
              selectedTextStyle: AppTextStyle.normal.copyWith(
                color: Theme.of(context).primaryColor,
              ),
              unselectedColor: Colors.grey.withOpacity(0.15),
              unselectedTextStyle: AppTextStyle.normal.copyWith(
                color: Get.isDarkMode ? Colors.grey : Colors.grey.shade600,
              ),
            ),
          ),
          const Spacer(),
          MyButton(
            text: "tamam".tr(),
            width: MediaQuery.of(context).size.width,
            onPressed: onPressed,
          ),
          // const SizedBox(height: 16),
          // MyOutlinedButton(
          //   text: "Back",
          //   width: MediaQuery.of(context).size.width,
          //   onPressed: () {
          //     Get.back();
          //   },
          // ),
        ],
      ),
    );
  }
}
