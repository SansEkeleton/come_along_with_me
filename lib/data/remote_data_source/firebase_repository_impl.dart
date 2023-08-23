


import 'package:come_along_with_me/data/remote_data_source/firebase_remote_data_source.dart';
import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class FirebaseReposityImpl implements FirebaseReposity{


  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseReposityImpl({required this.remoteDataSource});



 @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    remoteDataSource.getCreateCurrentUser(user);
  }

  @override
    Future<String> getCurrentUserId() async =>
      await remoteDataSource.getCurrentUserId();

  @override
  Future<void> getUpdateUser(UserEntity user) async {
    remoteDataSource.getUpdateUser(user);
  }

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signIn(UserEntity user)async {
    remoteDataSource.signIn(user);
  }

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> signUp(UserEntity user) async{
    remoteDataSource.signUp(user);
  }
  
  @override
  Future<void> forgotPassword(String email) async => remoteDataSource.forgotPassword(email);
  
  
  @override
  Future<void> googleAuth() async => remoteDataSource.googleAuth();
  
  @override
  
    Stream<List<UserEntity>> getAllUsers() => remoteDataSource.getAllUsers();
  
  
}