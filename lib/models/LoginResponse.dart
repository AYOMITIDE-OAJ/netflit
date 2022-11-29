import 'BaseResponse.dart';
import 'UserPlan.dart';

class LoginResponse extends BaseResponse {
  String? firstName;
  String? lastName;
  String? profile_image;
  String? token;
  String? user_email;
  int? user_id;
  String? user_nicename;
  UserPlan? plan;
  String? username;

  LoginResponse({
    this.firstName,
    this.lastName,
    this.profile_image,
    this.token,
    this.user_email,
    this.user_id,
    this.user_nicename,
    this.plan,
    this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      firstName: json['first_name'],
      lastName: json['last_name'],
      profile_image: json['streamit_profile_image'],
      token: json['token'],
      user_email: json['user_email'],
      user_id: json['user_id'],
      user_nicename: json['user_nicename'],
      plan: json['plan'] != null ? UserPlan.fromJson(json['plan']) : null,
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['streamit_profile_image'] = this.profile_image;
    data['token'] = this.token;
    data['user_email'] = this.user_email;
    data['user_id'] = this.user_id;
    data['user_nicename'] = this.user_nicename;
    if (data['plan'] != null) {
      data['plan'] = this.plan;
    }
    data['username'] = this.username;
    return data;
  }
}
