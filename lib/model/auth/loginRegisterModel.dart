// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:floran_todo/model/auth/authModel.dart';

class loginRegisterModel {
  authModel user;
  String token;
  loginRegisterModel({
    required this.user,
    required this.token,
  });

  loginRegisterModel copyWith({
    authModel? user,
    String? token,
  }) {
    return loginRegisterModel(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'token': token,
    };
  }

  factory loginRegisterModel.fromMap(Map<String, dynamic> map) {
    return loginRegisterModel(
      user: authModel.fromMap(map['user'] as Map<String,dynamic>),
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory loginRegisterModel.fromJson(String source) => loginRegisterModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'loginRegisterModel(user: $user, token: $token)';

  @override
  bool operator ==(covariant loginRegisterModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.user == user &&
      other.token == token;
  }

  @override
  int get hashCode => user.hashCode ^ token.hashCode;
}
