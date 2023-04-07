import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nodelink/screens/comments_screen.dart';
import 'package:nodelink/screens/complete_profile_screen.dart';
import 'package:nodelink/screens/edit_post_screen.dart';
import 'package:nodelink/screens/edit_profile_screen.dart';
import 'package:nodelink/screens/link_requests_screen.dart';
import 'package:nodelink/screens/linked_nodes_screen.dart';
import 'package:nodelink/screens/people_profile_screen.dart';
import 'package:nodelink/screens/personal_chat_screen.dart';
import 'package:nodelink/screens/post_screen.dart';
import 'package:nodelink/screens/profile_detail_screen.dart';
import 'package:nodelink/screens/splash_screen.dart';
import 'package:nodelink/screens/tabs_screen.dart';
import 'package:nodelink/screens/user_post_screen.dart';
import '/screens/chat_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'Node',
        channelName: 'Nodelink',
        channelDescription: 'In-App Notifications',
        importance: NotificationImportance.High,
      )
    ],
    debug: true,
  );
  runApp(MyApp());
}

Future backgroundHandler(RemoteMessage msg) async {}
final user = FirebaseAuth.instance.currentUser;
final userId = user!.uid;
Future<String?> fetchname(String Id) async {
  String name;
  final userData =
      await FirebaseFirestore.instance.collection('user').doc(Id).get();
  name = userData['username'];
  return name;
}

triggerNotification(String tle, String bdy) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 0,
    channelKey: 'Node',
    title: tle,
    body: bdy,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nodelink',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        backgroundColor: Colors.blueGrey,
        // ignore: deprecated_member_use
        accentColor: Colors.green,
        // ignore: deprecated_member_use
        accentColorBrightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.blue,
          ),
        ),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            final user = FirebaseAuth.instance.currentUser;
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (userSnapshot.hasData || user != null) {
              CollectionReference reference = FirebaseFirestore.instance
                  .collection('user')
                  .doc(userId)
                  .collection('Notifications');
              reference.snapshots().listen((querySnapshot) {
                for (var event in querySnapshot.docChanges) {
                  switch (event.type) {
                    case DocumentChangeType.added:
                      if (event.doc.data() != null) {
                        fetchname(event.doc['reqId']).then((value) {
                          triggerNotification(
                            value.toString(),
                            event.doc['cause'],
                          );
                        });
                      }
                      break;
                    case DocumentChangeType.modified:
                      break;
                    case DocumentChangeType.removed:
                      break;
                  }
                }
              });
              return TabsScreen();
            } else {
              return const AuthScreen();
            }
          }),
      routes: {
        ChatScreen.routeName: (ctx) => const ChatScreen(),
        TabsScreen.routeName: (ctx) => TabsScreen(),
        PersonalChatScreen.routeName: (ctx) => const PersonalChatScreen(),
        UserPostScreen.routeName: (ctx) => UserPostScreen(),
        EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
        AuthScreen.routeName: (ctx) => const AuthScreen(),
        LinkedNodesScreen.routeName: (ctx) => const LinkedNodesScreen(),
        LinkRequestsScreen.routeName: (ctx) => const LinkRequestsScreen(),
        PeopleProfileScreen.routeName: (ctx) => PeopleProfileScreen(),
        PostScreen.routeName: (ctx) => const PostScreen(),
        CompleteProfileScreen.routeName: (ctx) => const CompleteProfileScreen(),
        ProfileDetailScreen.routeName: (ctx) => ProfileDetailScreen(),
        EditPostScreen.routeName: (ctx) => const EditPostScreen(),
        CommentScreen.routeName: (ctx) => const CommentScreen(),
      },
    );
  }
}
