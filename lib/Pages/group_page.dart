




import 'package:come_along_with_me/const.dart';
import 'package:come_along_with_me/widgets/single_item_group_widget.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){ Navigator.pushNamed(context, PageConst.createnewGroupPage);},
        child: Icon(Icons.group_add),
        ),
      body: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(itemCount: 10,itemBuilder: ((context, index) {
              return SingleItemGroupWidget(onTap: (){
                Navigator.pushNamed(context, PageConst.singleChatPage);
              },);
            })),
          )
        ],
      ),
    ),
    );
    
  }
}