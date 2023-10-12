import 'dart:io';

import 'package:come_along_with_me/data/remote_data_source/storage_provider.dart';
import 'package:come_along_with_me/data/user_model.dart';
import 'package:come_along_with_me/widgets/ContainerButtonWidget.dart';
import 'package:come_along_with_me/widgets/TextFieldContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  File? _image;
  String? _profileUrl;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.value =
        TextEditingValue(text: widget.currentUser.name ?? "");
    _statusController.value =
        TextEditingValue(text: widget.currentUser.status ?? "");
    SharedPreferences.getInstance().then((prefs) {
      if (mounted) {
        setState(() {
          _profileUrl = prefs.getString('profileImageUrl') ?? null;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _statusController.dispose();
  }

  Future getImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          StorageProviderRemoteDataSource.uploadFile(file: _image!)
              .then((value) {
            print("profileUrl");
            setState(() {
              _profileUrl = value;
            });
          });
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print("error $e");
    }
  }

  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          // Access user data with null checks
          final currentUser = userState.users.firstWhere(
            (user) => user.uid == widget.currentUser.uid,
            orElse: () =>
                UserModel(), // Change this to the appropriate user model
          );
          _nameController.text = currentUser.name ?? "";
          _emailController.text = currentUser.email ?? "";
          _statusController.text = currentUser.status ?? "";

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      height: 62,
                      width: 62,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(62),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(62),
                        child: _profileUrl != null
                            ? Image.network(_profileUrl!, fit: BoxFit.cover)
                            : Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Remove profile photo",
                    style: TextStyle(
                      color: Color.fromRGBO(227, 78, 54, 1.000),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 40),
                  TextFieldContainerWidget(
                    keyboardType: TextInputType.name,
                    hintText: "name",
                    controller: _nameController,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: 10),
                  TextFieldContainerWidget(
                    hintText: "email",
                    prefixIcon: Icons.email,
                    controller: _emailController,
                  ),
                  SizedBox(height: 10),
                  TextFieldContainerWidget(
                    hintText: "Status",
                    controller: _statusController,
                    prefixIcon: Icons.interests,
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 1.50),
                  SizedBox(height: 10),
                  ContainerButtonWidget(
                    title: "Update Profile",
                    onTap: () {
                      _updateUserProfile();
                    },
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _updateUserProfile() async {
    BlocProvider.of<UserCubit>(context).updateUsers(
      user: UserEntity(
        uid: widget.currentUser.uid,
        name: _nameController.text,
        email: _emailController.text,
        status: _statusController.text,
        profileUrl: _profileUrl,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("profileImageUrl", _profileUrl!);
  }
}
