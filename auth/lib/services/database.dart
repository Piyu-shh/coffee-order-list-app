import 'package:auth/model/brew.dart';
import 'package:auth/model/userId.dart';
import 'package:auth/screens/home/brew_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugar': sugars,
      'name': name,
      'strength': strength,
    });
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Brew(
          name: data["name"] ?? '',
          strength: data['strength'] ?? 0,
          sugar: data['sugar']);
    }).toList();
  }

//userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserData(
      uid: uid.toString(),
      name: data['name'],
      sugar: data['sugar'],
      strength: data['strength'],
    );
  }

//get brew streamq

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
