import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nodelink/widgets/people/people_grid.dart';

class PeopleCard extends StatelessWidget {
  final String username;
  final String imageurl;
  final List<String> skills;
  final List<String> interests;
  final Key? key;

  PeopleCard(
    this.username,
    this.imageurl,
    this.skills,
    this.interests, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: MediaQuery.of(context).size.width - 140,
              height: MediaQuery.of(context).size.height / 2.1,
              padding: const EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 2,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 4,
              ),
              child: Card(
                elevation: 7,
                color: const Color.fromARGB(255, 37, 37, 37),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 69, 69, 69)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 220,
                        height: 140,
                        child: Card(
                          color: const Color.fromARGB(255, 48, 48, 48),
                          elevation: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(imageurl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        child: Text(
                          username,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 222, 222, 222),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Skills:",
                          style: TextStyle(
                              color: Color.fromARGB(255, 240, 240, 240),
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      SizedBox(height: 60, child: PeopleGrid(skills)),
                      const SizedBox(
                        height: 1,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Interests:",
                          style: TextStyle(
                              color: Color.fromARGB(255, 240, 240, 240),
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      SizedBox(
                        height: 60,
                        child: PeopleGrid(interests),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Know more..',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
