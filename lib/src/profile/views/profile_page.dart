import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:quran_app/bricks/my_widgets/my_button.dart';
import 'package:quran_app/bricks/my_widgets/my_circle_avatar.dart';
import 'package:quran_app/bricks/my_widgets/my_outline_button.dart';
import 'package:quran_app/src/about/about_page.dart';
import 'package:quran_app/src/profile/controllers/auth_controller.dart';
import 'package:quran_app/src/profile/controllers/user_controller.dart';
import 'package:quran_app/src/profile/models/user.dart';
import 'package:quran_app/src/profile/views/signin_page.dart';
import 'package:quran_app/src/settings/controller/settings_controller.dart';
import 'package:quran_app/src/settings/settings_page.dart';
import 'package:quran_app/src/settings/theme/app_theme.dart';
import 'package:quran_app/src/widgets/app_card.dart';
import 'package:quran_app/src/widgets/coming_soon_card.dart';
import 'package:quran_app/src/wrapper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../helper/global_state.dart';
import '../../../services/supabase_service.dart';
import '../../purchase/views/in_app_purchase_page.dart';
import '../../widgets/friday_mesages.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _settingController = Get.put(SettingsController());

  final _authController = Get.put(AuthControllerImpl());

  final _userController = Get.put(UserControllerImpl());

  final _state = Get.put(GlobalState());

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    // if (_settingController.isDarkMode.value) {
    //   primaryColor = Theme.of(context).scaffoldBackgroundColor;
    // }
    if (Get.isDarkMode) {
      primaryColor = Theme.of(context).appBarTheme.backgroundColor!;
    }
    final size = MediaQuery.of(context).size;
    final InAppReview inAppReview = InAppReview.instance;

    final box = Get.find<GetStorage>();
    final session = box.read('user');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Menü",
          style: AppTextStyle.bigTitle,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        height: size.height,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(
          children: [
            Container(
              color: primaryColor,
              width: size.width,
              height: size.height * 0.5,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          "assets/icon/icon.png",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "kuranmeali".tr(),
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Sürüm Numarası: 2.2.4",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 20,
                      ),
                    )
                  ]),
            ),
            // Obx(() {
            //   if (_userController.user.avatarUrl != null) {
            //     return Container(
            //       color: primaryColor,
            //       width: size.width,
            //       height: size.height * 0.5,
            //       child: Hero(
            //         tag: "avatar",
            //         child: ModelViewer(
            //           src: _userController.user.avatarUrl.toString(),
            //           autoRotate: true,
            //           cameraControls: true,
            //           backgroundColor: primaryColor,
            //           alt: "avatar3d".tr(),
            //           ar: true,
            //         ),
            //       ),
            //     );
            //   } else if (_userController.user.photoUrl != null) {
            //     return Container(
            //       color: primaryColor,
            //       width: size.width,
            //       height: size.height * 0.5,
            //       padding: const EdgeInsets.only(bottom: 90),
            //       child: Hero(
            //         tag: "avatar",
            //         child: MyCircleAvatar(
            //           primaryColor: _settingController.isDarkMode.value
            //               ? Theme.of(context).backgroundColor
            //               : Theme.of(context).cardColor,
            //           image: NetworkImage(
            //             _userController.user.photoUrl.toString(),
            //           ),
            //         ),
            //       ),
            //     );
            //   } else {
            //     return Container(
            //       color: _settingController.isDarkMode.value
            //           ? Theme.of(context).cardColor
            //           : primaryColor,
            //       height: size.height * 0.5,
            //       child: Align(
            //         alignment: Alignment.topCenter,
            //         child: Hero(
            //           tag: "avatarIcon",
            //           child: Container(
            //             margin: const EdgeInsets.only(top: 90),
            //             padding: const EdgeInsets.all(25),
            //             decoration: BoxDecoration(
            //               color: Colors.white.withOpacity(0.5),
            //               borderRadius: BorderRadius.circular(100),
            //             ),
            //             child: const Icon(
            //               Icons.person,
            //               size: 70,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ),
            //     );
            //   }
            // }),
            DraggableScrollableSheet(
              initialChildSize: 0.55,
              maxChildSize: 0.55,
              minChildSize: 0.5,
              snap: true,
              builder: (context, controller) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    ),
                    color: _settingController.isDarkMode.value
                        ? Theme.of(context).backgroundColor
                        : Theme.of(context).cardColor,
                    boxShadow: [AppShadow.card],
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      const SizedBox(height: 40),
                      Obx(
                        () => Text(
                          _userController.user.name ??
                              "“Şüphesiz Allah çok tevbe edenleri sever. Bakara 222“"
                                  .tr(),
                          style: AppTextStyle.title.copyWith(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Text(
                          _userController.user.email ?? "",
                          style: AppTextStyle.normal.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      upgradeAccountCard,
                      const SizedBox(height: 20),
                      Obx(
                        () => Text(
                          _userController.user.bio ?? "girisyapoku".tr(),
                          style: AppTextStyle.small.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_userController.user.email != null)
                        ProfileItem(
                          icon: UniconsLine.edit_alt,
                          title: "profilduzen".tr(),
                          onPressed: () {
                            Get.bottomSheet(const ComingSoonCard());
                          },
                        ),
                      const SizedBox(height: 16),
                      // const FridayMessages(
                      //   fridayControl: false,
                      // ),
                      const SizedBox(height: 16),
                      ProfileItem(
                        icon: UniconsLine.share_alt,
                        title: "Paylaş",
                        onPressed: () {
                          Share.share(
                            "tavsiye".tr() +
                                " https://play.google.com/store/apps/details?id=com.kuran.mealii",
                            subject: "Kuran Meali",
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ProfileItem(
                        icon: UniconsLine.star,
                        title: "degerlendir".tr(),
                        onPressed: () async {
                          if (await inAppReview.isAvailable()) {
                            inAppReview.openStoreListing();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        child: AppCard(
                          hMargin: 0,
                          vPadding: 10,
                          radius: 15,
                          color: settingController.isDarkMode.value
                              ? Theme.of(context).cardColor
                              : Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  Icons.density_medium_sharp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "sosyalmedia".tr(),
                                style: AppTextStyle.normal,
                              ),
                              const Spacer(),
                              Icon(
                                expanded
                                    ? UniconsLine.arrow_down
                                    : UniconsLine.arrow_right,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      expanded
                          ? const SizedBox(
                              height: 16,
                            )
                          : const SizedBox(),
                      expanded
                          ? ProfileItem(
                              icon: UniconsLine.instagram,
                              title: "Instagram",
                              onPressed: () async {
                                await launchUrl(
                                  Uri.parse(
                                      "https://instagram.com/birhazanmevsimi"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            )
                          : const SizedBox(),
                      expanded ? const SizedBox(height: 16) : const SizedBox(),
                      expanded
                          ? ProfileItem(
                              icon: UniconsLine.telegram,
                              title: "Telegram",
                              onPressed: () async {
                                await launchUrl(
                                  Uri.parse("https://t.me/+dB4XS7H7bpwwYjQ0"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            )
                          : const SizedBox(),
                      expanded ? const SizedBox(height: 16) : const SizedBox(),
                      expanded
                          ? ProfileItem(
                              icon: UniconsLine.twitter,
                              title: "Twitter",
                              onPressed: () async {
                                await launchUrl(
                                  Uri.parse("https://twitter.com/kuranikerimQ"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            )
                          : const SizedBox(),
                      const SizedBox(height: 16),
                      ProfileItem(
                        icon: UniconsLine.setting,
                        title: "ayarlar".tr(),
                        onPressed: () {
                          Get.to(() => const SettingsPage());
                        },
                      ),
                      ProfileItem(
                        icon: UniconsLine.info,
                        title: "Hakkımızda".tr(),
                        onPressed: () {
                          Get.to(() => const AboutPage());
                        },
                      ),
                      const SizedBox(height: 40),
                      if (_userController.user.email == null)
                        MyButton(
                          width: MediaQuery.of(context).size.width,
                          text: "login".tr(),
                          onPressed: () => Get.to(SignInPage()),
                        )
                      else
                        MyOutlinedButton(
                          text: "cikisyap".tr(),
                          isLoading: _state.isLoading.value,
                          onPressed: () {
                            _state.isLoading(true);
                            _authController.signOut().then((value) async {
                              _userController.setUser(User());
                              _state.isLoading(false);
                              GoogleSignIn().signOut();
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('user');

                              Get.snackbar(
                                "nereye".tr(),
                                "cikisyaptin".tr(),
                                duration: const Duration(seconds: 1),
                              );
                              Future.delayed(
                                const Duration(seconds: 1),
                                () => Get.offAll(Wrapper()),
                              );
                            });
                          },
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget get upgradeAccountCard => GestureDetector(
        onTap: () => Get.to(const InAppPurchasePage()),
        child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SupabaseService().getPurchase()
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          "Reklamsız Tam Sürüm",
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        Text(
                          "${SupabaseService().getPurchaseMonth()} Ayınız Kaldı",
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )
                      ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          "Hesabınızı Yükseltin!",
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        Text(
                          "Daha fazla özelliğe erişmek için hesabınızı yükseltin",
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          "Detaylı Bilgi İçin Tıklayın",
                          style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ])),
      );
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onPressed;
  const ProfileItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: AppCard(
        hMargin: 0,
        vPadding: 10,
        radius: 15,
        color: settingController.isDarkMode.value
            ? Theme.of(context).cardColor
            : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyle.normal,
            ),
            const Spacer(),
            Icon(
              UniconsLine.arrow_right,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
