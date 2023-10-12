





import 'package:come_along_with_me/domain/entities/group_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class GetAllGroupsUseCase{
  final FirebaseReposity repository;

  GetAllGroupsUseCase({required this.repository});

  Stream<List<GroupEntity>> call(){
    return repository.getGroups();
  }
}