import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'add_memory_screen.dart';
import '../providers/memories.dart';
import 'memory_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Your Memories',
            style: TextStyle(
              fontFamily: 'Concert',
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 45, 45, 45),
      ),
      body: BounceInUp(
        preferences: const AnimationPreferences(
          duration: Duration(milliseconds: 400),
        ),
        child: FutureBuilder(
          future:
              Provider.of<Memories>(context, listen: false).fetchAndSetMemory(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Memories>(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/waiting_cup.gif',
                          height: 100,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'No Memory added yet',
                          style: TextStyle(fontFamily: 'Acme'),
                        ),
                      ],
                    ),
                  ),
                  builder: (ctx, memory, ch) => memory.items.isEmpty
                      ? ch!
                      : GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: memory.items.length,
                          itemBuilder: (ctx, i) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GridTile(
                              footer: GridTileBar(
                                backgroundColor: Colors.black38,
                                title: Text(
                                  memory.items[i].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Acme',
                                  ),
                                ),
                                trailing: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          AddPlaceScreen.routeName,
                                          arguments: memory.items[i].id,
                                        );
                                      },
                                      iconSize: 20,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                child: AlertDialog(
                                                  title: const Text(
                                                    "Are you sure you want to delete this item?",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .red)),
                                                      onPressed: () {
                                                        Provider.of<Memories>(
                                                                context,
                                                                listen: false)
                                                            .deleteProduct(
                                                                memory.items[i]
                                                                    .id!);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Delete"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      icon: const Icon(Icons.delete),
                                      iconSize: 20,
                                    ),
                                  ],
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      type: PageTransitionType.scale,
                                      alignment: Alignment.center,
                                      child: MemoryDetailScreen(
                                        memory.items[i].id,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: memory.items[i].id!,
                                  child: FadeIn(
                                    preferences: const AnimationPreferences(
                                      duration: Duration(milliseconds: 2000),
                                    ),
                                    child: Image.file(
                                      File(memory.items[i].image1.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
        ),
      ),
    );
  }
}
