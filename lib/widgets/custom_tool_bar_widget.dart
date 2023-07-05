



import 'package:flutter/material.dart';


typedef ToolBarIndexController = Function(int index);
class CustomToolBarWidget extends StatelessWidget {
  final ToolBarIndexController toolBarIndexController;
  final int? pageIndex;
  const CustomToolBarWidget({super.key, required this.toolBarIndexController, this.pageIndex=0});





  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color:Color.fromRGBO(82, 131, 202, 1)
      ),
      child: Row(
        children: [
          Expanded(
            child: ToolBarItem(onTap: () {
              toolBarIndexController(0);
            }, title: "Groups", 
            borderColor:pageIndex==0?Colors.white:Colors.transparent, 
            textColor: pageIndex==0?Colors.white:Colors.black),
          ),
          
          Expanded(
            child: ToolBarItem(onTap: () {
              toolBarIndexController(1);
            }, title: "Users",  borderColor:pageIndex==1?Colors.white:Colors.transparent, 
            textColor: pageIndex==1?Colors.white:Colors.black),
          ),

          Expanded(
            child: ToolBarItem(onTap: () {
              toolBarIndexController(2);
            }, title: "Profile", borderColor:pageIndex==2?Colors.white:Colors.transparent, 
            textColor: pageIndex==2?Colors.white:Colors.black),
          )
          
        ],
      )
    );
  }
}

class ToolBarItem extends StatelessWidget {
  final String? title;
  final Color? textColor;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;
  const ToolBarItem({super.key,  this.title,  this.textColor, this.borderWidth=3.0, this.onTap, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border( bottom: BorderSide(color: borderColor!, width: borderWidth!))
        ),
        child: Text(title!, style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),)
      ),
    );
  }
}