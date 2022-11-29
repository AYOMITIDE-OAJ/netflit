import 'package:streamit_flutter/models/MovieData.dart';

class DashboardResponse {
  String? registerPage;
  String? accountPage;
  String? loginPage;
  List<MovieData>? banner;
  List<Slider>? sliders;

  DashboardResponse({
    this.banner,
    this.sliders,
    this.registerPage,
    this.accountPage,
    this.loginPage,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      banner: json['banner'] != null ? (json['banner'] as List).map((i) => MovieData.fromJson(i)).toList() : null,
      sliders: json['sliders'] != null ? (json['sliders'] as List).map((i) => Slider.fromJson(i)).toList() : null,
      registerPage: json['register_page'] != null ? json['register_page'] : null,
      accountPage: json['account_page'] != null ? json['account_page'] : null,
      loginPage: json['login_page'] != null ? json['login_page'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    if (this.sliders != null) {
      data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
    }
    data['register_page'] = this.registerPage;
    data['account_page'] = this.accountPage;
    data['login_page'] = this.loginPage;
    return data;
  }
}

class Slider {
  List<MovieData>? data;
  String? title;
  bool? viewAll;

  Slider({this.data, this.title, this.viewAll});

  factory Slider.fromJson(Map<String, dynamic> json) {
    return Slider(
      data: json['data'] != null ? (json['data'] as List).map((i) => MovieData.fromJson(i)).toList() : null,
      title: json['title'],
      viewAll: json['view_all'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['view_all'] = this.viewAll;
    return data;
  }
}
