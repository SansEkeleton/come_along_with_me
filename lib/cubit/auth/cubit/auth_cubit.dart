import 'dart:io';

import 'package:come_along_with_me/domain/usercases/get_current_user.dart';
import 'package:come_along_with_me/domain/usercases/is_sign_in_use_case.dart';
import 'package:come_along_with_me/domain/usercases/sign_out_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  final IsSignInUseCase isSignInUseCase;
  final GetCurrentUserIdCase getCurrentUserIdCase;
  final SignOutUseCase signOutUseCase;
  AuthCubit ({
    required this.isSignInUseCase,
    required this.getCurrentUserIdCase,
    required this.signOutUseCase,
  }) : super(AuthInitial());



  Future <void> appStarted() async {

    try{

    bool isSignIn=await isSignInUseCase.call();
      
      if(isSignIn==true){
        final uid=await getCurrentUserIdCase.call();
        emit(AuthenticatedState(uid: uid));
        }else{
          emit(UnAuthenticatedState());
        }
      
    }on SocketException catch(_){
      emit(UnAuthenticatedState());
    }

  }

  Future<void>loggedIn() async{

    try{
    final uid=await getCurrentUserIdCase.call();
    emit(AuthenticatedState(uid: uid));
    }catch(_){
      emit(UnAuthenticatedState());
    }
  }

  Future <void> loggedOut() async{

    try{
        signOutUseCase.call();
        emit(UnAuthenticatedState());

    }catch(_){
      emit(UnAuthenticatedState());
    }
  }
}
