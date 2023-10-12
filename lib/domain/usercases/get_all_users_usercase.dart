



import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';

import '../entities/user_entity.dart';

// ignore: camel_case_types
class getAllUserUseCase{

final FirebaseReposity repository;

  getAllUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(){
    return repository.getAllUsers();
  }
}