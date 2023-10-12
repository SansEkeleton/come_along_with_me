


import 'package:come_along_with_me/domain/entities/engage_user_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';


class GetChannelIdUseCase{
  final FirebaseReposity repository;

  GetChannelIdUseCase({required this.repository});

  Future<String> call(EngageUserEntity engageUserEntity) async{
    return repository.getChannelId(engageUserEntity);
  }
}