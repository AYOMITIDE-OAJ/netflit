import 'package:streamit_flutter/models/MovieData.dart';

class CastModel {
  Data? data;
  List<dynamic>? mostViewMovieTvShow;
  List<MovieData>? movie;
  List<Episode>? tvShow;

  CastModel({this.data, this.mostViewMovieTvShow, this.movie, this.tvShow});

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      mostViewMovieTvShow: json['most_view_movie_tv_show'] != null
          ? (json['most_view_movie_tv_show'] as List).map((i) {
              return MovieData.fromJson(i);
            }).toList()
          : null,
      movie: json['movie'] != null ? (json['movie'] as List).map((i) => MovieData.fromJson(i)).toList() : null,
      tvShow: json['tv_show'] != null ? (json['tv_show'] as List).map((i) => Episode.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.mostViewMovieTvShow != null) {
      data['most_view_movie_tv_show'] = this.mostViewMovieTvShow!.map((v) => v.toJson()).toList();
    }
    if (this.movie != null) {
      data['movie'] = this.movie!.map((v) => v.toJson()).toList();
    }
    if (this.tvShow != null) {
      data['tv_show'] = this.tvShow!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? alsoKnownAs;
  String? birthday;
  String? category;
  int? credits;
  String? deathDay;
  int? id;
  String? image;
  String? placeOfBirth;
  String? title;
  String? description;

  Data({
    this.alsoKnownAs,
    this.birthday,
    this.category,
    this.credits,
    this.deathDay,
    this.id,
    this.image,
    this.placeOfBirth,
    this.title,
    this.description,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      alsoKnownAs: json['also_known_as'],
      birthday: json['birthday'],
      category: json['category'],
      credits: json['credits'],
      deathDay: json['deathday'],
      id: json['id'],
      image: json['image'],
      placeOfBirth: json['place_of_birth'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['also_known_as'] = this.alsoKnownAs;
    data['birthday'] = this.birthday;
    data['category'] = this.category;
    data['credits'] = this.credits;
    data['id'] = this.id;
    data['image'] = this.image;
    data['place_of_birth'] = this.placeOfBirth;
    data['title'] = this.title;
    if (this.deathDay != null) {
      data['deathday'] = this.deathDay;
    }
    data['description'] = this.description;
    return data;
  }
}
