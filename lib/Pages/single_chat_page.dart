import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come_along_with_me/Pages/Gps_tracking_page.dart';
import 'package:come_along_with_me/cubit/chat/chat_cubit.dart';
import 'package:come_along_with_me/cubit/group/group_cubit.dart';
import 'package:come_along_with_me/domain/entities/group_entity.dart';
import 'package:come_along_with_me/domain/entities/single_chat_entity.dart';
import 'package:come_along_with_me/domain/entities/text_message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SingleChatPage extends StatefulWidget {
  final SingleChatEntity singleChatEntity;
  const SingleChatPage({Key? key,required this.singleChatEntity})
      : super(key: key);

  @override
  _SingleChatPageState createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  String messageContent = "";
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    _messageController.addListener(() {
      setState(() {});
    });
    BlocProvider.of<ChatCubit>(context).getMessages(channelId: widget.singleChatEntity.groupId);
    //FIXME: call get all messages
    super.initState();
  }
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  check(){

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: appBarMain(context),
      appBar: AppBar(
        title: Text("${widget.singleChatEntity.groupName}"),
      ),
      body: BlocBuilder<ChatCubit,ChatState>(
        builder: (index,chatState){

          if (chatState is ChatLoaded){
            return Column(
              children: [
                _messagesListWidget(chatState),
                _sendMessageTextField(),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _sendMessageTextField() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 4, right: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      offset: Offset(0.0, 0.50),
                      spreadRadius: 1,
                      blurRadius: 1,
                    )
                  ]),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.insert_emoticon,
                    color: Colors.grey[500],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 60),
                        child: Scrollbar(
                          child: TextField(
                            style: TextStyle(fontSize: 14),
                            controller: _messageController,
                            maxLines: null,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrackingPage(
                                    onSendLocation:
                                        (Map<String, dynamic> message) {},
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.location_on_outlined),
                          ),
                      SizedBox(
                        width: 10,
                      ),
                      _messageController.text.isEmpty
                          ? Icon(
                        Icons.camera_alt,
                        color: Colors.grey[500],
                      )
                          : Text(""),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              if (_messageController.text.isEmpty) {
                //TODO:send voice message
              } else {
                print(_messageController.text);
                BlocProvider.of<ChatCubit>(context)
                .sendTextMessage(textMessageEntity: TextMessageEntity(
                  time: Timestamp.now(),
                  senderId: widget.singleChatEntity.uid,
                  content: _messageController.text,
                  senderName: widget.singleChatEntity.username,
                  type: "TEXT"
                ), channelId: widget.singleChatEntity.groupId);
                BlocProvider.of<GroupCubit>(context).updateGroup(groupEntity: GroupEntity(
                  groupId: widget.singleChatEntity.groupId,
                  lastMessage: _messageController.text,
                  creationTime: Timestamp.now(),
                ));
                setState(() {
                  _messageController.clear();
                });
              }
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Icon(
                _messageController.text.isEmpty ? Icons.mic : Icons
                    .send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _messagesListWidget(ChatLoaded messages) {
  Timer(Duration(milliseconds: 100), () {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInQuad,
    );
  });
  return Expanded(
    child: ListView.builder(
      controller: _scrollController,
      itemCount: messages.messages.length,
      itemBuilder: (_, index) {
        final message = messages.messages[index];

        return _messageLayout(
          color: Colors.white,
          name: message.senderName, // Usar el nombre del remitente desde el mensaje
          alignName: TextAlign.end,
          time: DateFormat('hh:mm a').format(message.time!.toDate()),
          align: TextAlign.left,
          boxAlign: CrossAxisAlignment.start,
          crossAlign: CrossAxisAlignment.start,
          nip: BubbleNip.leftTop,
          text: message.content,
        );
      },
    ),
  );
}

Widget _messageLayout({
  text,
  time,
  color,
  align,
  boxAlign,
  nip,
  crossAlign,
  String? name,
  alignName,
}) {
  // Utiliza el ID del remitente actual en lugar de widget.singleChatEntity.uid
  final isCurrentUser = name == "Me"; // Aquí debes verificar el nombre del remitente

  return Column(
    crossAxisAlignment: crossAlign,
    children: [
      ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.90,
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(3),
          child: Bubble(
            color: isCurrentUser ? Colors.lightGreen[400] : Colors.white,
            nip: nip,
            child: Column(
              crossAxisAlignment: crossAlign,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isCurrentUser ? "Me" : name ?? "", // Mostrar "Me" o el nombre del remitente
                  textAlign: alignName,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  text,
                  textAlign: align,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  time,
                  textAlign: align,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(
                      .4,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ],
  );
}



  /*Widget _messageLayout({
    text,
    time,
    color,
    align,
    boxAlign,
    nip,
    crossAlign,
    String? name,
    alignName,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$name",
                    textAlign: alignName,
                    style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                  ),
                  Text(
                    text,
                    textAlign: align,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }*/


}