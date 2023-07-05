

import 'package:come_along_with_me/Pages/home_page.dart';
import 'package:come_along_with_me/const.dart';
import 'package:come_along_with_me/cubit/auth/cubit/auth_cubit.dart';
import 'package:come_along_with_me/cubit/credential/cubit/credential_cubit.dart';
import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:come_along_with_me/widgets/ContainerButtonWidget.dart';
import 'package:come_along_with_me/widgets/Logo.dart';
import 'package:come_along_with_me/widgets/RowTextWidget.dart';
import 'package:come_along_with_me/widgets/TextFieldContainer.dart';
import 'package:come_along_with_me/widgets/TextFieldPasswordContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
TextEditingController _emailcontroller = TextEditingController();
TextEditingController _passwordcontroller = TextEditingController();


void dispose() {
  _emailcontroller.dispose();
  _passwordcontroller.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, CredentialState) {
          
          if(CredentialState is CredentialSucess){
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }

          if(CredentialState is CredentialFailure){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Error"),
            ));
          }

        },
        builder: (context, CredentialState) {

          if(CredentialState is CredentialLoading){
            return Center(child: CircularProgressIndicator());
          }

          if(CredentialState is CredentialSucess){
            return BlocBuilder<AuthCubit, AuthState>(builder: (context, authState){
              if(authState is AuthenticatedState){
                return HomePage(uid: authState.uid);
              }else{
                return _bodyWidget();
              }
            });
            }
          
          return _bodyWidget();
        },
      ),
    );
  }
  
  Widget _forgotPasswordWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [ 
        Text(""),
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, PageConst.forgotPasswordPage);
          },
          child: Text("forgot password?", 
          style: 
          TextStyle(color: Color.fromRGBO(233, 78, 54, 1),
            fontSize: 16,
            fontWeight: FontWeight.w700  ),
            ),
        )]
    );
  }
  
 
 
    Widget  _rowGoogleWiget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: (){
          //GOOGLE LOGIN
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.g_mobiledata_rounded, color: Colors.white,),
        ),
      )
    ],
  );
 }
 
  _bodyWidget() {
    return  SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          child: Column(
            children: [
              logo(),
              TextFieldContainerWidget(
                keyboardType: TextInputType.emailAddress,
                controller: _emailcontroller,
                prefixIcon: Icons.email,
                hintText: "email",
              ),
              SizedBox(height: 10,),
              TextFieldPasswordContainerWidget(
                keyboardType: TextInputType.emailAddress ,
                controller: _passwordcontroller,
                prefixIcon: Icons.lock,
                hintText: "password",
              ),
              SizedBox(height: 10,),
              _forgotPasswordWidget(),
              SizedBox(height: 20,),
              ContainerButtonWidget(
                title: "Ingresar",
                onTap: _submitSignIn,
              ),
              SizedBox(height: 10,),
              RowTextWidget(title1: "No tienes una cuenta?", title2: "  Registrate!!" , onTap: () {Navigator.pushNamed(context, PageConst.registerPage);},),
              SizedBox(height: 20,),
              _rowGoogleWiget(),
            ],
            
            
          ),
        ),
      );
  }

  void _submitSignIn (){

    if (_emailcontroller.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email is empty"),
      ));
      return;
    }

    if (_passwordcontroller.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password is empty"),
      ));
      return;
    }

    BlocProvider.of<CredentialCubit>(context).submitSignIn(user: UserEntity(
      email: _emailcontroller.text,
      password: _passwordcontroller.text,


    ));
  }


}