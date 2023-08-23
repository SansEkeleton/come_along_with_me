




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come_along_with_me/Pages/chat_room_page.dart';
import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:come_along_with_me/widgets/single_item_user_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UsersPage extends StatelessWidget {
  final List<UserEntity> users;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userMap ;


String chatRoomId(String user1, String user2){
  if (user1.toLowerCase().compareTo(user2.toLowerCase()) < 0) {
    return "$user1\_$user2";
  } else {
    return "$user2\_$user1";
  }
}
  UsersPage({super.key, required this.users}){ getUserData();}

void getUserData() async {
    await _firestore.collection("users").doc(_auth.currentUser!.uid).get().then((value) {
      userMap = value.data();
    });
  }

  @override
  Widget build(BuildContext context) {
  return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(itemCount: users.length,itemBuilder: ((context, index) {
              return SingleItemUserWidget(
                profileUser: users[index],
                onTap: () {
  if (_auth.currentUser != null) {
    String roomId = chatRoomId(_auth.currentUser!.displayName!, users[index].name!);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChatRoom(chatRoomId: roomId, userMap: userMap!,),
    ));
  }
},
                
                );
            })),
          )
        ],
      ),
    );
  }
}