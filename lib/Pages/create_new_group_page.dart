


import 'package:come_along_with_me/widgets/ContainerButtonWidget.dart';
import 'package:come_along_with_me/widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';

class CreatenewGroupPage extends StatefulWidget {
  const CreatenewGroupPage({super.key});

  @override
  State<CreatenewGroupPage> createState() => _CreateNewGroupPageState();
}

class _CreateNewGroupPageState extends State<CreatenewGroupPage> {

TextEditingController _GroupNameController = TextEditingController();
void dispose() {
    super.dispose();
    _GroupNameController.dispose();
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Group"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
            children: [
            SizedBox(height: 100,),
              Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(62),
              ),
              child: Text(""),),
            SizedBox(height: 15,),
            Text("Add Group image", style: TextStyle(color: Color.fromRGBO(227, 78, 54, 1.000), fontWeight: FontWeight.w500 ),),
            SizedBox(height: 40,),
            TextFieldContainerWidget (hintText: "name", controller: _GroupNameController, prefixIcon: Icons.person), 
            SizedBox(height: 10, ),
            Divider(thickness: 1.50, indent: 100 ,endIndent: 100),
            SizedBox(height: 10,),
            ContainerButtonWidget(title: "Create New Group", onTap: (){print("creating group");})
            ]
        ),
      ),
    );
  }
}