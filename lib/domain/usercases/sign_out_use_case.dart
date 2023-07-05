




import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class SignOutUseCase {
  final FirebaseReposity reposity;

  SignOutUseCase({required this.reposity});

  Future<void> call() async {
    return reposity.signOut();
  }
}