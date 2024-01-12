import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/memories.dart';

class MemoryDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';
  dynamic id;
  MemoryDetailScreen(this.id);
  @override
  Widget build(BuildContext context) {
    String? randomId = Provider.of<Memories>(context, listen: false).randomId();
    final selectedPlace = Provider.of<Memories>(context, listen: false)
        .findById(id != null ? id : randomId);
    List<Widget> imageList = [];
    if (selectedPlace.image1.path != "") {
      imageList.add(
        Image.file(
          selectedPlace.image1,
          fit: BoxFit.cover,
        ),
      );
    }
    if (selectedPlace.image2.path != "") {
      imageList.add(
        Image.file(
          selectedPlace.image2,
          fit: BoxFit.cover,
        ),
      );
    }
    if (selectedPlace.image3.path != "") {
      imageList.add(
        Image.file(
          selectedPlace.image3,
          fit: BoxFit.cover,
        ),
      );
    }
    if (selectedPlace.image4.path != "") {
      imageList.add(
        Image.file(
          selectedPlace.image4,
          fit: BoxFit.cover,
        ),
      );
    }
    if (selectedPlace.image5.path != "") {
      imageList.add(
        Image.file(
          selectedPlace.image5,
          fit: BoxFit.cover,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            selectedPlace.date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Lilita',
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 45, 45, 45),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 300,
              width: double.infinity,
              child: CarouselSlider(
                items: imageList
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              alignment: Alignment.center,
                              child: DetailScreen(e),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: e,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(
                    milliseconds: 2000,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 3,
            thickness: 2,
            color: Colors.black,
          ),
          Text(
            selectedPlace.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontFamily: 'Acme',
            ),
          ),
          const Divider(
            height: 3,
            thickness: 2,
            color: Colors.black,
            // indent: 80,
            // endIndent: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Text(
                  selectedPlace.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontFamily: 'Kalam',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final image;
  DetailScreen(this.image);
  @override
  State<DetailScreen> createState() => _DetailScreenState(image);
}

class _DetailScreenState extends State<DetailScreen> {
  final image;
  _DetailScreenState(this.image);
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: image,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
