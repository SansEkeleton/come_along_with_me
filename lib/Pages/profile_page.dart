import 'package:come_along_with_me/widgets/ContainerButtonWidget.dart';
import 'package:come_along_with_me/widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _statusController.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Column(children: [
        Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(62),
          ),
          child: Text(""),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Remove profile photo",
          style: TextStyle(
              color: Color.fromRGBO(227, 78, 54, 1.000),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 40,
        ),
        TextFieldContainerWidget(
            keyboardType: TextInputType.name,
            hintText: "name",
            controller: _nameController,
            prefixIcon: Icons.person),
        SizedBox(
          height: 10,
        ),
        TextFieldContainerWidget(
            hintText: "email",
            prefixIcon: Icons.email,
            controller: _emailController),
        SizedBox(
          height: 10,
        ),
        TextFieldContainerWidget(
            hintText: "Status",
            controller: _statusController,
            prefixIcon: Icons.interests),
        SizedBox(
          height: 10,
        ),
        Divider(thickness: 1.50),
        SizedBox(
          height: 10,
        ),
        ContainerButtonWidget(
            title: "Update Profile",
            onTap: () {
              print("updating profile");
            })
      ]),
    );
  }

  void _updateUserProfile() {}
}
