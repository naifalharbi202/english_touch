﻿class UserModel {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? uId;

// Constructer to create a user model instance
  UserModel(
    this.name,
    this.email,
    this.password,
    this.phone,
    this.uId,
  );

  // Named constructer .. To get data from firestore
  UserModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    uId = json['uId'];
  }

  // Func to send data as a map (to users collection in firestore)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'uId': uId,
    };
  }
}
