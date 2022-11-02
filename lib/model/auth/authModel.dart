// ignore_for_file: public_member_api_docs, sort_constructors_first, camel_case_types
import 'dart:convert';

class authModel {
  int id;
  String username;
  String email;
  authModel({
    required this.id,
    required this.username,
    required this.email,
  });

  authModel copyWith({
    int? id,
    String? username,
    String? email,
  }) {
    return authModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
    };
  }

  factory authModel.fromMap(Map<String, dynamic> map) {
    return authModel(
      id: map['id'] as int,
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory authModel.fromJson(String source) => authModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'authModel(id: $id, username: $username, email: $email)';

  @override
  bool operator ==(covariant authModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.username == username &&
      other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ email.hashCode;
}
