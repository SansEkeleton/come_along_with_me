import 'package:come_along_with_me/widgets/ContainerButtonWidget.dart';
import 'package:come_along_with_me/widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/user/cubit/user_cubit.dart';
import '../domain/entities/user_entity.dart';

class ProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const ProfilePage({super.key, required this.currentUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.value = TextEditingValue(text: widget.currentUser.name!);
    _statusController.value = TextEditingValue(text: widget.currentUser.status!);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _statusController.dispose();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
     child : Container(
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
              _updateUserProfile();
            })
      ]),
    ));
  }

  void _updateUserProfile() {

    BlocProvider.of<UserCubit>(context).updateUsers(
        user: UserEntity(
          uid: widget.currentUser.uid,
            name: _nameController.text,
            email: _emailController.text,
            status: _statusController.text));
  }
}
