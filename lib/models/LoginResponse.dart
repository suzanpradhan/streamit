import 'BaseResponse.dart';
import 'UserPlan.dart';

class LoginResponse extends BaseResponse {
  String? first_name;
  String? last_name;
  String? profile_image;
  String? token;
  String? user_email;
  int? user_id;
  String? user_nicename;
  UserPlan? plan;
  String? username;

  LoginResponse({
    this.first_name,
    this.last_name,
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
      first_name: json['first_name'],
      last_name: json['last_name'],
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
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
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
