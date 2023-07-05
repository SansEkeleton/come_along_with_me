




import 'package:flutter/material.dart';

class RowTextWidget extends StatelessWidget {
  final String title1;
  final String title2;
  final VoidCallback? onTap;
  final MainAxisAlignment? mainAxisAlignment;
  const RowTextWidget({super.key, required this.title1, required this.title2, this.onTap, this.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {
    return _rowTextWidget();
  }



  Widget _rowTextWidget() {
  return Row(
    mainAxisAlignment: mainAxisAlignment== null?MainAxisAlignment.start: mainAxisAlignment!,
    children: [
      Text("$title1"),
      InkWell(onTap: onTap,   child: Text("$title2", style: TextStyle(color: Color.fromRGBO(233, 78, 54, 1)),))
    ],
  );
 }
}