class CommentModel {
  int? author;
  String? authorName;
  String? authorUrl;
  Content? content;
  String? date;
  String? dateGmt;
  int? id;
  String? link;
  int? parent;
  int? post;
  String? commentData;

  //local
  bool isAddReply;

  CommentModel({
    this.author,
    this.authorName,
    this.authorUrl,
    this.content,
    this.date,
    this.dateGmt,
    this.id,
    this.link,
    this.parent,
    this.post,
    this.isAddReply = false,
    this.commentData,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      author: json['author'],
      authorName: json['author_name'],
      authorUrl: json['author_url'],
      content: json['content'] != null ? Content.fromJson(json['content']) : null,
      date: json['date'],
      dateGmt: json['date_gmt'],
      id: json['id'],
      link: json['link'],
      parent: json['parent'],
      post: json['post'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['author_name'] = this.authorName;
    data['author_url'] = this.authorUrl;
    data['date'] = this.date;
    data['date_gmt'] = this.dateGmt;
    data['id'] = this.id;
    data['link'] = this.link;
    data['parent'] = this.parent;
    data['post'] = this.post;
    if (this.commentData != null) {
      data['content'] = this.commentData;
    }
    return data;
  }
}

class Content {
  String? rendered;

  Content({this.rendered});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      rendered: json['rendered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    return data;
  }
}
