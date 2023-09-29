import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:in_app_review/in_app_review.dart';

class RateMsg {
  ValueNotifier<double> rating = ValueNotifier(0);

  final InAppReview inAppReview = InAppReview.instance;
  Future<bool> msg() async {
    Get.dialog(AlertDialog(
      title: Text('Uygulamayı Değerlendirin'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Uygulamayı kaç yıldızla değerlendirirsiniz?'),
          ValueListenableBuilder(
            valueListenable: rating,
            builder: (context, double value, child) => Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating.value.ceil()
                        ? Icons.star
                        : Icons.star_border,
                    color: index < rating.value.ceil()
                        ? Colors.yellow
                        : Colors.grey,
                  ),
                  onPressed: () {
                    rating.value = index + 1.toDouble();
                  },
                );
              }),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: rating,
              builder: (context, double value, child) => Slider(
                    value: value,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    onChanged: (value) {
                      rating.value = value;
                    },
                  )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Get.back();
            Get.back();
          },
          child: Text('Sayfadan Çık'),
        ),
        TextButton(
          onPressed: () async {
            if (await inAppReview.isAvailable()) {
              inAppReview.openStoreListing();
              Get.back();
              Get.back();
            }
          },
          child: Text('Puan Ver'),
        ),
      ],
    ));
    return true;
  }
}
