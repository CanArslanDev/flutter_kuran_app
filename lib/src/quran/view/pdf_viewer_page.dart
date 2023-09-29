import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_app/helper/ads.dart';
import 'package:quran_app/src/profile/controllers/user_controller.dart';
import 'package:quran_app/src/quran/view/background_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/exporting/pdf_text_extractor/enums.dart';
import 'package:unicons/unicons.dart';

import '../../../services/supabase_service.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerPage({required this.pdfUrl, required this.title});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PdfTextSearchResult _searchResult;
  late PdfViewerController _pdfViewerController;
  ValueNotifier<bool> showFirstPageButton = ValueNotifier(false);
  TextEditingController searchController = TextEditingController();
  BannerAd? myBanner;
  bool loadUser = false;
  bool loadedPdf = false;
  final userC = Get.put(UserControllerImpl());
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _searchResult = PdfTextSearchResult();
    try {
      if (userC.user.id.toString() != "null" &&
          userC.user.id.toString() != "") {
        loadUser = true;
      }
    } catch (e) {}
    try {
      myBanner = AdsHelper.banner();
      myBanner!.load().then((value) {});
    } catch (e) {}
    super.initState();
  }

  var _overlayEntry;
  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 110,
        left: details.globalSelectedRegion!.bottomLeft.dx - 65,
        child: Column(
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('Resim İle Paylaş',
                    style: TextStyle(fontSize: 17)),
                onPressed: () {
                  _pdfViewerController.clearSelection();
                  Get.to(BackgroundPage(
                    titleTr: details.selectedText!,
                    numberOfVerses: "",
                    surahName: "",
                    title: "",
                    viewSurahName: true,
                  ));
                }),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                  child: ElevatedButton(
                      child:
                          const Text('Kopyala', style: TextStyle(fontSize: 17)),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: details.selectedText!));
                        _pdfViewerController.clearSelection();
                        Get.snackbar("Kopyalandı", "Metin Panoya Kopyalandı");
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700),
                      child:
                          const Text('Paylaş', style: TextStyle(fontSize: 17)),
                      onPressed: () {
                        Share.share(
                          details.selectedText!,
                        );
                        _pdfViewerController.clearSelection();
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    _overlayState.insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ValueListenableBuilder(
        valueListenable: showFirstPageButton,
        builder: (context, value, child) => value == true
            ? Container()
            : FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () => _pdfViewerController.firstPage(),
                child: const Icon(Icons.arrow_upward_outlined),
              ),
      ),
      bottomNavigationBar: SizedBox(
        child: (myBanner == null)
            ? null
            : SizedBox(
                width: double.parse(myBanner!.size.width.toString()),
                height: double.parse(myBanner!.size.height.toString()),
                child: AdWidget(ad: myBanner!)),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          SizedBox(
            child: (loadUser == false)
                ? null
                : IconButton(
                    onPressed: () async {
                      if (await SupabaseService()
                              .isFavoritePDF(userC.user.id!, widget.title) ==
                          false) {
                        SupabaseService().pdfAddToFavorites(
                            widget.title, widget.pdfUrl, userC.user.id!);
                      } else {
                        SupabaseService().pdfRemoveFromFavorites(
                            userC.user.id!, widget.title);
                      }
                      Timer(const Duration(seconds: 1), () => setState(() {}));
                    },
                    icon: FutureBuilder(
                      future: SupabaseService()
                          .isFavoritePDF(userC.user.id!, widget.title),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Icon(snapshot.data == true
                              ? Icons.favorite
                              : UniconsLine.heart);
                        } else {
                          return Icon(snapshot.data == true
                              ? Icons.favorite
                              : UniconsLine.heart);
                        }
                      },
                    )),
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showGeneralDialog(
                  context: context,
                  barrierLabel: "Barrier",
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.2),
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (_, __, ___) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 170,
                          width: 500,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                              ),
                              // Material(
                              //   child: Text(
                              //     "Please Wait",
                              //     style: GoogleFonts.inter(
                              //         fontSize: 5.5.w,
                              //         fontWeight: FontWeight.bold,
                              //         color: Theme.of(Get.context!)
                              //             .colorScheme
                              //             .secondary
                              //             .withOpacity(0.7)),
                              //   ),
                              // ),
                              const SizedBox(
                                width: 300,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Metin Girin",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Material(
                                  child: Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10.0,
                                        spreadRadius: 0.05,
                                      ),
                                    ]),
                                    child: SizedBox(
                                      height: 50,
                                      width: 250,
                                      child: TextField(
                                        controller: searchController,
                                        // controller: controller.emailFieldController,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _searchResult = _pdfViewerController
                                            .searchText(searchController.text,
                                                searchOption: TextSearchOption
                                                    .caseSensitive);
                                        if (kIsWeb) {
                                          setState(() {});
                                        } else {
                                          _searchResult.addListener(() {
                                            if (_searchResult.hasResult) {
                                              setState(() {});
                                            }
                                          });
                                        }
                                      },
                                      child: const Text(
                                        "Ara",
                                        style: TextStyle(fontSize: 20),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _searchResult.clear();
                });
              },
            ),
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
              onPressed: () {
                _searchResult.previousInstance();
              },
            ),
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: () {
                _searchResult.nextInstance();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.pdfUrl,
            onPageChanged: (details) =>
                showFirstPageButton.value = details.isFirstPage,
            onDocumentLoaded: (details) {
              setState(() {
                loadedPdf = true;
              });
            },
            onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
              if (details.selectedText == null && _overlayEntry != null) {
                _overlayEntry.remove();
                _overlayEntry = null;
              } else if (details.selectedText != null &&
                  _overlayEntry == null) {
                _showContextMenu(context, details);
              }
            },
            controller: _pdfViewerController,
          ),
          Container(
            child: loadedPdf == false
                ? Positioned.fill(
                    child: Container(
                      color: Colors.white,
                      height: Get.height,
                      width: Get.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Kitap Yükleniyor...",
                            style: GoogleFonts.inter(fontSize: 25),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  )
                : null,
          )
        ],
      ),
    );
  }
}
