import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nodelink/modal/screen_arguments.dart';
import 'package:nodelink/screens/personal_chat_screen.dart';
import 'package:nodelink/screens/splash_screen.dart';
import 'package:nodelink/widgets/grid_display.dart';
import 'package:nodelink/widgets/people/people_posts.dart';

class PeopleProfileContent extends StatefulWidget {
  final String uid;
  PeopleProfileContent(this.uid);

  @override
  State<PeopleProfileContent> createState() => _PeopleProfileContentState();
}

class _PeopleProfileContentState extends State<PeopleProfileContent> {
  bool? isInteractionExist;
  bool? isRequested;
  bool? isRequesting;
  bool? isFriend;
  List<String> skills = [];
  List<String> interests = [];

  Future<List<String>> fetchSkills(String id) async {
    List<String> skills;
    final userData =
        await FirebaseFirestore.instance.collection('user').doc(id).get();
    skills = (userData['skills'] as List).map((e) => e as String).toList();
    return skills;
  }

  Future<List<String>> fetchInterests(String id) async {
    List<String> interests;
    final userData =
        await FirebaseFirestore.instance.collection('user').doc(id).get();
    interests =
        (userData['interests'] as List).map((e) => e as String).toList();
    return interests;
  }

  Future<String> fetchMyPosts(String id) async {
    String abou;
    final userData =
        await FirebaseFirestore.instance.collection('post').doc(id).get();
    abou = userData['about'];
    return abou;
  }

  Future<void> _sendRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    final time = Timestamp.now();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('userInteraction')
        .doc(widget.uid)
        .set({
      'interactionTime': time,
      'Request Sent': true,
      'Friends': false,
      'Got Request': false,
    });
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .collection('userInteraction')
        .doc(user.uid)
        .set({
      'interactionTime': time,
      'Request Sent': false,
      'Friends': false,
      'Got Request': true,
    });
  }

  Future<void> _cancelRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('userInteraction')
        .doc(widget.uid)
        .delete();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .collection('userInteraction')
        .doc(user.uid)
        .delete();
  }

  Future<void> acceptRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    final time = Timestamp.now();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('userInteraction')
        .doc(widget.uid)
        .update({
      'interactionTime': time,
      'Request Sent': false,
      'Friends': true,
      'Got Request': false,
    });
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .collection('userInteraction')
        .doc(user.uid)
        .update({
      'interactionTime': time,
      'Request Sent': false,
      'Friends': true,
      'Got Request': false,
    });
  }

  Future<DocumentSnapshot> fetchInfoSnap() async {
    final user = FirebaseAuth.instance.currentUser;
    final docSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('userInteraction')
        .doc(widget.uid)
        .get();
    return docSnapshot;
  }

  Future<void> _addNotification(
    String cause,
    String reqId,
  ) async {
    final time = Timestamp.now();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .collection('Notifications')
        .add({
      'reqId': reqId,
      'interactiontime': time,
      'cause': cause,
      'type': 'node_Interaction',
    });
  }

  @override
  void initState() {
    super.initState();
    fetchInfoSnap().then((value) {
      setState(() {
        isInteractionExist = value.exists;
        print(isInteractionExist);
      });
    });
    fetchInfoSnap().then((value) {
      setState(() {
        isFriend = value['Friends'];
        isRequested = value['Request Sent'];
        isRequesting = value['Got Request'];
      });
    });
    fetchSkills(widget.uid).then(
      (value) {
        setState(() {
          skills = value;
        });
      },
    );
    fetchInterests(widget.uid).then(
      (value) {
        setState(() {
          interests = value;
        });
      },
    );
  }

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 200,
      width: 500,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final mediaQuery = MediaQuery.of(context);
    final size = MediaQuery.of(context).devicePixelRatio;
    final textsize = MediaQuery.of(context).textScaleFactor;
    final deviceWidth = mediaQuery.size.width;
    final deviceHeight = mediaQuery.size.height;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .snapshots(),
      builder: ((context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        var userdata = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: deviceHeight / 4,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(60),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: userdata!['image_url'],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      userdata['username'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: textsize * 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              isInteractionExist == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _sendRequest().then((_) {
                              setState(() {
                                isInteractionExist = true;
                                isRequested = true;
                                isRequesting = false;
                                isFriend = false;
                              });
                            }).then((value) {
                              _addNotification(
                                'Sent you a link Request',
                                user!.uid,
                              );
                            });
                          },
                          child: const Text(
                            'Link',
                            style: TextStyle(
                              color: Color.fromARGB(255, 230, 230, 230),
                            ),
                          ),
                        ),
                      ],
                    )
                  : isFriend == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 10),
                                    content: const Text(
                                      'Are you sure about removing this link?',
                                    ),
                                    action: SnackBarAction(
                                        label: 'Yes, I am',
                                        textColor: Theme.of(context).errorColor,
                                        onPressed: () {
                                          _cancelRequest().then((value) {
                                            setState(() {
                                              isInteractionExist = false;
                                            });
                                          });
                                        }),
                                  ),
                                );
                              },
                              child: const Text(
                                'Remove Link',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 230, 230, 230),
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  PersonalChatScreen.routeName,
                                  arguments: ScreenArguments(
                                      userdata['username'],
                                      widget.uid,
                                      userdata['image_url']),
                                );
                              },
                              child: const Text(
                                'Message',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 230, 230, 230),
                                ),
                              ),
                            ),
                          ],
                        )
                      : isFriend == false && isRequested == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Request Sent.',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 137, 137, 137),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _cancelRequest().then((_) {
                                      setState(() {
                                        isInteractionExist = false;
                                      });
                                    });
                                  },
                                  child: const Text(
                                    'Unsend',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 230, 230, 230),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : isFriend == false && isRequesting == true
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Requesting you to link.',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 135, 135, 135),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        acceptRequest().then((value) {
                                          setState(() {
                                            isInteractionExist = true;
                                            isRequested = false;
                                            isRequesting = false;
                                            isFriend = true;
                                          });
                                        }).then((value) {
                                          _addNotification(
                                            'Accepted your link Request',
                                            user!.uid,
                                          );
                                        });
                                      },
                                      child: const Text(
                                        'Accept',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 230, 230, 230),
                                        ),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        _cancelRequest().then((_) {
                                          setState(() {
                                            isInteractionExist = false;
                                          });
                                        });
                                      },
                                      child: const Text(
                                        'Deny',
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
              Container(
                margin: EdgeInsets.only(top: size * 2),
                child: Card(
                  color: const Color.fromARGB(255, 29, 29, 29),
                  elevation: 7,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "About:",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 240, 240, 240),
                              fontSize: textsize * 12,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          userdata['about'],
                          style: TextStyle(
                              color: const Color.fromARGB(255, 173, 173, 173),
                              fontSize: textsize * 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size * 2),
                height: deviceHeight / 6,
                width: deviceWidth,
                child: Card(
                  color: const Color.fromARGB(255, 29, 29, 29),
                  elevation: 7,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Skills:",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 240, 240, 240),
                              fontSize: textsize * 10,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GridDisplay(skills),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size * 2),
                height: deviceHeight / 6,
                width: deviceWidth,
                child: Card(
                  color: const Color.fromARGB(255, 29, 29, 29),
                  elevation: 7,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Interests:",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 240, 240, 240),
                              fontSize: textsize * 10,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GridDisplay(interests),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Text(
                  "My Contributions:",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 240, 240, 240),
                      fontSize: textsize * 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PeoplePosts(widget.uid),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      }),
    );
  }
}
