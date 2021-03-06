import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import './tabs/home_screen.dart';
import 'tabs/users_chat_screen.dart';
import './tabs/profile_screen.dart';
import 'tabs/ads_tab_screen.dart';
import 'tabs/add_product_screen.dart';
import 'package:shopchat_app/screens/home/search.dart';

class BottomNavigationScreen extends StatefulWidget {

  static const routeName = './bottom_navigation';

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  
  int selectedPageIndex = 0;
  late List<Map<String, Object>> _pages;

  @override
  void initState() {
  
    //Obtenemos la instancia de FirebaseMessaging
    //static FirebaseMessaging messaging = FirebaseMessaging.instance;
  
    // final fcm = FirebaseMessaging.instance;
    //
    // FirebaseMessaging.onMessage.listen(( RemoteMessage message ) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification!.android;
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen(( RemoteMessage message ) {
    //   print('A new onMessageOpenedApp event was published!');
    //   // Navigator.pushNamed(context, '/message',
    //   // //MesageArguments,
    //   //     arguments: MessageArguments( message, true));
    // });



//await Firebase.initializeApp();

    // fcm.configure(
    //
    //   onMessage: (msg) {
    //     print('onMessage');
    //     print( msg );
    //     return;
    //   },
    //
    //   onLaunch: (msg) {
    //     print('onLaunch');
    //     print(msg);
    //     return Navigator.of(context).pushNamed(
    //       UsersChatScreen.routeName,
    //     );
    //   },
    //
    //   onResume: (msg) {
    //     print('onResume');
    //     print(msg);
    //     return Navigator.of(context).pushNamed(
    //       UsersChatScreen.routeName,
    //     );
    //   },
    // );

    //fcm.subscribeToTopic('chats');

    _pages = [
      {
        'pages': HomeScreen(),
        'title': 'Home',
      },
      {
        'pages': AdsTabScreen(),
        'title': 'My Ads',
      },
      {
        'pages': AddProduct(),
        'title': 'Sell a Book!',
      },
      {
        'pages': UsersChatScreen(),
        'title': 'Chats',
      },
      {
        'pages': ProfileScreen(),
        'title': 'Profile',
      }
    ];
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectedPageIndex == 0 ||
              selectedPageIndex == 1 ||
              selectedPageIndex == 3
          ? null
          : AppBar(
              title: Text(
                _pages[selectedPageIndex]['title'] as String,
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
      body: _pages[selectedPageIndex]['pages'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        iconSize: 28,
        currentIndex: selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            //backgroundColor: Theme.of(context).primaryColor,
            icon: selectedPageIndex == 0
                ? Icon(
                    Icons.home_rounded,
                  )
                : Icon(
                    Icons.home_outlined,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'My Ads',
            icon: selectedPageIndex == 1
                ? Icon(
                    Icons.book,
                  )
                : Icon(
                    Icons.book_outlined,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Add',
            icon: selectedPageIndex == 2
                ? Icon(
                    Icons.add_circle,
                  )
                : Icon(
                    Icons.add_circle_outline,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Chats',
            icon: selectedPageIndex == 3
                ? Icon(
                    Icons.chat_bubble,
                  )
                : Icon(
                    Icons.chat_bubble_outline,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: selectedPageIndex == 4
                ? Icon(
                    Icons.person,
                  )
                : Icon(
                    Icons.person_outline,
                  ),
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
