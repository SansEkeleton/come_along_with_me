


import 'package:flutter/material.dart';

class TextFieldPasswordContainerWidget extends StatefulWidget{
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final String? hintText;
  const TextFieldPasswordContainerWidget({super.key, this.controller, this.prefixIcon, this.keyboardType, this.hintText,});

  @override
  State<TextFieldPasswordContainerWidget> createState() => _TextFieldPasswordContainerWidgetState();
}

class _TextFieldPasswordContainerWidgetState extends State<TextFieldPasswordContainerWidget> {


bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  obscureText: isObscureText,
                  keyboardType: widget.keyboardType,
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    iconColor: Color.fromRGBO(82, 131, 202, 1),
                    border: InputBorder.none,
                    suffixIcon: InkWell(onTap: (){setState(() {
                        isObscureText=!isObscureText;
                    });}  ,child: Icon(isObscureText==true?Icons.panorama_fish_eye:Icons.remove_red_eye)),
                    prefixIcon: Icon(widget.prefixIcon),
                  )
                ),
              );
  }
}