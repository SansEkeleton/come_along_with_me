


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come_along_with_me/cubit/group/group_cubit.dart';
import 'package:come_along_with_me/data/remote_data_source/storage_provider.dart';
import 'package:come_along_with_me/domain/entities/group_entity.dart';
import 'package:come_along_with_me/widgets/TextFieldContainer.dart';
import 'package:come_along_with_me/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class CreatenewGroupPage extends StatefulWidget {
   final String uid;

  const CreatenewGroupPage({Key? key, required this.uid}) : super(key: key);
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreatenewGroupPage> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _numberUsersJoinController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _examTypeController = TextEditingController();
  TextEditingController _passwordAgainController = TextEditingController();
  TextEditingController _numberController = TextEditingController();


  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();


  int _selectGender = -1;
  int _selectExamType = -1;
  bool _isShowPassword=true;

  File? _image;
  String? _profileUrl;

  Future getImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);

          StorageProviderRemoteDataSource.uploadFile(file: _image!).then((value) {

            print("profileUrl");
            setState(() {
              _profileUrl=value;
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

  void dispose() {
    _examTypeController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _passwordController.dispose();
    _numberUsersJoinController.dispose();
    _numberController.dispose();
    _passwordAgainController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text("Create group"),
      ),
      body:_bodyWidget() ,
    );
  }
  Widget _bodyWidget(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 35),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () async{
                getImage();
                //FIXME:
              },
              child: Column(
                children: [
                  Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: profileWidget(image: _image)
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Add Group Image',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 17,
            ),
            TextFieldContainerWidget(
              controller: _groupNameController,
              keyboardType: TextInputType.text,
              hintText: 'group name',
              prefixIcon: Icons.cases_outlined,
            ),
            SizedBox(
              height: 10,
            ),
            TextFieldContainerWidget(
              controller: _numberUsersJoinController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'number of users join group',
              prefixIcon: Icons.format_list_numbered,
            ),
            SizedBox(
              height: 17,
            ),
            Divider(
              thickness: 2,
              indent: 120,
              endIndent: 120,
            ),
            SizedBox(
              height: 17,
            ),

            InkWell(
              onTap: () {
                _submit();
              },
              child: Container(
                alignment: Alignment.center,
                height: 44,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.blue,
                ),
                child: Text(
                  'Create New Group',
                  style: TextStyle(color: Colors.white,fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),

            SizedBox(
              height: 12,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'By clicking Create New Group, you agree to the ',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey),
                  ),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'and ',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey),
                  ),
                  Text(
                    'terms ',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'of use',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  _submit()async {
    if (_image==null){
          Fluttertoast.showToast(
          msg: 'Add profile photo',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );     
      return;
    }
    if (_groupNameController.text.isEmpty) {

       Fluttertoast.showToast(
          msg: 'enter your surname',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );     
      return;
      
    }
    if (_numberUsersJoinController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'enter your email',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
    }

    BlocProvider.of<GroupCubit>(context)
    .getCreateGroup(groupEntity: GroupEntity(
      lastMessage: "",
      uid: widget.uid,
      groupName: _groupNameController.text,
      creationTime: Timestamp.now(),
      groupProfileImage: _profileUrl!,
      joinUsers: "0",
      limitUsers: _numberUsersJoinController.text,
    ));
    Fluttertoast.showToast(
          msg: "${_groupNameController.text} created successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
    _clear();

  }


  void _clear(){
   setState(() {
     _groupNameController.clear();
     _numberUsersJoinController.clear();
     _profileUrl="";
     _image=null;
   });
  }

}