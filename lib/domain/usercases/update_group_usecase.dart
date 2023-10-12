



import 'package:come_along_with_me/domain/entities/group_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';


class UpdateGroupUseCase{
  final FirebaseReposity repository;

  UpdateGroupUseCase({required this.repository});
  Future<void> call(GroupEntity groupEntity){
    return repository.updateGroup(groupEntity);
  }

}