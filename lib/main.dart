import 'package:come_along_with_me/Pages/home_page.dart';
import 'package:come_along_with_me/Pages/login_page.dart';
import 'package:come_along_with_me/Routes/routes.dart';
import 'package:come_along_with_me/cubit/auth/cubit/auth_cubit.dart';
import 'package:come_along_with_me/cubit/chat/chat_cubit.dart';
import 'package:come_along_with_me/cubit/credential/cubit/credential_cubit.dart';
import 'package:come_along_with_me/cubit/group/group_cubit.dart';
import 'package:come_along_with_me/cubit/user/cubit/user_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();

  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider<CredentialCubit>(
          create: (_) => di.sl<CredentialCubit>()),
        BlocProvider<UserCubit>(
          create: (_) => di.sl<UserCubit>()..getUsers()),
        BlocProvider<GroupCubit>(
          create: (_) => di.sl<GroupCubit>()..getGroups(),
        ),
        BlocProvider<ChatCubit>(
          create: (_) => di.sl<ChatCubit>(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CAWM',
          theme: ThemeData(),
          onGenerateRoute: Routes.route,
          initialRoute: "/",
          routes: {
            "/": (context) {
              return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthenticatedState) {
                    return HomePage(uid: authState.uid);
                  } else {
                    return  LoginPage(uid: "");
                  }
                },
              );
            },
          }),
    );
  }
}
