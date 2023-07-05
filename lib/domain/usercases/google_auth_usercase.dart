





import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

class GoogleAuthUserCase {

  final FirebaseReposity reposity;

  GoogleAuthUserCase({required this.reposity});

  Future<void> call() async  {
    return reposity.googleAuth();
  }
}