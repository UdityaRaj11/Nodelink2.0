import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:nodelink/screens/chat_list_screen.dart';
import 'package:nodelink/screens/complete_profile_screen.dart';
import 'package:nodelink/screens/explore_screen.dart';
import 'package:nodelink/screens/home_screen.dart';
import 'package:nodelink/screens/notification_screen.dart';
import 'package:nodelink/screens/splash_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String? userImageUrl;
  bool userComplete = true;
  Future<String> fetchImageUrl() async {
    String imageUrl;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    imageUrl = userData['image_url'];
    return imageUrl;
  }

  Future<String?> fetchAbout() async {
    String about;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    about = userData['about'];
    return about;
  }

  List<Object> _pages = [];
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((value) {
      if (!value) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    fetchAbout().then((value) {
      if (value == null) {
        setState(() {
          userComplete = false;
        });
        Navigator.of(context).pushNamed(CompleteProfileScreen.routeName);
      }
    });
    fetchImageUrl().then((value) {
      setState(() {
        userImageUrl = value;
      });
    });
    _pages = [
      const HomeScreen(),
      const ExploreScreen(),
      const NotificationsScreen(),
      const ChatListScreen()
    ];
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
        var userdata = userSnapshot.data;
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (!userSnapshot.hasData) {
          return const SplashScreen();
        } else if (userdata!['about'] == null) {
          return const Scaffold(body: CompleteProfileScreen());
        }
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              'NodeLink',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(255, 29, 29, 29),
            actions: <Widget>[
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/profile-detail');
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color.fromARGB(255, 29, 29, 29),
                    backgroundImage: CachedNetworkImageProvider(
                      userdata['image_url'],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: _pages[_selectedPageIndex] as Widget,
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            backgroundColor: const Color.fromARGB(255, 29, 29, 29),
            unselectedItemColor: const Color.fromARGB(255, 77, 77, 77),
            selectedItemColor: const Color.fromARGB(255, 101, 215, 0),
            selectedFontSize: 20,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: _selectedPageIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(Icons.category),
                label: 'Nodes',
              ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(Icons.notifications),
                label: 'Updates',
              ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(
                  Icons.chat,
                  color: Color.fromARGB(255, 247, 247, 247),
                  size: 35,
                ),
                activeIcon: const Icon(
                  Icons.edit_note,
                  size: 35,
                ),
                label: 'Chats',
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _selectedPageIndex == 0
              ? SpeedDial(
                  overlayColor: const Color.fromARGB(255, 28, 28, 28),
                  buttonSize: const Size(40, 40),
                  icon: Icons.add,
                  backgroundColor: Colors.blue,
                  children: [
                    SpeedDialChild(
                      child: const Icon(Icons.add_a_photo),
                      label: 'Contribute Image',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 216, 216, 216)),
                      labelBackgroundColor:
                          const Color.fromARGB(255, 37, 37, 37),
                      backgroundColor: Colors.green,
                      onTap: () {
                        Navigator.of(context).pushNamed('/edit-posts-screen');
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.video_camera_front),
                      label: 'Contribute video',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 216, 216, 216)),
                      labelBackgroundColor:
                          const Color.fromARGB(255, 37, 37, 37),
                      backgroundColor: Colors.green,
                      onTap: () {},
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}
