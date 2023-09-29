import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:quran_app/bricks/my_widgets/my_button.dart';
import 'package:quran_app/helper/constans.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:wiredash/wiredash.dart';
import 'package:easy_localization/easy_localization.dart';

class ComingSoonCard extends StatelessWidget {
  const ComingSoonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [AppShadow.card],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            AssetsName.illReadTheQuran,
            width: 210,
          ),
          Text(
            "yakindageliyor".tr(),
            style: AppTextStyle.title.copyWith(
              fontSize: 18,
              // color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "yakindakullanim".tr(),
            style: AppTextStyle.small.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          MyButton(
            text: "geribildirim".tr(),
            width: MediaQuery.of(context).size.width,
            onPressed: () {
              Get.back();
              // url.launch("https://s.id/hiQuran").then((value) {
              //   if (!value) {
              //     Get.snackbar("Opps...", "An error occured");
              //   }
              // });
              Wiredash.of(context).show();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
