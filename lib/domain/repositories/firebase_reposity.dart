import 'package:come_along_with_me/domain/entities/engage_user_entity.dart';
import 'package:come_along_with_me/domain/entities/group_entity.dart';
import 'package:come_along_with_me/domain/entities/my_chat_entity.dart';
import 'package:come_along_with_me/domain/entities/text_message_entity.dart';
import 'package:come_along_with_me/domain/entities/user_entity.dart';

abstract class FirebaseReposity {
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<bool> isSignIn();
  Future<void> getUpdateUser(UserEntity user);
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<String> getCurrentUserId();
  Future<void> googleAuth();
  Future<void> forgotPassword(String email);
  Stream<List<UserEntity>> getAllUsers();


 Future<void> getCreateGroup(GroupEntity groupEntity);
  Stream<List<GroupEntity>> getGroups();
  Future<void> joinGroup(GroupEntity groupEntity);
  Future<void> updateGroup(GroupEntity groupEntity);
Future<String> createOneToOneChatChannel(EngageUserEntity engageUserEntity);
  Future<String> getChannelId(EngageUserEntity engageUserEntity);
  Future<void> createNewGroup(MyChatEntity myChatEntity,List<String> selectUserList);
  Future<void> getCreateNewGroupChatRoom(MyChatEntity myChatEntity,List<String> selectUserList);
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,String channelId);
  Stream<List<TextMessageEntity>> getMessages(String channelId);
  Future<void> addToMyChat(MyChatEntity myChatEntity);
  Stream<List<MyChatEntity>> getMyChat(String uid);

}
