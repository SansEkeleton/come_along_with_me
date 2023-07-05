



import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class SignUpCase {

  final FirebaseReposity reposity;

  SignUpCase({required this.reposity});

  Future<void> call(UserEntity user) {
    return reposity.signUp(user);
  }
}