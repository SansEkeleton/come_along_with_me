




import 'package:come_along_with_me/domain/entities/group_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class JoinGroupUseCase {
  final FirebaseReposity repository;

  JoinGroupUseCase({required this.repository});

  Future<void> call(GroupEntity groupEntity)async{
    return await repository.joinGroup(groupEntity);
  }
}