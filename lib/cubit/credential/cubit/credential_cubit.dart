import 'dart:io';

import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:come_along_with_me/domain/usercases/forgot_password_case.dart';
import 'package:come_along_with_me/domain/usercases/get_create_current_user_case.dart';
import 'package:come_along_with_me/domain/usercases/google_auth_usercase.dart';
import 'package:come_along_with_me/domain/usercases/sign_in_use_case.dart';
import 'package:come_along_with_me/domain/usercases/sing_up_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInCase signInUseCase;
  final SignUpCase signUpUseCase;
  final ForgotPasswordCase forgotPasswordCase;
  final GoogleAuthUserCase googleAuthUserCase;
  final CreateCurrentUserCase createCurrentUserCase;
  
  CredentialCubit({
  required this.forgotPasswordCase, 
  required this.googleAuthUserCase,
  required this.signInUseCase, 
  required this.signUpUseCase, 
  required this.createCurrentUserCase}
  ) : super(CredentialInitial());


  Future<void> submitSignIn({required UserEntity user}) async {
  emit(CredentialLoading());
    try{
       await signInUseCase.call(UserEntity(email: user.email, password: user.password));
        emit(CredentialSucess());
    }on SocketException catch(_){
        emit(CredentialFailure());
    }catch(_){
      emit(CredentialFailure());
    }
  }

  Future<void> submitSignUp({required UserEntity user}) async {
         emit(CredentialLoading());
    try{
      await signUpUseCase.call(UserEntity(email: user.email, password: user.password));
      await createCurrentUserCase.call(user);
      emit(CredentialSucess());
    }on SocketException catch(_){
        emit(CredentialFailure());
    }catch(_){
      emit(CredentialFailure());
    }
  }

  Future<void> submitGoogleAuth() async {
   
  emit(CredentialLoading());
    try{
     await googleAuthUserCase.call();
      emit(CredentialSucess());
    }on SocketException catch(_){
        emit(CredentialFailure());
    }catch(_){
      emit(CredentialFailure());
    }
  }

  Future<void> forgotPassword({required UserEntity user}) async {
 

    try{
      await forgotPasswordCase.call(user.email!);
      emit(CredentialSucess());
    }on SocketException catch(_){
        emit(CredentialFailure());
    }catch(_){
      emit(CredentialFailure());
    }
  }
}

