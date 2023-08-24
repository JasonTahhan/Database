import 'package:flutter/material.dart';

class UserInfo {
  String userId;
  String firstName;
  String lastName;
  DateTime dateOfBirth;

  UserInfo({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth.toIso8601String(),
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      userId: map['userId'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      dateOfBirth: DateTime.parse(map['date_of_birth']),
    );
  }
}
