




import 'package:come_along_with_me/widgets/single_item_user_widget.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
   return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(itemCount: 10,itemBuilder: ((context, index) {
              return SingleItemUserWidget(onTap: (){},);
            })),
          )
        ],
      ),
    );
  }
}