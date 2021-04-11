import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  Future<void> updateUserData(String sugars, String name, int strength) async{
    try{
      return await brewCollection.doc(uid).set({
        'sugars': sugars,
        'name': name,
        'strength': strength,
      });

    }on FirebaseException catch(e){
      print(" ERROR -> ${e.toString()}");
    }

  }
  //brew list from a snapshot
   List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Brew(
        name: doc.data()['name'] ?? '',
        strength: doc.data()['strength'] ?? 0,
        sugars: doc.data()['sugars'] ?? '0',
      );
    }).toList();
  }
  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name:  snapshot.data()['name'],
      sugars:  snapshot.data()['sugars'],
      strength:  snapshot.data()['strength'],

    );
  }
  //get brew stream
  Stream<List<Brew>> get brews{
    return brewCollection.snapshots()
        .map(_brewListFromSnapshot);
  }
  //get user doc stream
  Stream<UserData> get userdata {
    return brewCollection.doc(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

}

//
// class DatabaseService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseMessaging fcm = FirebaseMessaging.instance;
//   final String uid;
//   DatabaseService({this.uid});
//
//   Future saveUser(user, String uid) async {
//     user.uid = uid;
//     try {
//       user.token = await fcm.getToken();
//       await _db.collection("users").doc(uid).set(user.toFirestore());
//     } catch (e) { print("saveUser ERROR -> ${e.toString()}"); } }}