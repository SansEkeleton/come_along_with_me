




import 'package:come_along_with_me/domain/entities/my_chat_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class AddToMyChatUseCase {
  final FirebaseReposity repository;

  AddToMyChatUseCase({required this.repository});

  Future<void> call(MyChatEntity myChatEntity)async{
    return await repository.addToMyChat(myChatEntity);
  }
}