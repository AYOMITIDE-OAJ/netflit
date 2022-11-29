class Sources {
  String? choice;
  String? dateAdded;
  String? embedContent;
  bool? isAffiliate;
  String? language;
  String? link;
  String? name;
  String? player;
  int? position;
  String? quality;

  Sources({
    this.choice,
    this.dateAdded,
    this.embedContent,
    this.isAffiliate,
    this.language,
    this.link,
    this.name,
    this.player,
    this.position,
    this.quality,
  });

  factory Sources.fromJson(Map<String, dynamic> json) {
    return Sources(
      choice: json['choice'],
      dateAdded: json['date_added'],
      embedContent: json['embed_content'],
      isAffiliate: json['is_affiliate'],
      language: json['language'],
      link: json['link'],
      name: json['name'],
      player: json['player'],
      position: json['position'],
      quality: json['quality'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['choice'] = this.choice;
    data['date_added'] = this.dateAdded;
    data['embed_content'] = this.embedContent;
    data['is_affiliate'] = this.isAffiliate;
    data['language'] = this.language;
    data['link'] = this.link;
    data['name'] = this.name;
    data['player'] = this.player;
    data['position'] = this.position;
    data['quality'] = this.quality;
    return data;
  }
}
