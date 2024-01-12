import 'dart:io';
import 'package:diary_app/models/memory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'add_memory_screen.dart';
import '../providers/memories.dart';
import 'memory_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var displayList = [];

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Memories>(context, listen: false).items;
    void updateList(String value) {
      print("CHANGED!!!");
      setState(() {
        displayList = items
            .where(
              (element) => element.title.toLowerCase().contains(
                    value.toLowerCase(),
                  ),
            )
            .toList();
      });
    }

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Search your Memory",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "Acme",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (value) => updateList(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search for the title of the Memory",
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: displayList.length,
                itemBuilder: (context, i) => ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    displayList[i].title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    displayList[i].date,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 70,
                      child: Image.file(
                        displayList[i].image1,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: (() {
                    Navigator.of(context).pushNamed(
                      MemoryDetailScreen.routeName,
                      arguments: displayList[i].id,
                    );
                  }),
                ),
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
