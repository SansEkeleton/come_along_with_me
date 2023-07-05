



import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class ForgotPasswordCase{

  final FirebaseReposity reposity;

  ForgotPasswordCase({required this.reposity});

  Future<void> call(String email) async {
    return await reposity.forgotPassword(email);
  }
}