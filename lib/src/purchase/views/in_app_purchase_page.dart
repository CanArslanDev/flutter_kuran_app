import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:onepref/onepref.dart';
import 'package:quran_app/services/supabase_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../profile/controllers/user_controller.dart';
import '../../profile/views/signin_page.dart';
import '../../widgets/forbidden_card.dart';

class InAppPurchasePage extends StatefulWidget {
  const InAppPurchasePage({Key? key}) : super(key: key);

  @override
  State<InAppPurchasePage> createState() => _InAppPurchasePageState();
}

class _InAppPurchasePageState extends State<InAppPurchasePage> {
  //List
  late final List<ProductDetails> _products = <ProductDetails>[];

  //IApEngine
  IApEngine iApEngine = IApEngine();

  //products
  List<ProductId> storeProductsIds = <ProductId>[
    ProductId(id: "1", isConsumable: true, reward: 1),
    ProductId(id: "12", isConsumable: true, reward: 12)
  ];
  final userC = Get.put(UserControllerImpl());
  ValueNotifier<int> indexValue = ValueNotifier(0);
  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    iApEngine.inAppPurchase.purchaseStream.listen((list) {
      listenPurchases(list);
    });
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF52AF56),
        title: Text(
          "Paketler",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF43A047), Color(0xFF348D38)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Container(
              width: Get.width,
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              decoration: BoxDecoration(
                  color: const Color(0xFF54BF59),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 20,
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Abonelikler neleri kapsar?",
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          height: 7,
                          width: 7,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: Get.width / 1.3,
                        child: Text(
                          "Satın alım ile tamamen reklamsız(yakında) bir uygulama, sınırsız resme yazı aktarma özelliğine sahip olursunuz. Ayrıca uygulama geliştirme ve sunucu giderlerine de desktek vererek bütün hayırlara ortak olacaksınız.",
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              child: _products.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _products.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () async {
                          indexValue.value = index;
                        },
                        child: purchaseWidget(index, _products[index].title,
                            _products[index].price),
                      ),
                    )
                  : Shimmer.fromColors(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (context, index) => purchaseWidget(index,
                            "_products[index].title", "_products[index].price"),
                      ),
                      baseColor: Get.isDarkMode
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.green,
                      highlightColor: Get.isDarkMode
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.green.shade800,
                    ),
            ),
            GestureDetector(
              onTap: () {
                iApEngine.handlePurchase(
                    _products[indexValue.value], storeProductsIds);
              },
              child: Container(
                height: 60,
                width: Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xFF54BF59),
                      const Color(0xFF34FF61).withOpacity(0.1),
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    border: Border.all(color: const Color(0xFF36BB53)),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 20,
                      ),
                    ]),
                child: Center(
                  child: Text(
                    "Ödemeye Devam Et",
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> listenPurchases(List<PurchaseDetails> list) async {
    for (final purchase in list) {
      if (purchase.status == PurchaseStatus.restored ||
          purchase.status == PurchaseStatus.purchased) {
        if (Platform.isAndroid &&
            iApEngine
                .getProductIdsOnly(storeProductsIds)
                .contains(purchase.productID)) {
          final InAppPurchaseAndroidPlatformAddition androidAddition = iApEngine
              .inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        }
        if (purchase.pendingCompletePurchase) {
          await iApEngine.inAppPurchase.completePurchase(purchase);
        }
        giveEvent(purchase);
      }
    }
  }

  void giveEvent(PurchaseDetails purchaseDetails) {
    for (var product in storeProductsIds) {
      if (product.id == purchaseDetails.productID) {
        print(product.reward);
        if (product.reward == 12) {
          // DateTime currentTime = DateTime.now();

          // // 12 ay sonrasını hesapla
          // DateTime futureTime = currentTime.add(const Duration(days: 365));
          SupabaseService().setPurchase(12);
        } else if (product.reward == 1) {
          SupabaseService().setPurchase(1);
          // DateTime currentTime = DateTime.now();

          // // 12 ay sonrasını hesapla
          // DateTime futureTime = currentTime.add(const Duration(days: 30));
          // SupabaseService().setPurchase(userC.user.id!, futureTime);
        }
      }
    }
  }

  void getProducts() async {
    await iApEngine.getIsAvailable().then((value) async {
      if (value) {
        await iApEngine.queryProducts(storeProductsIds).then((response) {
          print("r33 ${response.productDetails}");
          setState(() {
            _products.addAll(response.productDetails);
          });
        });
      }
    });
  }

  Widget purchaseWidget(int index, String title, String name) {
    return ValueListenableBuilder(
      valueListenable: indexValue,
      builder: (context, int value, child) => Container(
        height: 125,
        width: Get.width,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
            color:
                index == 0 ? const Color(0xFF324DAC) : const Color(0xFFCD3B3B),
            borderRadius: BorderRadius.circular(20),
            border: value == index
                ? Border.all(color: Colors.white, width: 3)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 20,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Text(
              name,
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 27),
            ),
            Text(
              "İstediğiniz zaman iptal edin",
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
