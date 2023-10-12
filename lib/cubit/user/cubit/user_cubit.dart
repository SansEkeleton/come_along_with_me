import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:come_along_with_me/domain/usercases/get_all_users_usercase.dart';
import 'package:come_along_with_me/domain/usercases/get_update_user_case.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final getAllUserUseCase getAllUsersUseCase;
  final GetUpdateUserCase getUpdateUserCase;
  UserCubit({required this.getAllUsersUseCase, required this.getUpdateUserCase}) : super(UserInitial());


  Future<void> getUsers() async{
    try{

      getAllUsersUseCase.call().listen((listUsers) { emit(UserLoaded(users: listUsers)); });
    }on SocketException catch(_){
      emit(UserFailure());
    }catch(_){
      emit(UserFailure());
    }
  }

  Future<void> updateUsers({required UserEntity user}) async{
    try{

      getUpdateUserCase.call(user);
    }on SocketException catch(_){
      emit(UserFailure());
    }catch(_){

    }
  }

}

