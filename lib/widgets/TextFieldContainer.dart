



import 'package:flutter/material.dart';

class TextFieldContainerWidget extends StatelessWidget{
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final String? hintText;
  final double? borderRadius;
  final Color? color;
  final VoidCallback? iconClickEvent;
  const TextFieldContainerWidget({super.key, this.controller, this.prefixIcon, this.keyboardType, required this.hintText, this.borderRadius=10, this.color, this.iconClickEvent});
  

  @override
  Widget build(BuildContext context) {
    return Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color:color==null? Colors.grey.withOpacity(.1):color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  keyboardType: keyboardType,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    iconColor: Color.fromRGBO(82, 131, 202, 1),
                    border: InputBorder.none,
                    prefixIcon: InkWell(onTap: iconClickEvent   ,child: Icon(prefixIcon)),
                  )
                ),
              );
  }



}