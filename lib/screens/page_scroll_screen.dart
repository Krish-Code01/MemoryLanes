import 'package:diary_app/screens/memory_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';
import '../providers/memories.dart';

class PageScrollScreen extends StatefulWidget {
  const PageScrollScreen({super.key});
  @override
  State<PageScrollScreen> createState() => _PageScrollScreenState();
}

class _PageScrollScreenState extends State<PageScrollScreen> {
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();

    int size = Provider.of<Memories>(context, listen: true).listSize();
    String? randomId;
    if (size != 0) {
      (randomId = Provider.of<Memories>(context, listen: true).randomId());
    }
    List<MemoryDetailScreen> listScroll = [
      MemoryDetailScreen(null),
      MemoryDetailScreen(null),
      MemoryDetailScreen(null),
    ];
    for (int i = 0; i < 50; i++) {
      listScroll.add(MemoryDetailScreen(null));
    }
    return size == 0
        ? Scaffold(
            backgroundColor: const Color.fromARGB(255, 239, 239, 239),
            appBar: AppBar(
              title: const Center(
                child: Text(
                  'Scroll View',
                  style: TextStyle(
                    fontFamily: 'Concert',
                  ),
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 45, 45, 45),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BounceInUp(
                    child: Image.asset(
                      'assets/images/swipe.gif',
                      height: 100,
                      colorBlendMode: BlendMode.difference,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Add some memories and swipe',
                    style: TextStyle(fontFamily: 'Acme'),
                  ),
                ],
              ),
            ),
          )
        : PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            children: listScroll,
          );
  }
}
