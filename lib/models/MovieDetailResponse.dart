import 'MovieData.dart';

class MovieDetailResponse {
  MovieData? data;
  List<MovieData>? recommended_movie;
  List<MovieData>? upcomming_movie;
  List<MovieData>? upcomming_video;
  List<Season>? seasons;

  MovieDetailResponse({
    this.data,
    this.recommended_movie,
    this.seasons,
    this.upcomming_movie,
    this.upcomming_video,
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailResponse(
      data: json['data'] != null ? MovieData.fromJson(json['data']) : null,
      recommended_movie: json['recommended_movie'] != null ? (json['recommended_movie'] as List).map((i) => MovieData.fromJson(i)).toList() : null,
      upcomming_movie: json['upcomming_movie'] != null ? (json['upcomming_movie'] as List).map((i) => MovieData.fromJson(i)).toList() : null,
      upcomming_video: json['upcomming_video'] != null ? (json['upcomming_video'] as List).map((e) => MovieData.fromJson(e)).toList() : null,
      seasons: json['seasons'] != null ? (json['seasons'] as List).map((i) => Season.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.recommended_movie != null) {
      data['recommended_movie'] = this.recommended_movie!.map((v) => v.toJson()).toList();
    }
    if (this.upcomming_movie != null) {
      data['upcomming_movie'] = this.upcomming_movie!.map((v) => v.toJson()).toList();
    }
    if (this.upcomming_video != null) {
      data['upcomming_video'] = this.upcomming_video!.map((e) => e.toJson()).toList();
    }
    if (this.seasons != null) {
      data['seasons'] = this.seasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
