import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: ((context, AsyncSnapshot chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting ||
            !chatSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final chatDocs = chatSnapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(chatDocs[index]['text'],
              chatDocs[index]['userId'] == FirebaseAuth.instance.currentUser!.uid, chatDocs[index]['username'], key: ValueKey(chatDocs[index].id),),
        );
      }),
    );
  }
}
