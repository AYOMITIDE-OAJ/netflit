import 'package:streamit_flutter/models/sources.dart';
import 'package:streamit_flutter/utils/Constants.dart';

class MovieResponse {
  List<MovieData>? data;
  List<Season>? seasons;

  MovieResponse({
    this.data,
    this.seasons,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      seasons: json['seasons'] != null ? (json['seasons'] as List).map((i) => Season.fromJson(i)).toList() : null,
      data: json['data'] != null ? (json['data'] as List).map((i) => MovieData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.seasons != null) {
      data['seasons'] = this.seasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MovieData {
  String? description;
  String? excerpt;
  List<Genre>? genre;
  int? id;
  String? image;
  List<Tag>? tag;
  String? title;
  bool? isHD;
  String? logo;
  String? avg_rating;
  String? award_description;
  String? censor_rating;
  String? embed_content;
  String? choice;
  String? publish_date;
  String? publish_date_gmt;
  String? release_date;
  String? run_time;
  String? trailer_link;
  String? url_link;
  String? file;
  List<Visibility>? visibility;
  bool? isInWatchList;
  bool? isLiked;
  int? likes;
  String? attachment;
  String? award_image;
  List<RestrictSubscriptionPlan>? restSubPlan;
  String? restrict_user_status;
  RestrictionSetting? restrictionSetting;
  int? no_of_comments;
  dynamic imdb_rating;
  bool? user_has_membership;

  //video
  List<Genre>? cat;
  String? name_upcoming;
  bool? is_featured;
  String? cast;
  int? views;

  //Local
  PostType? post_type;

  List<Casts>? castsList;

  //cat detail
  String? character_name;
  String? release_year;
  String? share_url;
  int? total_seasons;

  bool? is_post_restricted;
  bool? user_has_pms_member;

  List<Sources>? sourcesList;
  bool? is_comment_open;

  MovieData({
    this.avg_rating,
    this.award_description,
    this.censor_rating,
    this.description,
    this.embed_content,
    this.excerpt,
    this.genre,
    this.id,
    this.image,
    this.logo,
    this.tag,
    this.title,
    this.choice,
    this.publish_date,
    this.publish_date_gmt,
    this.release_date,
    this.run_time,
    this.trailer_link,
    this.url_link,
    this.visibility,
    this.isInWatchList,
    this.isLiked,
    this.likes,
    this.post_type,
    this.file,
    this.attachment,
    this.award_image,
    this.restSubPlan,
    this.restrict_user_status,
    this.restrictionSetting,
    this.cast,
    this.cat,
    this.is_featured,
    this.name_upcoming,
    this.views,
    this.imdb_rating,
    this.no_of_comments,
    this.castsList,
    this.character_name,
    this.release_year,
    this.share_url,
    this.total_seasons,
    this.user_has_membership,
    this.is_post_restricted,
    this.user_has_pms_member,
    this.sourcesList,
    this.is_comment_open,
  });

  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      avg_rating: json['avg_rating'],
      award_description: json['award_description'],
      censor_rating: json['censor_rating'],
      description: json['description'],
      excerpt: json['excerpt'],
      embed_content: json['embed_content'],
      genre: json['genre'] != null ? (json['genre'] as List).map((i) => Genre.fromJson(i)).toList() : null,
      id: json['id'],
      image: json['image'],
      tag: json['tag'] != null ? (json['tag'] as List).map((i) => Tag.fromJson(i)).toList() : null,
      title: json['title'],
      logo: json['logo'],
      likes: json['likes'],
      choice: json['post_type'] != null
          ? json['post_type'] == 'movie'
              ? json['movie_choice']
              : json['video_choice']
          : null,
      publish_date: json['publish_date'],
      publish_date_gmt: json['publish_date_gmt'],
      release_date: json['release_date'],
      run_time: json['run_time'],
      trailer_link: json['trailer_link'],
      url_link: json['url_link'],
      isInWatchList: json['is_watchlist'],
      file: json['post_type'] != null
          ? json['post_type'] == 'movie'
              ? json['movie_file']
              : json['video_file']
          : null,
      award_image: json['award_image'],
      isLiked: json['is_liked'] != null
          ? json['is_liked'] == postLike
              ? true
              : false
          : false,
      visibility: json['visibility'] != null ? (json['visibility'] as List).map((i) => Visibility.fromJson(i)).toList() : null,
      post_type: json['post_type'] != null
          ? json['post_type'] == 'movie'
              ? PostType.MOVIE
              : json['post_type'] == 'episode'
                  ? PostType.EPISODE
                  : json['post_type'] == 'tv_show'
                      ? PostType.TV_SHOW
                      : json['post_type'] == 'video'
                          ? PostType.VIDEO
                          : PostType.NONE
          : PostType.NONE,
      attachment: json['attachment'],
      restSubPlan: json['restrict_subscription_plan'] != null
          ? (json['restrict_subscription_plan'] as List).map((e) => RestrictSubscriptionPlan.fromJson(e)).toList()
          : null,
      restrict_user_status: json['restrict_user_status'],
      restrictionSetting: json['restriction_setting'] != null ? RestrictionSetting.fromJson(json['restriction_setting']) : null,
      cast: json['cast'],
      cat: json['cat'] != null ? (json['cat'] as List).map((e) => Genre.fromJson(e)).toList() : null,
      is_featured: json['is_featured'],
      name_upcoming: json['name_upcoming'],
      views: json['views'],
      imdb_rating: json['imdb_rating'] != null ? json['imdb_rating'] : null,
      no_of_comments: json['no_of_comments'],
      castsList: json['casts'] != null ? (json['casts'] as List).map((e) => Casts.fromJson(e)).toList() : null,
      character_name: json['character_name'],
      release_year: json['release_year'],
      share_url: json['share_url'],
      total_seasons: json['total_seasons'],
      user_has_membership: json['user_has_membership'],
      is_post_restricted: json['is_post_restricted'],
      user_has_pms_member: json['user_has_pms_member'],
      sourcesList: json['sources'] == null ? [] : (json['sources'] as List).map((e) => Sources.fromJson(e)).toList(),
      is_comment_open: json['is_comment_open'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['movie_file'] = this.file;
    data['description'] = this.description;
    data['excerpt'] = this.excerpt;
    data['id'] = this.id;
    data['image'] = this.image;
    data['title'] = this.title;
    data['avg_rating'] = this.avg_rating;
    data['award_description'] = this.award_description;
    data['censor_rating'] = this.censor_rating;
    data['embed_content'] = this.embed_content;
    data['movie_choice'] = this.choice;
    data['publish_date'] = this.publish_date;
    data['publish_date_gmt'] = this.publish_date_gmt;
    data['release_date'] = this.release_date;
    data['run_time'] = this.run_time;
    data['trailer_link'] = this.trailer_link;
    data['url_link'] = this.url_link;
    data['logo'] = this.logo;
    data['is_watchlist'] = this.isInWatchList;
    data['is_liked'] = this.isLiked;
    data['likes'] = this.likes;
    data['postType'] = this.post_type;
    if (this.genre != null) {
      data['genre'] = this.genre!.map((v) => v.toJson()).toList();
    }
    if (this.tag != null) {
      data['tag'] = this.tag!.map((v) => v.toJson()).toList();
    }
    if (this.visibility != null) {
      data['visibility'] = this.visibility!.map((v) => v.toJson()).toList();
    }
    data['attachment'] = this.attachment;
    data['award_image'] = this.award_image;
    if (this.restSubPlan != null) {
      data['restrict_subscription_plan'] = this.restSubPlan!.map((e) => e.toJson()).toList();
    }
    data['restrict_user_status'] = this.restrict_user_status;
    if (this.restrictionSetting != null) {
      data['restriction_setting'] = this.restrictionSetting;
    }
    data['cast'] = this.cast;
    if (data['cat'] != null) {
      data['cat'] = this.cat!.map((e) => e.toJson()).toList();
    }
    data['is_featured'] = this.is_featured;
    data['name_upcoming'] = this.name_upcoming;
    data['views'] = this.views;
    data['imdb_rating'] = this.imdb_rating;
    data['no_of_comments'] = this.no_of_comments;
    if (data['casts'] != null) {
      data['casts'] = this.castsList;
    }
    data['character_name'] = this.character_name;
    data['release_year'] = this.release_year;
    data['share_url'] = this.share_url;
    data['total_seasons'] = this.total_seasons;
    data['user_has_membership'] = this.user_has_membership;
    data['user_has_pms_member'] = this.user_has_pms_member;
    data['is_post_restricted'] = this.is_post_restricted;
    if (data['sources'] != null) {
      data['sources'] = this.sourcesList!.map((e) => e.toJson()).toList();
    }
    data['is_comment_open'] = this.is_comment_open;

    return data;
  }
}

class Casts {
  String? id;
  String? character;
  int? position;
  String? image;
  String? name;

  Casts({this.id, this.character, this.position, this.image, this.name});

  factory Casts.fromJson(Map<String, dynamic> json) {
    return Casts(
      id: json['id'],
      character: json['character'],
      position: json['position'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['character'] = this.character;
    data['position'] = this.position;
    data['name'] = this.name;
    data['image'] = this.image;

    return data;
  }
}

class RestrictSubscriptionPlan {
  String? planId;
  String? label;

  RestrictSubscriptionPlan({this.planId, this.label});

  factory RestrictSubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return RestrictSubscriptionPlan(planId: json['id'], label: json['label']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.planId;
    data['label'] = this.label;
    return data;
  }
}

class RestrictionSetting {
  String? restrict_message;
  String? restrict_url;
  String? restrict_type;

  RestrictionSetting({this.restrict_message, this.restrict_type, this.restrict_url});

  factory RestrictionSetting.fromJson(Map<String, dynamic> json) {
    return RestrictionSetting(
      restrict_message: json['restrict_message'] != null ? json['restrict_message'] : null,
      restrict_type: json['restrict_type'] != null ? json['restrict_type'] : null,
      restrict_url: json['redirect_url'] != null ? json['redirect_url'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restrict_message'] = this.restrict_message;
    data['restrict_type'] = this.restrict_type;
    data['restrict_url'] = this.restrict_url;
    return data;
  }
}

class Genre {
  int? id;
  String? name;
  String? slug;

  Genre({this.id, this.name, this.slug});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Tag {
  int? id;
  String? name;
  String? slug;

  Tag({this.id, this.name, this.slug});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Visibility {
  int? id;
  String? name;
  String? slug;

  Visibility({this.id, this.name, this.slug});

  factory Visibility.fromJson(Map<String, dynamic> json) {
    return Visibility(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Season {
  String? description;
  List<Episode>? episode;
  String? image;
  String? name;
  int? position;
  String? year;
  String? restrict_user_status;
  RestrictionSetting? restriction_setting;
  List<RestrictSubscriptionPlan>? restrict_subscription_plan;

  Season(
      {this.description,
      this.episode,
      this.image,
      this.name,
      this.position,
      this.year,
      this.restrict_user_status,
      this.restriction_setting,
      this.restrict_subscription_plan});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      description: json['description'],
      episode: json['episode'] != null ? (json['episode'] as List).map((i) => Episode.fromJson(i)).toList() : null,
      image: json['image'],
      name: json['name'],
      position: json['position'],
      year: json['year'],
      restrict_user_status: json['restrict_user_status'],
      restriction_setting: json['restriction_setting'] != null ? RestrictionSetting.fromJson(json['restriction_setting']) : null,
      restrict_subscription_plan: json['restrict_subscription_plan'] != null
          ? (json['restrict_subscription_plan'] as List).map((e) => RestrictSubscriptionPlan.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['image'] = this.image;
    data['name'] = this.name;
    data['position'] = this.position;
    data['year'] = this.year;
    if (this.episode != null) {
      data['episode'] = this.episode!.map((v) => v.toJson()).toList();
    }
    data['restrict_user_status'] = this.restrict_user_status;
    data['restriction_setting'] = this.restriction_setting;
    if (data['restrict_subscription_plan'] != null) {
      data['restrict_subscription_plan'] = this.restrict_subscription_plan!.map((e) => e.toJson());
    }

    return data;
  }
}

class Episode {
  String? description;
  String? embed_content;
  String? choice;
  String? episode_number;
  String? excerpt;
  int? id;
  String? image;
  bool? is_featured;
  String? is_liked;
  bool? is_watchlist;
  int? likes;
  String? post_type;
  String? release_date;
  String? run_time;
  String? title;
  String? tv_show_id;
  String? file;
  String? url_link;
  String? restrict_user_status;
  String? trailer_link;
  int? no_of_comments;

  RestrictionSetting? restriction_setting;
  List<RestrictSubscriptionPlan>? restrict_subscription_plan;

  bool? is_post_restricted;
  bool? user_has_pms_member;
  List<Sources>? sourcesList;
  bool? is_comment_open;

  Episode({
    this.description,
    this.embed_content,
    this.choice,
    this.episode_number,
    this.excerpt,
    this.id,
    this.image,
    this.is_featured,
    this.is_liked,
    this.is_watchlist,
    this.likes,
    this.post_type,
    this.release_date,
    this.run_time,
    this.title,
    this.tv_show_id,
    this.file,
    this.url_link,
    this.restrict_user_status,
    this.restriction_setting,
    this.restrict_subscription_plan,
    this.trailer_link,
    this.no_of_comments,
    this.is_post_restricted,
    this.user_has_pms_member,
    this.sourcesList,
    this.is_comment_open,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      description: json['description'],
      file: json['episode_file'],
      url_link: json['url_link'],
      embed_content: json['embed_content'],
      choice: json['episode_choice'],
      episode_number: json['episode_number'],
      excerpt: json['excerpt'],
      id: json['id'],
      image: json['image'],
      is_featured: json['is_featured'],
      is_liked: json['is_liked'],
      is_watchlist: json['is_watchlist'],
      likes: json['likes'],
      post_type: json['post_type'],
      release_date: json['release_date'],
      run_time: json['run_time'],
      title: json['title'],
      tv_show_id: json['tv_show_id'],
      restrict_user_status: json['restrict_user_status'],
      restriction_setting: json['restriction_setting'] != null ? RestrictionSetting.fromJson(json['restriction_setting']) : null,
      restrict_subscription_plan: json['restrict_subscription_plan'] != null
          ? (json['restrict_subscription_plan'] as List).map((e) => RestrictSubscriptionPlan.fromJson(e)).toList()
          : null,
      trailer_link: json['trailer_link'],
      no_of_comments: json['no_of_comments'],
      is_post_restricted: json['is_post_restricted'],
      user_has_pms_member: json['user_has_pms_member'],
      sourcesList: json['sources'] == null ? [] : ((json['sources'] as List).map((e) => Sources.fromJson(e)).toList()),
      is_comment_open: json['is_comment_open'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['episode_file'] = this.file;
    data['url_link'] = this.url_link;
    data['description'] = this.description;
    data['embed_content'] = this.embed_content;
    data['episode_choice'] = this.choice;
    data['episode_number'] = this.episode_number;
    data['excerpt'] = this.excerpt;
    data['id'] = this.id;
    data['image'] = this.image;
    data['is_featured'] = this.is_featured;
    data['is_liked'] = this.is_liked;
    data['is_watchlist'] = this.is_watchlist;
    data['likes'] = this.likes;
    data['post_type'] = this.post_type;
    data['release_date'] = this.release_date;
    data['run_time'] = this.run_time;
    data['title'] = this.title;
    data['tv_show_id'] = this.tv_show_id;
    data['restrict_user_status'] = this.restrict_user_status;
    if (data['restriction_setting'] != null) {
      data['restriction_setting'] = this.restriction_setting;
    }
    if (data['restrict_subscription_plan'] != null) {
      data['restrict_subscription_plan'] = this.restrict_subscription_plan!.map((e) => e.toJson());
    }
    data['trailer_link'] = this.trailer_link;
    data['no_of_comments'] = this.no_of_comments;
    data['is_post_restricted'] = this.is_post_restricted;
    data['user_has_pms_member'] = this.user_has_pms_member;
    if (data['sources'] != null) {
      data['sources'] = this.sourcesList!.map((e) => e).toList();
    }
    data['is_comment_open'] = this.is_comment_open;

    return data;
  }
}
