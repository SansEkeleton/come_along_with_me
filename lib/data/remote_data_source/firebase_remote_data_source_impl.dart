import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come_along_with_me/data/group_model.dart';
import 'package:come_along_with_me/data/my_chat_model.dart';
import 'package:come_along_with_me/data/remote_data_source/firebase_remote_data_source.dart';
import 'package:come_along_with_me/data/text_message_model.dart';
import 'package:come_along_with_me/data/user_model.dart';
import 'package:come_along_with_me/domain/entities/engage_user_entity.dart';
import 'package:come_along_with_me/domain/entities/group_entity.dart';
import 'package:come_along_with_me/domain/entities/my_chat_entity.dart';
import 'package:come_along_with_me/domain/entities/text_message_entity.dart';
import 'package:come_along_with_me/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  FirebaseRemoteDataSourceImpl({
    required this.fireStore,
    required this.auth,
    required this.googleSignIn,
  });

  get context => null;

  @override
  Future<void> forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection("users");

    try {
      final uid = await getCurrentUserId();

      final userDoc = await userCollection.doc(uid).get();
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        email: user.email,
        profileUrl: user.profileUrl,
        status: user.status,
        phone: user.phone,
        password: user.password,
        isOnline: user.isOnline,
      ).toDocument();

      if (!userDoc.exists) {
        await userCollection.doc(uid).set(newUser);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<String> getCurrentUserId() async {
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    } else {
      // Handle the case when the current user is null.
      // You can return a default value or throw a custom exception.
      throw Exception("Current user is null");
    }
  }

  @override
  Future<void> getUpdateUser(UserEntity user) async {
 
    Map<String,dynamic> userInformation = {};
    final userCollection = fireStore.collection("users");

    if (user.profileUrl != null && user.profileUrl != " ") {
      userInformation['profileUrl'] = user.profileUrl;
    }

    if (user.name != null && user.name != " ") {
      userInformation['name'] = user.name;
    }
    if (user.status != null && user.status != " ") {
      userInformation['status'] = user.status;
    }
    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = fireStore.collection("users");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());

  }

  @override
  Future<void> googleAuth() async {
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await account!.authentication;

final authCredrential =  GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final userInformation = (await auth.signInWithCredential(authCredrential)).user;
    getCreateCurrentUser(UserEntity(
      uid: userInformation!.uid,
      name: userInformation.displayName,
      email: userInformation.email,
      profileUrl: userInformation.photoURL,
      status: "Hey there, I am using Come Along With Me",
      phone: userInformation.phoneNumber,
      isOnline: true,
    ));
    
  }



  @override
  Future<bool> isSignIn() async {
    final user = auth.currentUser;
    return user != null;
  }

  @override
  Future<void> signIn(UserEntity user) async {
    final email = user.email;
    final password = user.password;

    if (email != null && password != null) {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
            msg: 'Wrong password',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else if (e.code == 'user-not-found') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Incorrect email'),
                content: Text('The email address entered is incorrect.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Sign in failed with error: ${e.code}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> signUp(UserEntity user) async {
    final email = user.email;
    final password = user.password;

    try {
      if (email != null && password != null) {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: 'Wrong password',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Incorrect email'),
              content: Text('The email address entered is incorrect.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Sign in failed with error: ${e.code}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Future<void> addToMyChat(MyChatEntity myChatEntity) async {
    final myChatRef = fireStore
        .collection("users")
        .doc(myChatEntity.senderUID)
        .collection("myChat");
    final otherChatRef = fireStore
        .collection("users")
        .doc(myChatEntity.recipientUID)
        .collection("myChat");

    final myNewChatCurrentUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.senderName,
      time: myChatEntity.time,
      recipientName: myChatEntity.recipientName,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      recipientUID: myChatEntity.recipientUID,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
      senderUID: myChatEntity.senderUID,
      profileUrl: myChatEntity.profileUrl,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      recentTextMessage: myChatEntity.recentTextMessage,
      subjectName: myChatEntity.subjectName,
    ).toDocument();
    final myNewChatOtherUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.recipientName,
      time: myChatEntity.time,
      recipientName: myChatEntity.senderName,
      recipientPhoneNumber: myChatEntity.senderPhoneNumber,
      recipientUID: myChatEntity.senderUID,
      senderPhoneNumber: myChatEntity.recipientPhoneNumber,
      senderUID: myChatEntity.recipientUID,
      profileUrl: myChatEntity.profileUrl,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      recentTextMessage: myChatEntity.recentTextMessage,
      subjectName: myChatEntity.subjectName,
    ).toDocument();
    myChatRef.doc(myChatEntity.recipientUID).get().then((myChatDoc) {
      if (!myChatDoc.exists) {
        myChatRef.doc(myChatEntity.recipientUID).set(myNewChatCurrentUser);
        otherChatRef.doc(myChatEntity.senderUID).set(myNewChatOtherUser);
        return;
      } else {
        print("update");
        myChatRef.doc(myChatEntity.recipientUID).update(myNewChatCurrentUser);
        otherChatRef.doc(myChatEntity.senderUID).set(myNewChatOtherUser);

        return;
      }
    });
  }

  @override
  Future<void> createNewGroup(
      MyChatEntity myChatEntity, List<String> selectUserList) async {
    print("createNewGroup ${myChatEntity.channelId}");
    print(myChatEntity.senderUID);
    await _createGroup(myChatEntity, selectUserList);
   
    return;
  }

  _createGroup(MyChatEntity myChatEntity, List<String> selectUserList) async {
    final myNewChatCurrentUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.senderName,
      time: myChatEntity.time,
      recipientName: myChatEntity.recipientName,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      recipientUID: myChatEntity.recipientUID,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
      senderUID: myChatEntity.senderUID,
      profileUrl: myChatEntity.profileUrl,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      recentTextMessage: myChatEntity.recentTextMessage,
      subjectName: myChatEntity.subjectName,
    ).toDocument();
    print("sender Id ${myChatEntity.senderUID}");
    await fireStore
        .collection("users")
        .doc(myChatEntity.senderUID)
        .collection("myChat")
        .doc(myChatEntity.channelId)
        .set(myNewChatCurrentUser)
        .then((value) {
      print("data created");
    }).catchError((error) {
      print("dataError $error");
    });
  }

  @override
  Future<String> createOneToOneChatChannel(
      EngageUserEntity engageUserEntity) async {
    //User Collection Reference
    final userCollectionRef = fireStore.collection("users");

    final oneToOneChatChannelRef = fireStore.collection("OneToOneChatChannel");
    //ChatChannelMap
    userCollectionRef
        .doc(engageUserEntity.uid)
        .collection("chatChannel")
        .doc(engageUserEntity.otherUid)
        .get()
        .then((chatChannelDoc) {
      //Chat Channel exists
      if (chatChannelDoc.exists) {
        return chatChannelDoc.get('channelId');
      }

      final chatChannelId = oneToOneChatChannelRef.doc().id;

      var channel = {'channelId': chatChannelId};

      oneToOneChatChannelRef.doc(chatChannelId).set(channel);

      //currentUser
      userCollectionRef
          .doc(engageUserEntity.uid)
          .collection('chatChannel')
          .doc(engageUserEntity.otherUid)
          .set(channel);

      //otherUser
      userCollectionRef
          .doc(engageUserEntity.otherUid)
          .collection('chatChannel')
          .doc(engageUserEntity.uid)
          .set(channel);

      return chatChannelId;
    });
    return Future.value("");
  }

  @override
  Future<String> getChannelId(EngageUserEntity engageUserEntity) {
    final userCollectionRef = fireStore.collection("users");
    print(
        "uid ${engageUserEntity.uid} - otherUid ${engageUserEntity.otherUid}");
    return userCollectionRef
        .doc(engageUserEntity.uid)
        .collection('chatChannel')
        .doc(engageUserEntity.otherUid)
        .get()
        .then((chatChannelId) {
      if (chatChannelId.exists) {
        return chatChannelId.get('channelId');
      } else {
        // ignore: null_argument_to_non_null_type
        return Future.value(null);
      }
    });
  }

  @override
  Future<void> getCreateGroup(GroupEntity groupEntity) async {
    final groupCollection = fireStore.collection("groups");

    final groupId = groupCollection.doc().id;

    groupCollection.doc(groupId).get().then((groupDoc) {
      final newGroup = GroupModel(
        groupId: groupId,
        limitUsers: groupEntity.limitUsers,
        joinUsers: groupEntity.joinUsers,
        creationTime: groupEntity.creationTime,
        groupName: groupEntity.groupName,
        lastMessage: groupEntity.lastMessage,
      ).toDocument();

      if (!groupDoc.exists) {
        groupCollection.doc(groupId).set(newGroup);

        return;
      }
      return;
    }).catchError((error) {
      print(error);
    });
  }

  @override
   Stream<List<GroupEntity>> getGroups() {
    final groupCollection = fireStore.collection("groups");
    return groupCollection.orderBy("creationTime",descending: true).snapshots().map(
        (querySnapshot) =>
            querySnapshot.docs.map((e) => GroupModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    final oneToOneChatChannelRef = fireStore.collection("groupChatChannel");
    final messagesRef =
        oneToOneChatChannelRef.doc(channelId).collection("messages");

    return messagesRef.orderBy('time').snapshots().map((querySnap) => querySnap
        .docs
        .map((queryDoc) => TextMessageModel.fromSnapshot(queryDoc))
        .toList());
  }

  @override
   Stream<List<MyChatEntity>> getMyChat(String uid) {
    final myChatRef =
        fireStore.collection("users").doc(uid).collection("myChat");

    return myChatRef.orderBy('time', descending: true).snapshots().map(
      (querySnapshot) {
        return querySnapshot.docs.map((queryDocumentSnapshot) {
          return MyChatModel.fromSnapshot(queryDocumentSnapshot);
        }).toList();
      },
    );
  }

  @override
  Future<void> joinGroup(GroupEntity groupEntity) async {
    final groupChatChannelCollection = fireStore.collection("groupChatChannel");

    groupChatChannelCollection
        .doc(groupEntity.groupId)
        .get()
        .then((groupChannel) {
      Map<String, dynamic> groupMap = {"groupChannelId": groupEntity.groupId};
      if (!groupChannel.exists) {
        groupChatChannelCollection.doc(groupEntity.groupId).set(groupMap);
        return;
      }
      return;
    });
  }

  @override
   Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId) async {
    final messagesRef = fireStore
        .collection("groupChatChannel")
        .doc(channelId)
        .collection("messages");

    //MessageId
    final messageId = messagesRef.doc().id;

    final newMessage = TextMessageModel(
      content: textMessageEntity.content,
      messageId: messageId,
      receiverName: textMessageEntity.receiverName,
      recipientId: textMessageEntity.recipientId,
      senderId: textMessageEntity.senderId,
      senderName: textMessageEntity.senderName,
      time: textMessageEntity.time,
      type: textMessageEntity.type,
    ).toDocument();

    messagesRef.doc(messageId).set(newMessage);
  }


  @override
  Future<void> updateGroup(GroupEntity groupEntity) async {
    Map<String, dynamic> groupInformation = Map();

    final userCollection = fireStore.collection("groups");

    // ignore: unnecessary_null_comparison
    if (groupEntity.groupProfileImage != null &&
        groupEntity.groupProfileImage != "") {
      groupInformation['groupProfileImage'] = groupEntity.groupProfileImage;
    }
    // ignore: unnecessary_null_comparison
    if (groupEntity.groupName != null && groupEntity.groupName != "") {
      groupInformation["groupName"] = groupEntity.groupName;
    }
    // ignore: unnecessary_null_comparison
    if (groupEntity.lastMessage != null && groupEntity.lastMessage != "") {
      groupInformation["lastMessage"] = groupEntity.lastMessage;
    }
    if (groupEntity.creationTime != null) {
      groupInformation["creationTime"] = groupEntity.creationTime;
    }

    userCollection.doc(groupEntity.groupId).update(groupInformation);
  }
}
