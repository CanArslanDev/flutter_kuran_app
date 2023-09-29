import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/services/supabase_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';
import '../../helper/ads.dart';
import '../profile/controllers/user_controller.dart';
import '../quran/view/wordpress_content_view_page.dart';

class WordpressRestApiList extends StatefulWidget {
  const WordpressRestApiList({Key? key}) : super(key: key);

  @override
  State<WordpressRestApiList> createState() => _WordpressRestApiListState();
}

class _WordpressRestApiListState extends State<WordpressRestApiList> {
  List jsonData = [];

  bool loadUser = false;
  final userC = Get.put(UserControllerImpl());

  BannerAd? myBanner;
  @override
  void initState() {
    super.initState();
    try {
      myBanner = AdsHelper.banner();
      myBanner!.load().then((value) {});
      // ignore: empty_catches
    } catch (e) {}
    try {
      if (userC.user.id.toString() != "null" &&
          userC.user.id.toString() != "") {
        loadUser = true;
      }
      // ignore: empty_catches
    } catch (e) {}
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
          child: (myBanner == null)
              ? null
              : SizedBox(
                  width: double.parse(myBanner!.size.width.toString()),
                  height: double.parse(myBanner!.size.height.toString()),
                  child: AdWidget(ad: myBanner!))),
      appBar: AppBar(
        title: Text("islamipaylasim".tr()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < jsonData.length; i++)
                RestApiWidget(
                  title: jsonData[i][0],
                  description: jsonData[i][1],
                  image: jsonData[i][2],
                  date: jsonData[i][3],
                  links: jsonData[i][4],
                  loadUser: loadUser,
                  userId: (loadUser == false) ? 0 : userC.user.id!,
                  index: i,
                ),
            ],
          ),
        ),
      ),
    );
  }

  fetchData() async {
    final response = await http
        .get(Uri.parse('https://kuranikerim.app/wp-json/wp/v2/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonDataValue = jsonDecode(response.body);
      for (var data in jsonDataValue) {
        final String title = data['title']['rendered'];
        final String link = data['link'];
        final String content = data['content']['rendered'];
        final String date = data['date'];

        DateTime dateTime = DateTime.parse(date);
        String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
        String image = data['yoast_head_json']['og_image'][0]['url'];
        jsonData.add([title, content, image, formattedDate, link]);
      }
      setState(() {});
    } else {}
  }
}

class RestApiWidget extends StatefulWidget {
  const RestApiWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.image,
      required this.date,
      required this.links,
      required this.loadUser,
      required this.userId,
      required this.index})
      : super(key: key);
  final String title;
  final String description;
  final String image;
  final String date;
  final String links;
  final bool loadUser;
  final int userId;
  final int index;
  @override
  State<RestApiWidget> createState() => _RestApiWidgetState();
}

class _RestApiWidgetState extends State<RestApiWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Get.to(WordpressContentViewPage(
              title: widget.title,
              description: widget.description,
              image: widget.image,
              date: widget.date,
              link: widget.links,
            )),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 1)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            HtmlUnescape().convert(widget.title),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.date,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                        width: 130,
                        height: 90,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (widget.loadUser == true) {
                          if (await SupabaseService().restApiIsFavoritePDF(
                                  widget.userId, widget.links) ==
                              false) {
                            await SupabaseService().restApiAddToFavorites(
                                widget.links,
                                widget.userId,
                                widget.title,
                                widget.index,
                                widget.image,
                                widget.date);
                          } else {
                            await SupabaseService().restApiRemoveFromFavorites(
                                widget.userId, widget.links);
                          }
                          Timer(const Duration(seconds: 1), () {
                            setState(() {});
                          });
                        }
                      },
                      child: SizedBox(
                        child: (widget.loadUser == false)
                            ? null
                            : FutureBuilder(
                                future: Future.wait([
                                  SupabaseService().restApiIsFavoritePDF(
                                      widget.userId, widget.links),
                                  SupabaseService()
                                      .restApiGetLikeCount(widget.links),
                                ]),
                                builder:
                                    (context, AsyncSnapshot<List> snapshot) {
                                  if (snapshot.hasData) {
                                    return Row(
                                      children: [
                                        Icon(snapshot.data![0] == true
                                            ? Icons.favorite
                                            : UniconsLine.heart),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          snapshot.data![1].toString(),
                                          style:
                                              GoogleFonts.inter(fontSize: 16),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Share.share(widget.links);
                      },
                      child: Container(
                        color: Colors.white.withOpacity(0),
                        child: Row(
                          children: [
                            const Icon(Icons.share),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Paylaş",
                              style: GoogleFonts.inter(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
