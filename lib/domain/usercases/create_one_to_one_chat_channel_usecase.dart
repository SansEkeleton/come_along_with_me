




import 'package:come_along_with_me/domain/entities/engage_user_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class CreateOneToOneChatChannelUseCase {
  final FirebaseReposity repository;

  CreateOneToOneChatChannelUseCase({required this.repository});

  Future<String> call(EngageUserEntity engageUserEntity)async{
    return repository.createOneToOneChatChannel(engageUserEntity);
  }
}
