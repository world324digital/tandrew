import 'package:Fuligo/model/chat_model.dart';
import 'package:Fuligo/screens/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'utils/common_colors.dart';
import 'utils/font_style.dart';

class Test extends StatelessWidget {
  final String documentId;

  Test(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('order');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        print("++++++++++++++++++++++");
        print(snapshot.data!.data());
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // print("============");
          // print(data["chatMessages"]);
          // ChatModel aaa = ChatModel.fromJson(data);
          List test = data["chatMessages"];

          List<Widget> widgets = [];
          test.forEach((element) {
            print(element['message']);
            widgets.add(ListTile(
              title: Text(element['message'] ?? "Not message"),
            ));
          });

          return Container(
            width: 200,
            child: ListView(
              children: widgets,
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}

Widget bbb(context, Map ele) => Container(
      width: 300,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(ele["message"], style: font_14_white),
    );
