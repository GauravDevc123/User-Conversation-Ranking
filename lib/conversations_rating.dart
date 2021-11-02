import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConversationRating extends StatelessWidget {
  final TextEditingController rating = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String chatRoomId;
  ConversationRating({required this.chatRoomId});
  @override
  Widget build(BuildContext context) {
    List<String> chatUsers = chatRoomId.split("_");
    print(chatUsers);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: size.height / 1.25,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('chatroom')
                        .doc(chatRoomId)
                        .collection('chats')
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> map =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              return messages(chatUsers, size, map);
                            });
                      } else {
                        return Container();
                      }
                    })),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    Container(
                      height: size.height / 12,
                      width: size.width / 1.5,
                      child: TextField(
                        controller: rating,
                        decoration: InputDecoration(
                          labelText: "Enter a rating between 1-5",
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          bool flag = false;
                          await firestore
                              .collection('users')
                              .doc(chatUsers[0])
                              .get()
                              .then((value) async {
                            if (value.exists) {
                              int x = 0;
                              double containerValue = 0;
                              value.data()!.forEach((key, value1) async {
                                if (key == 'counts') {
                                  x = int.parse(value1);
                                }
                                if (key == 'average_ranking') {
                                  flag = true;
                                  print("Value is: " + value1);
                                  containerValue = double.parse(value1);
                                  print("Container Value is: " +
                                      containerValue.toString());
                                }
                              });
                              await firestore
                                  .collection('users')
                                  .doc(chatUsers[0])
                                  .update({
                                'average_ranking': ((containerValue * x +
                                            int.parse(rating.text)) /
                                        (x + 1))
                                    .toString(),
                                'counts': (x + 1).toString()
                              });
                              if (flag == false) {
                                await firestore
                                    .collection('users')
                                    .doc(chatUsers[0])
                                    .update({
                                  'average_ranking': rating.text,
                                  'counts': (1).toString()
                                });
                              }
                            }
                          });
                          bool flag1 = false;
                          await firestore
                              .collection('users')
                              .doc(chatUsers[1])
                              .get()
                              .then((value) async {
                            if (value.exists) {
                              int x1 = 0;
                              double containerValue1 = 0;
                              value.data()!.forEach((key, value1) async {
                                if (key == 'counts') {
                                  x1 = int.parse(value1);
                                }
                                if (key == 'average_ranking') {
                                  flag1 = true;
                                  containerValue1 = double.parse(value1);
                                }
                              });
                              await firestore
                                  .collection('users')
                                  .doc(chatUsers[1])
                                  .update({
                                'average_ranking': ((containerValue1 * x1 +
                                            int.parse(rating.text)) /
                                        (x1 + 1))
                                    .toString(),
                                'counts': (x1 + 1).toString()
                              });
                              if (flag1 == false) {
                                await firestore
                                    .collection('users')
                                    .doc(chatUsers[1])
                                    .update({
                                  'average_ranking': rating.text,
                                  'counts': (1).toString()
                                });
                              }
                            }
                          });
                          rating.clear();
                        },
                        icon: Icon(Icons.add))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(List<String> chatUsers, Size size, Map<String, dynamic> map) {
    return Container(
      width: size.width,
      alignment: map["sendBy"] == chatUsers[1]
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey,
        ),
        child: Text(
          map["message"],
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
