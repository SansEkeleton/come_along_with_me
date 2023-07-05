




import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';


class GetCurrentUserIdCase{

  final FirebaseReposity reposity;

  GetCurrentUserIdCase({required this.reposity});

  Future<String> call() async {
    return await reposity.getCurrentUserId();
  }
}