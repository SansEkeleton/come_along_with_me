



import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class IsSignInUseCase {

  final FirebaseReposity reposity;

  IsSignInUseCase({required this.reposity});

  Future<bool> call() async {
    return reposity.isSignIn();
  }
}