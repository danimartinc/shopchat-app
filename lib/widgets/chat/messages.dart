import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shopchat_app/widgets/chat/chat_bubble.dart';

class Messages extends StatelessWidget {
  
  final String documentId;
  final String senderId;
  final String? receiverId;

  Messages({
    required this.documentId,
    required this.senderId,
    this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('chats/$documentId/messages')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
            
          var documents = snapshot.data!.docs;

          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ( context, i ) => Container(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: MessageBubble(
                  message: documents[i]['message'],
                  isMe: documents[i]['senderId'] == senderId,
                  time: (documents[i]['timeStamp'] as Timestamp).toDate(),
                  imageUrl: documents[i]['imageUrl'],
                ),
              ),
            ),
          );
        });
  }
}
