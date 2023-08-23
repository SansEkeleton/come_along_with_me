




import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class GetUpdateUserCase {
  final FirebaseReposity repository;

  GetUpdateUserCase({required this.repository});

  Future<void> call(UserEntity User)  {
    return  repository.getUpdateUser(User);
  }
}