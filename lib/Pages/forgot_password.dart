



import 'package:come_along_with_me/const.dart';
import 'package:come_along_with_me/widgets/ContainerButtonWidget.dart';
import 'package:come_along_with_me/widgets/HeaderWidget.dart';
import 'package:come_along_with_me/widgets/RowTextWidget.dart';
import 'package:come_along_with_me/widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';

class forgotPasswordPage extends StatefulWidget {

  const forgotPasswordPage({super.key});

  @override
  State<forgotPasswordPage> createState() => _forgotPasswordPageState();
}

class _forgotPasswordPageState extends State<forgotPasswordPage> {


   TextEditingController _emailcontroller = TextEditingController();

  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[40],
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 32),
          child: Column(
            children: [
              SizedBox(height: 25,),
              HeaderWidget(title: "Recuperar contraseña",),
              Divider(thickness: 1),
              SizedBox(height: 40,),
              Text("Ingresa tu correo electrónico para recibir el enlace de recuperación de contraseña", style: TextStyle(fontSize: 16, color: Colors.grey),),
              SizedBox(height: 20,),
              TextFieldContainerWidget(
                controller: _emailcontroller,
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                hintText: "email",
              ),
              SizedBox(height: 20,),
              ContainerButtonWidget(title: "Enviar Email", onTap: (){print("xd");},),
              SizedBox(height: 20,),
              RowTextWidget(title1: "Recuerdas la contraseña?", title2: "  Logeate!!", onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, PageConst.loginPage, (route) => false);
              },),
              
            ],
          ),
        ),
      ),
    );
  }
}
