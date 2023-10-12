import 'package:come_along_with_me/const.dart';
import 'package:come_along_with_me/widgets/ContainerButtonWidget.dart';
import 'package:come_along_with_me/widgets/HeaderWidget.dart';
import 'package:come_along_with_me/widgets/RowTextWidget.dart';
import 'package:come_along_with_me/widgets/TextFieldContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
              SizedBox(
                height: 25,
              ),
              HeaderWidget(
                title: "Recuperar contraseña",
              ),
              Divider(thickness: 1),
              SizedBox(
                height: 40,
              ),
              Text(
                "Ingresa tu correo electrónico para recibir el enlace de recuperación de contraseña",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldContainerWidget(
                controller: _emailcontroller,
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                hintText: "email",
              ),
              SizedBox(
                height: 20,
              ),
              ContainerButtonWidget(
  title: "Enviar Email",
  onTap: () {
    final email = _emailcontroller.text.trim();

    FirebaseAuth.instance.sendPasswordResetEmail(email: email)
      .then((_) {
        // Éxito: Correo electrónico de recuperación enviado con éxito.
        // Puedes mostrar un mensaje de éxito o redirigir a otra pantalla.
        _showToast("Correo electrónico de recuperación enviado con éxito.");
      })
      .catchError((error) {
        // Error: No se pudo enviar el correo electrónico de recuperación.
        // Puedes mostrar un mensaje de error al usuario.
        _showToast("Error al enviar el correo electrónico de recuperación: $error");
      });
  },
),
              SizedBox(
                height: 20,
              ),
              RowTextWidget(
                title1: "Recuerdas la contraseña?",
                title2: "  Logeate!!",
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageConst.loginPage, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
}
