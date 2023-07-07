import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come_along_with_me/data/remote_data_source/firebase_remote_data_source.dart';
import 'package:come_along_with_me/data/user_model.dart';
import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        // Save the user document to Firestore
        await userCollection.doc(uid).set(newUser);
      }
    } catch (e) {
      // Handle the exception here
      print(e.toString());
      // You can throw a custom exception or handle the error in another way.
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
  Future<void> getUpdateUser(UserEntity user) {
    // TODO: implement getUpdateUser
    throw UnimplementedError();
  }

  @override
  Future<void> googleAuth() {
    // TODO: implement googleAuth
    throw UnimplementedError();
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
      await auth.signInWithEmailAndPassword(email: email, password: password);
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
      if (e.code == 'email-already-in-use') {
        // Handle the case when the email address is already in use
        // You can show an error message to the user or perform any other desired action.
        print('Email address is already in use.');
      } else {
        // Handle other FirebaseAuthExceptions
        print('Sign up failed with error: ${e.code}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Sign up failed with error: $e');
    }
  }
}
