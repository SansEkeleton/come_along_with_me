

import 'package:come_along_with_me/Pages/create_new_group_page.dart';
import 'package:come_along_with_me/Pages/forgot_password.dart';
import 'package:come_along_with_me/Pages/login_page.dart';
import 'package:come_along_with_me/Pages/register_page.dart';
import 'package:come_along_with_me/Pages/single_chat_page.dart';
import 'package:come_along_with_me/const.dart';
import 'package:flutter/material.dart';

class Routes{

  static Route<dynamic> route(RouteSettings settings){




    switch(settings.name){

      case PageConst.forgotPasswordPage :{

          return materialBuilder(widget: forgotPasswordPage());

      }

      case PageConst.loginPage :{

          return materialBuilder(widget: LoginPage());

      }

        case PageConst.registerPage :{

          return materialBuilder(widget: RegisterPage());

      }

      case PageConst.createnewGroupPage :{

          return materialBuilder(widget: CreatenewGroupPage());

      }

      case PageConst.singleChatPage :{

          return materialBuilder(widget: SingleChatPage());

      }

      case "/": {
          
          return materialBuilder(widget: LoginPage());
      }

      default: return materialBuilder(widget: ErrorPage());
    }
  }
}

class ErrorPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error Page"),
        ),
        body: Center(
          child: Text("Error Page"),
        ),
    );
  }
}



MaterialPageRoute materialBuilder({required Widget widget}){

 return MaterialPageRoute(builder: (_) => widget); 
}