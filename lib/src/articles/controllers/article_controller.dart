import 'dart:developer';

import 'package:get/get.dart';
import 'package:quran_app/src/articles/repositories/article_repository.dart';

import '../entities/Article.dart';

const rssFeeds = <String, String>{
  "mutiaraIslam": "http://80.253.246.121:7000/api/diyanet",
};

class ArticleController extends GetxController {
  var articles = <Article>[].obs;
  var articlesAtHome = <Article>{}.obs;
  var articleAtHomeIsLoading = false.obs;
  var articleIsLoading = false.obs;

  Future<void> loadArticleforHome() async {
    articleAtHomeIsLoading.value = true;

    final feed = await ArticleRepository.fetchFeed(rssFeeds.values.first);

        Article _article = Article();
        _article.ayet = feed!.ayet;
        _article.ayet_info = feed.ayet_info;
        _article.dua = feed.soz;
        _article.dua_info = feed.soz_info;
        _article.hadis = feed.hadis;
        _article.hadis_info = feed.hadis_info;

        if (articlesAtHome.length <= 3) {
          articlesAtHome.add(_article);
          for(int i=0;i<3;i++){
            articles.add(_article);
          }
          log(articlesAtHome.length.toString());
        }

        articleAtHomeIsLoading.value = false;
        await Future.delayed(800.milliseconds);

  }

  Future<void> loadArticle() async {
    articleIsLoading.value = true;

      final feed = await ArticleRepository.fetchFeed(rssFeeds.values.first);


          Article _article = Article();
          _article.ayet = feed!.ayet;
          _article.ayet_info = feed.ayet_info;
          _article.dua = feed.soz;
          _article.dua_info = feed.soz_info;
          _article.hadis = feed.hadis;
          _article.hadis_info = feed.hadis_info;

          articleIsLoading.value = false;
          await Future.delayed(800.milliseconds);



      log(articles.length.toString());


    articleIsLoading.value = false;
  }

  @override
  void onInit() {
    loadArticleforHome();
    super.onInit();
  }
}
