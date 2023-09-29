class RssFeed {
  RssFeed({
    required this.status,
    required this.feed,
    required this.items,
  });
  late final String status;
  late final Feed feed;
  late final List<Items> items;

  RssFeed.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    feed = Feed.fromJson(json['feed']);
    items = List.from(json['items']).map((e) => Items.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['feed'] = feed.toJson();
    _data['items'] = items.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Feed {
  Feed({
    required this.ayet,
    required this.ayet_info,
    required this.hadis,
    required this.hadis_info,
    required this.soz,
    required this.soz_info,
    required this.fihrist,
    required this.fihrist_info,

  });
  late final String ayet;
  late final String ayet_info;
  late final String hadis;
  late final String hadis_info;
  late final String soz;
  late final String soz_info;
  late final String fihrist;
  late final String fihrist_info;

  Feed.fromJson(Map<String, dynamic> json) {
    ayet = json['ayet'];
    ayet_info = json['ayet_info'];
    soz = json['soz'];
    soz_info = json['soz_info'];
    hadis = json['hadis'];
    hadis_info = json['hadis_info'];
    fihrist = json['fihrist'];
    fihrist_info = json['fihrist_info'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ayet'] = ayet;
    _data['ayet_info'] = ayet_info;
    _data['soz'] = soz;
    _data['soz_info'] = soz_info;
    _data['hadis'] = hadis;
    _data['hadis_info'] = hadis_info;
    _data['fihrist'] = fihrist;
    _data['fihrist_info'] = fihrist_info;
    return _data;
  }
}

class Items {
  Items({
    required this.title,
    required this.pubDate,
    required this.link,
    required this.guid,
    required this.author,
    required this.thumbnail,
    required this.description,
    required this.content,
    required this.enclosure,
    required this.categories,
  });
  late final String title;
  late final String pubDate;
  late final String link;
  late final String guid;
  late final String author;
  late final String thumbnail;
  late final String description;
  late final String content;
  late final Enclosure enclosure;
  late final List<String> categories;

  Items.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    pubDate = json['pubDate'];
    link = json['link'];
    guid = json['guid'];
    author = json['author'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    content = json['content'];
    enclosure = Enclosure.fromJson(json['enclosure']);
    categories = List.castFrom<dynamic, String>(json['categories']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['pubDate'] = pubDate;
    _data['link'] = link;
    _data['guid'] = guid;
    _data['author'] = author;
    _data['thumbnail'] = thumbnail;
    _data['description'] = description;
    _data['content'] = content;
    _data['enclosure'] = enclosure.toJson();
    _data['categories'] = categories;
    return _data;
  }
}

class Enclosure {
  Enclosure();

  Enclosure.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}
