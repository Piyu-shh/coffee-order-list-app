import 'package:firebase_auth/firebase_auth.dart';

class Userid {
  final String? uid;

  Userid({required this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String sugar;
  final int strength;

  UserData(
      {required this.uid,
      required this.sugar,
      required this.strength,
      required this.name});
  String get uidd {
    return uid;
  }
}
