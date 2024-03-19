import 'package:flutter/material.dart';

class UserModel {
  final String name;
  final String email;

  UserModel({required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
