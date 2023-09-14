





import 'package:come_along_with_me/domain/entities/my_chat_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class CreateNewGroupUseCase{
  final FirebaseReposity repository;

  CreateNewGroupUseCase({required this.repository});

  Future<void> call(MyChatEntity myChatEntity,List<String> selectUserList)async{
    return repository.createNewGroup(myChatEntity, selectUserList);
  }

}