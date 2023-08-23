import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come_along_with_me/data/remote_data_source/firebase_remote_data_source.dart';
import 'package:come_along_with_me/data/user_model.dart';
import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  FirebaseRemoteDataSourceImpl({
    required this.fireStore,
    required this.auth,
    required this.googleSignIn,
  });

  get context => null;

  @override
  Future<void> forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection("users");

    try {
      final uid = await getCurrentUserId();

      final userDoc = await userCollection.doc(uid).get();
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        email: user.email,
        profileUrl: user.profileUrl,
        status: user.status,
        phone: user.phone,
        password: user.password,
        isOnline: user.isOnline,
      ).toDocument();

      if (!userDoc.exists) {
        await userCollection.doc(uid).set(newUser);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<String> getCurrentUserId() async {
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    } else {
      // Handle the case when the current user is null.
      // You can return a default value or throw a custom exception.
      throw Exception("Current user is null");
    }
  }

  @override
  Future<void> getUpdateUser(UserEntity user) async {
 
    Map<String,dynamic> userInformation = {};
    final userCollection = fireStore.collection("users");

    if (user.profileUrl != null && user.profileUrl != " ") {
      userInformation['profileUrl'] = user.profileUrl;
    }

    if (user.name != null && user.name != " ") {
      userInformation['name'] = user.name;
    }
    if (user.status != null && user.status != " ") {
      userInformation['status'] = user.status;
    }
    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = fireStore.collection("users");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());

  }

  @override
  Future<void> googleAuth() async {
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await account!.authentication;

final authCredrential =  GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final userInformation = (await auth.signInWithCredential(authCredrential)).user;
    getCreateCurrentUser(UserEntity(
      uid: userInformation!.uid,
      name: userInformation.displayName,
      email: userInformation.email,
      profileUrl: userInformation.photoURL,
      status: "Hey there, I am using Come Along With Me",
      phone: userInformation.phoneNumber,
      isOnline: true,
    ));
    
  }



  @override
  Future<bool> isSignIn() async {
    final user = auth.currentUser;
    return user != null;
  }

  @override
  Future<void> signIn(UserEntity user) async {
    final email = user.email;
    final password = user.password;

    if (email != null && password != null) {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
            msg: 'Wrong password',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else if (e.code == 'user-not-found') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Incorrect email'),
                content: Text('The email address entered is incorrect.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Sign in failed with error: ${e.code}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> signUp(UserEntity user) async {
    final email = user.email;
    final password = user.password;

    try {
      if (email != null && password != null) {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: 'Wrong password',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Incorrect email'),
              content: Text('The email address entered is incorrect.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Sign in failed with error: ${e.code}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }
}
