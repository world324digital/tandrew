// ignore_for_file: sized_box_for_whitespace

import 'dart:async';

import 'package:Fuligo/model/chat_model.dart';
import 'package:Fuligo/model/user_model.dart';
import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/utils/font_style.dart';
import 'package:Fuligo/widgets/circleimage.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';

// ignore: must_be_immutable
class ChatRoom extends StatefulWidget {
  String docId;
  ChatRoom({Key? key, required this.docId}) : super(key: key);

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatMessageModel {
  String image;
  String comment;
  ChatMessageModel({
    this.image = "",
    this.comment = "",
  });
}

class ChatRoomState extends State<ChatRoom> {
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  late FocusNode myFocusNode;

  bool loading = true;
  final Stream<QuerySnapshot> chatStream =
      FirebaseFirestore.instance.collection('order').snapshots();

  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  Future<void> addChatMessage() async {
    List chatList = [];
    CollectionReference order = FirebaseFirestore.instance.collection('order');

    if (textEditingController.text.trim().isNotEmpty) {
      ChatModel _chat = ChatModel(
        author: "user",
        message: textEditingController.text.trim(),
      );
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('order')
          .doc(widget.docId)
          .get();
      try {
        chatList = snapshot['chatMessages'];
      } catch (e) {
        chatList = [];
      }

      chatList.add(_chat.toJson());

      order
          .doc(widget.docId)
          .set({'chatMessages': chatList}, SetOptions(merge: true))
          .then((value) => print("Chat Added"))
          .catchError((error) => print("Failed to add user: $error"));
      myFocusNode.requestFocus();
      setState(() {
        textEditingController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    UserModel userInfo = AuthProvider.of(context).userModel;

    return Container(
      decoration: bgDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: chatHeaderColor.withOpacity(0.4),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientFrom, chatHeaderColor]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: mq.width,
                    decoration: const BoxDecoration(
                      color: chatHeaderColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 0, top: 30),
                          child: Text(
                            userInfo.username["first"].toString(),
                            style: font_18_white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 20, top: 30),
                          child: CircleImage(
                              context, userInfo.avatar, 40, 40, "chat"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: chatStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          DocumentSnapshot document = snapshot.data!.docs
                              .where((element) => element.id == widget.docId)
                              .first;
                          try {
                            List chatlist = document["chatMessages"];
                            Timer(
                                const Duration(milliseconds: 300),
                                () => _controller.jumpTo(
                                    _controller.position.maxScrollExtent));

                            return ListView.builder(
                              controller: _controller,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: chatlist.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment:
                                      chatlist[index]["author"] == "user"
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: mq.width * 0.65,
                                      padding: const EdgeInsets.all(15),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                          color: chatMessageColor,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Text(
                                          chatlist[index]['message'].toString(),
                                          style: font_14_white),
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: mq.height * 0.2,
                                ),
                                const Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white30),
                                ),
                              ],
                            );
                          }
                        }),
                  ),
                  buildMessageTextField(),
                ],
              ),
              SecondaryButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessageTextField() {
    var mq = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(color: chatHeaderColor),
      child: Container(
        height: 70.0,
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: mq.width * 0.7,
              decoration: BoxDecoration(
                color: chatInputColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                focusNode: myFocusNode,
                onTap: () {
                  Timer(
                      const Duration(milliseconds: 300),
                      () => _controller
                          .jumpTo(_controller.position.maxScrollExtent));
                },
                controller: textEditingController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white54,
                  ),
                ),
                textInputAction: TextInputAction.send,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
                onSubmitted: (_) {
                  addChatMessage();
                },
              ),
            ),
            Container(
              width: mq.width * 0.2,
              child: InkWell(
                onTap: addChatMessage,
                child: const CircleAvatar(
                  backgroundColor: bgColor,
                  radius: 25,
                  child: Icon(Icons.navigate_next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
