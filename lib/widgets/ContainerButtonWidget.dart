



import 'package:flutter/material.dart';

class ContainerButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const ContainerButtonWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
                  alignment: Alignment.center,
                  height: 44,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(82, 131, 202, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("$title",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),)
                  ),
    );
  }
}