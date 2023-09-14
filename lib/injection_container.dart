


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come_along_with_me/cubit/auth/cubit/auth_cubit.dart';
import 'package:come_along_with_me/cubit/chat/chat_cubit.dart';
import 'package:come_along_with_me/cubit/credential/cubit/credential_cubit.dart';
import 'package:come_along_with_me/cubit/group/group_cubit.dart';
import 'package:come_along_with_me/data/remote_data_source/firebase_remote_data_source.dart';
import 'package:come_along_with_me/data/remote_data_source/firebase_remote_data_source_impl.dart';
import 'package:come_along_with_me/data/remote_data_source/firebase_repository_impl.dart';
import 'package:come_along_with_me/domain/repositories/firebase_reposity.dart';
import 'package:come_along_with_me/domain/usercases/create_group_usecase.dart';
import 'package:come_along_with_me/domain/usercases/forgot_password_case.dart';
import 'package:come_along_with_me/domain/usercases/get_all_group_usecase.dart';
import 'package:come_along_with_me/domain/usercases/get_all_users_usercase.dart';
import 'package:come_along_with_me/domain/usercases/get_create_current_user_case.dart';
import 'package:come_along_with_me/domain/usercases/get_current_user.dart';
import 'package:come_along_with_me/domain/usercases/get_messages_usecase.dart';
import 'package:come_along_with_me/domain/usercases/get_update_user_case.dart';
import 'package:come_along_with_me/domain/usercases/google_auth_usercase.dart';
import 'package:come_along_with_me/domain/usercases/is_sign_in_use_case.dart';
import 'package:come_along_with_me/domain/usercases/join_group_usecase.dart';
import 'package:come_along_with_me/domain/usercases/send_text_message_usecase.dart';
import 'package:come_along_with_me/domain/usercases/sign_in_use_case.dart';
import 'package:come_along_with_me/domain/usercases/sign_out_use_case.dart';
import 'package:come_along_with_me/domain/usercases/sing_up_use_case.dart';
import 'package:come_along_with_me/domain/usercases/update_group_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'cubit/user/cubit/user_cubit.dart';



final sl = GetIt.instance;


Future<void> init() async{


  //bloc
  sl.registerFactory<AuthCubit>(() => AuthCubit(
    isSignInUseCase: sl.call(), 
    getCurrentUserIdCase: sl.call(), 
    signOutUseCase: sl.call()));

  sl.registerFactory<UserCubit>(() => UserCubit(
    getAllUsersUseCase: sl.call(), 
    getUpdateUserCase: sl.call()));  

  sl.registerFactory<CredentialCubit>(() => CredentialCubit(
    signInUseCase: sl.call(), 
    signUpUseCase: sl.call(), 
    createCurrentUserCase: sl.call(), 
    forgotPasswordCase: sl.call(), 
    googleAuthUserCase: sl.call()));

  sl.registerFactory<GroupCubit>(() =>
      GroupCubit(
        getAllGroupsUseCase: sl.call(),
        getCreateGroupUseCase: sl.call(),
        joinGroupUseCase: sl.call(),
        groupUseCase: sl.call(),
      ));
  sl.registerFactory<ChatCubit>(() =>
      ChatCubit(
        getMessageUseCase: sl.call(),
        sendTextMessageUseCase: sl.call(),

      ));

  //use cases
  //auth cases
  sl.registerLazySingleton<GetCurrentUserIdCase>(() => GetCurrentUserIdCase(reposity: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(() => IsSignInUseCase(reposity: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(reposity: sl.call()));
  sl.registerLazySingleton<GetUpdateUserCase>(() => GetUpdateUserCase(repository: sl.call()));
  sl.registerLazySingleton<getAllUserUseCase>(() => getAllUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCreateGroupUseCase>(
          () => GetCreateGroupUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetAllGroupsUseCase>(
          () => GetAllGroupsUseCase(repository: sl.call()));
  sl.registerLazySingleton<JoinGroupUseCase>(
          () => JoinGroupUseCase(repository: sl.call()));
  sl.registerLazySingleton<UpdateGroupUseCase>(
          () => UpdateGroupUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetMessageUseCase>(
          () => GetMessageUseCase(repository: sl.call()));
  sl.registerLazySingleton<SendTextMessageUseCase>(
          () => SendTextMessageUseCase(repository: sl.call()));

  //credential cases
  sl.registerLazySingleton<SignInCase>(() => SignInCase(reposity: sl.call()));
  sl.registerLazySingleton<SignUpCase>(() => SignUpCase(reposity: sl.call()));
  sl.registerLazySingleton<CreateCurrentUserCase>(() => CreateCurrentUserCase(reposity: sl.call()));
  sl.registerLazySingleton<ForgotPasswordCase>(() => ForgotPasswordCase(reposity: sl.call()));
  sl.registerLazySingleton<GoogleAuthUserCase>(() => GoogleAuthUserCase(reposity: sl.call()));





//repository
sl.registerLazySingleton<FirebaseReposity>(() => FirebaseReposityImpl(remoteDataSource: sl.call() ));


//Remote Data Source

sl.registerLazySingleton<FirebaseRemoteDataSource>(() => FirebaseRemoteDataSourceImpl(fireStore: sl.call(), auth: sl.call(), googleSignIn: sl.call() ));

  //External
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final googleSignIn = GoogleSignIn();

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => firestore);
  sl.registerLazySingleton(() => googleSignIn);
}