




import 'package:come_along_with_me/domain/entities/text_message_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class SendMyTextMessage{
  final FirebaseReposity repository;

  SendMyTextMessage({required this.repository});

  Future<void> call(TextMessageEntity textMessageEntity,String channelId)async{
    return await repository.sendTextMessage(textMessageEntity, channelId);
  }

}