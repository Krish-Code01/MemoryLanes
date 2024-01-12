import 'package:diary_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  bool onLastPage = false;
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              Container(
                color: const Color.fromRGBO(37, 37, 37, 1),
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/page1.gif'),
                      const Text(
                        'Click and Add',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: "Lilita",
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Capture and Add your best clicks of a memory \nand make a collection of memory lanes',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: "Acme",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: const Color.fromRGBO(37, 37, 37, 1),
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      Image.asset('assets/images/page2.gif'),
                      const Text(
                        'Add Description',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: "Lilita",
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Add the description of the memory explaining your experience',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: "Acme",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: const Color.fromRGBO(37, 37, 37, 1),
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      Image.asset('assets/images/page3.gif'),
                      const Text(
                        'Rewind Memories',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: "Lilita",
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Rewatch and experience by scrolling through random Memories\n from your collection\nRevisiting the experience might also\n reduce the stress and anxiety',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: "Acme",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.white, fontFamily: "Acme"),
                  ),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('showHome', true);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return BottomNavBar();
                        },
                      ),
                    );
                  },
                ),
                SmoothPageIndicator(controller: _controller, count: 3),
                onLastPage
                    ? GestureDetector(
                        child: const Text(
                          'Done',
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Acme"),
                        ),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('showHome', true);
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BottomNavBar();
                              },
                            ),
                          );
                        },
                      )
                    : GestureDetector(
                        child: const Text(
                          'Next',
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Acme"),
                        ),
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
