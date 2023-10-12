





import 'package:come_along_with_me/domain/entities/my_chat_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class GetCreateNewGroupChatRoomUseCase{
  final FirebaseReposity repository;

  GetCreateNewGroupChatRoomUseCase({required this.repository});

  Future<void> call(MyChatEntity myChatEntity,List<String> selectUserList){
    return repository.getCreateNewGroupChatRoom(myChatEntity, selectUserList);
  }

}