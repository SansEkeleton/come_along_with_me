





import 'package:come_along_with_me/domain/entities/my_chat_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class GetMyChatUseCase{
  final FirebaseReposity repository;

  GetMyChatUseCase({required this.repository});

  Stream<List<MyChatEntity>> call(String uid){
    return repository.getMyChat(uid);
  }

}