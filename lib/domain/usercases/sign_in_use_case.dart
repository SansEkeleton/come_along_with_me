



import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';


class SignInCase{

  final FirebaseReposity reposity;

  SignInCase({required this.reposity});

  Future<void> call(UserEntity user) {
    return reposity.signIn(user);
  }
}