import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/screens/auth_screen.dart';
import 'package:nodelink/screens/link_requests_screen.dart';
import 'package:nodelink/screens/linked_nodes_screen.dart';
import 'package:nodelink/screens/splash_screen.dart';
import 'package:nodelink/widgets/grid_display.dart';
import 'package:nodelink/widgets/user/user_posts.dart';

class ProfileDetailScreen extends StatefulWidget {
  static const routeName = '/profile-detail';

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  List<String> skills = [];
  List<String> interests = [];

  Future<List<String>> fetchSkills() async {
    List<String> skills;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    // (map['categories'] as List)?.map((item) => item as String)?.toList();
    skills = (userData['skills'] as List).map((e) => e as String).toList();
    return skills;
  }

  Future<List<String>> fetchInterests() async {
    List<String> interests;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    interests =
        (userData['interests'] as List).map((e) => e as String).toList();
    return interests;
  }

  Future<String> fetchMyPosts() async {
    String abou;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('post')
        .doc(user!.uid)
        .get();
    abou = userData['about'];
    return abou;
  }

  @override
  void initState() {
    super.initState();
    fetchSkills().then(
      (value) {
        setState(() {
          skills = value;
        });
      },
    );
    fetchInterests().then(
      (value) {
        setState(() {
          interests = value;
        });
      },
    );
  }

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
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
          .doc(user!.uid)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
        var userdata = userSnapshot.data;
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: const Color.fromARGB(255, 33, 33, 33),
              actions: [
                DropdownButton(
                  underline: Container(),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  items: [
                    DropdownMenuItem(
                      child: SizedBox(
                        child: Row(
                          children: const [
                            Icon(Icons.exit_to_app),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Logout'),
                          ],
                        ),
                      ),
                      value: 'logout',
                    ),
                  ],
                  onChanged: (itemIdentifier) {
                    if (itemIdentifier == 'logout') {
                      FirebaseAuth.instance.signOut().then(
                            (value) => Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const AuthScreen()),
                                (route) => false),
                          );
                    }
                  },
                ),
              ]),
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          body: SingleChildScrollView(
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
                        child: Image.network(
                          userdata!['image_url'],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(LinkedNodesScreen.routeName);
                      },
                      child: const Text(
                        'Linked Nodes',
                        style: TextStyle(
                          color: Color.fromARGB(255, 224, 224, 224),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(LinkRequestsScreen.routeName);
                      },
                      child: const Text(
                        'Link Requests',
                        style: TextStyle(
                          color: Color.fromARGB(255, 181, 181, 181),
                        ),
                      ),
                    )
                  ],
                ),
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
                          GridDisplay(skills as List<String>),
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
                          GridDisplay(interests as List<String>),
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
                UserPosts(),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.of(context).pushNamed('/edit-profile'),
            icon: const Icon(
              Icons.edit,
            ),
            label: const Text('Edit Profile'),
          ),
        );
      },
    );
  }
}
