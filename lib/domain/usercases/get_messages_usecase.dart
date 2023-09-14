






import 'package:come_along_with_me/domain/entities/text_message_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class GetMessageUseCase{
  final FirebaseReposity repository;

  GetMessageUseCase({required this.repository});

 Stream<List<TextMessageEntity>> call(String channelId){
  return repository.getMessages(channelId);
 }
}