

import 'package:come_along_with_me/domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource{

  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<bool> isSignIn();
  Future<void> getUpdateUser(UserEntity user);
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<String> getCurrentUserId();
  Future<void> googleAuth();
  Future<void> forgotPassword(String email);
}