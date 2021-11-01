import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shopchat_app/widgets/home/ad_item.dart';

class MyAds extends StatefulWidget {
  
  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('uid', isEqualTo: uid)
          .snapshots(),
      builder: ( context, snapshot ) {

       /* if ( snapshot.hasData ) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }*/

            //Comprobamos que si tenemos información
           if ( snapshot.hasData ) {
             //Wdiget con la información
            
             var documents = snapshot.data!.docs;

        if( snapshot.data!.docs.length == 0 ) {
          return Center(
            child: Text('You haven\'t posted any ads'),
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
          } else {
            //CircularProgressIndicator(), permite indicar al usuario que se está cargando infromación 
            return Center(child: CircularProgressIndicator(strokeWidth: 2 ) );
          }

       
      },
    );
  }
}
