


import 'package:come_along_with_me/data/remote_data_source/firebase_remote_data_source.dart';
import 'package:come_along_with_me/domain/entities/engage_user_entity.dart';
import 'package:come_along_with_me/domain/entities/group_entity.dart';
import 'package:come_along_with_me/domain/entities/my_chat_entity.dart';
import 'package:come_along_with_me/domain/entities/text_message_entity.dart';
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

  @override
  Future<void> addToMyChat(MyChatEntity myChatEntity) async{
   return await remoteDataSource.addToMyChat(myChatEntity);
  }

  @override
  Future<void> createNewGroup(MyChatEntity myChatEntity, List<String> selectUserList) {
    return remoteDataSource.createNewGroup(myChatEntity, selectUserList);
  }

  @override
   Future<String> createOneToOneChatChannel(EngageUserEntity engageUserEntity) async =>
      remoteDataSource.createOneToOneChatChannel(engageUserEntity);

  @override
 Future<String> getChannelId(EngageUserEntity engageUserEntity) async {
    return remoteDataSource.getChannelId(engageUserEntity);
  }

  @override
 Future<void> getCreateGroup(GroupEntity groupEntity) async =>
      remoteDataSource.getCreateGroup(groupEntity);

  @override
   Future<void> getCreateNewGroupChatRoom(MyChatEntity myChatEntity, List<String> selectUserList) {
    return remoteDataSource.createNewGroup(myChatEntity, selectUserList);
  }

  @override
  Stream<List<GroupEntity>> getGroups() =>
      remoteDataSource.getGroups();

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    return remoteDataSource.getMessages(channelId);
  }

  @override
  Stream<List<MyChatEntity>> getMyChat(String uid) {
   return remoteDataSource.getMyChat(uid);
  }

  @override
  Future<void> joinGroup(GroupEntity groupEntity) async =>
      remoteDataSource.joinGroup(groupEntity);

  @override
   Future<void> sendTextMessage(
          TextMessageEntity textMessageEntity, String channelId) async {
      return await remoteDataSource.sendTextMessage(textMessageEntity, channelId);
}

  @override
   Future<void> updateGroup(GroupEntity groupEntity) async =>
      remoteDataSource.updateGroup(groupEntity);
}
  
  
