




import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';



class CreateCurrentUserCase{

  final FirebaseReposity reposity;

  CreateCurrentUserCase({required this.reposity});

  Future<void> call(UserEntity user) async {
    return  reposity.getCreateCurrentUser(user);
  }
}