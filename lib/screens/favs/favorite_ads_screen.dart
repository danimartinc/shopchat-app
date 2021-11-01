import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shopchat_app/widgets/home/ad_item.dart';

class FavoriteAdsScreen extends StatefulWidget {
  
  @override
  _FavoriteAdsScreenState createState() => _FavoriteAdsScreenState();
}

class _FavoriteAdsScreenState extends State<FavoriteAdsScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build( BuildContext context ) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('isFav', isEqualTo: true )
          .snapshots(),
      builder: ( context, snapshot ) {

        if ( snapshot.connectionState == ConnectionState.waiting ) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var documents = snapshot.data!.docs;
        
        if ( !snapshot.hasData ) {
          return Center(
            child: Text('You don\'t have any favourites'),
          );
        }

        return Padding(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: documents.length,
            itemBuilder: (context, i) {
              return AdItem(
                documents[i],
                documents[i]['uid'] == uid,
                uid,
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3 / 2,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
          ),
        );
      },
    );
  }
}
