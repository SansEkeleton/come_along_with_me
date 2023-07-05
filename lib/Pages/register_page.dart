import 'package:come_along_with_me/Pages/home_page.dart';
import 'package:come_along_with_me/const.dart';
import 'package:come_along_with_me/cubit/auth/cubit/auth_cubit.dart';
import 'package:come_along_with_me/cubit/credential/cubit/credential_cubit.dart';
import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:come_along_with_me/widgets/ContainerButtonWidget.dart';
import 'package:come_along_with_me/widgets/HeaderWidget.dart';
import 'package:come_along_with_me/widgets/RowTextWidget.dart';
import 'package:come_along_with_me/widgets/TextFieldContainer.dart';
import 'package:come_along_with_me/widgets/TextFieldPasswordContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController passwordaAgainController = TextEditingController();

  @override
  void dispose() {
    usernamecontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    passwordaAgainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSucess){
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }

          if (credentialState is CredentialFailure){
            print("Invalid credentials");
          }
        },
        builder: (context, credentialState) {

          if (credentialState is CredentialLoading){
            return CircularProgressIndicator();
          }

          if (CredentialState is CredentialSucess){
            return BlocBuilder<AuthCubit,AuthState>(builder: (context, authState ) {
              if(authState is AuthenticatedState){
                return HomePage(uid: authState.uid,);
              }else{ return _bodyWidget();}
            }
            
            );
          }
          return _bodyWidget();
        },
      ),
    );
  }

  Widget _profileWidget() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Subir foto de perfil",
            style: TextStyle(fontSize: 16, color: Color.fromRGBO(233, 78, 54, 1)),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Column(
          children: [
            SizedBox(height: 30),
            HeaderWidget(
              title: "Registro",
            ),
            Divider(thickness: 1),
            SizedBox(height: 20),
            _profileWidget(),
            SizedBox(height: 20),
            TextFieldContainerWidget(
              controller: usernamecontroller,
              prefixIcon: Icons.person,
              keyboardType: TextInputType.text,
              hintText: "name",
            ),
            SizedBox(height: 10),
            TextFieldContainerWidget(
              controller: emailcontroller,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              hintText: "email",
            ),
            SizedBox(height: 10),
            Divider(
              indent: 120,
              endIndent: 120,
              thickness: 2,
            ),
            SizedBox(height: 10),
            TextFieldPasswordContainerWidget(
              controller: passwordcontroller,
              prefixIcon: Icons.lock,
              keyboardType: TextInputType.text,
              hintText: "password",
            ),
            TextFieldPasswordContainerWidget(
              controller: passwordaAgainController,
              prefixIcon: Icons.lock,
              keyboardType: TextInputType.text,
              hintText: "password (again)",
            ),
            SizedBox(height: 20),
            ContainerButtonWidget(
              title: "Registrar",
              onTap: () {
                _submitSignUp();
              },
            ),
            SizedBox(height: 10),
            Divider(
              indent: 120,
              endIndent: 120,
              thickness: 2,
            ),
            SizedBox(height: 10),
            RowTextWidget(
              mainAxisAlignment: MainAxisAlignment.center,
              title1: "Ya tienes una cuenta?",
              title2: " Logeate!!",
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, PageConst.loginPage, (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitSignUp() {
    if (usernamecontroller.text.isEmpty || emailcontroller.text.isEmpty || passwordcontroller.text.isEmpty) {
      return;
    }

    BlocProvider.of<CredentialCubit>(context).submitSignUp(
      user: UserEntity(
        name: usernamecontroller.text,
        email: emailcontroller.text,
        password: passwordcontroller.text,
        isOnline: false,
        phone: "",
        profileUrl: "",
        status: "",
    
      ),
    );
  }
}