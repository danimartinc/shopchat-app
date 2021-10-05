import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:shopchat_app/screens/home/product_detail_screen.dart';

class AdItem extends StatefulWidget {

  final dynamic docs;
  final bool isMe;
  final String myId;

  AdItem(
    this.docs,
    this.isMe,
    this.myId,
  );
  
  @override
  _AdItemState createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: {
            'docs': widget.docs,
            'isMe': widget.isMe,
          },
        ),
        child: GridTile(
          child: Hero(
            tag: widget.docs['id'],
            child: CachedNetworkImage(
              imageUrl: widget.docs['images'][0],
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          header: !widget.isMe
              ? Container(
                  padding: EdgeInsets.fromLTRB(0, 6, 2, 0),
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          //color: Colors.grey[900],
                          blurRadius: 15.0, // soften the shadow
                          spreadRadius: 2.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('products')
                            .doc(widget.docs['id'].toString())
                            .update({'isFav': !widget.docs['isFav']} );
                      },
                      alignment: Alignment.center,
                      icon: widget.docs['isFav']
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red[700],
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.red[700],
                            ),
                    ),
                  ),
                )
              : null,
          footer: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.54),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.docs['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                if (widget.docs['isSold'])
                  Text(
                    'Sold',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (!widget.docs['isSold'])
                  Text(
                    widget.docs['price'] == 0
                        ? 'Donate'
                        : '₹${widget.docs['price'].toString()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.docs['price'] == 0
                          ? Colors.pink[200]
                          : Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
