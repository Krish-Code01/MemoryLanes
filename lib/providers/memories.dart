import 'dart:io';
import "dart:math";
import 'package:diary_app/screens/search_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../helpers/db_helper.dart';

import 'package:flutter/material.dart';

import '../models/memory.dart';

class Memories with ChangeNotifier {
  List<Memory> _items = [];

  List<Memory> get items {
    return [..._items];
  }

  int listSize() {
    return _items.length;
  }

  String? randomId() {
    final random = Random();
    return _items[random.nextInt(_items.length)].id;
  }

  Memory findById(String id) {
    return _items.firstWhere((memory) => memory.id == id);
  }

  Future<void> addMemory(
    String pickedTitle,
    String pickedDescription,
    List<XFile> pickedImage,
    String selectedDate,
  ) async {
    final newMemory = Memory(
      id: DateTime.now().toString(),
      title: pickedTitle,
      description: pickedDescription,
      date: selectedDate,
      image1: File(pickedImage[0].path),
      image2: pickedImage.length >= 2 ? File(pickedImage[1].path) : File(""),
      image3: pickedImage.length >= 3 ? File(pickedImage[2].path) : File(""),
      image4: pickedImage.length >= 4 ? File(pickedImage[3].path) : File(""),
      image5: pickedImage.length >= 5 ? File(pickedImage[4].path) : File(""),
    );
    _items.add(newMemory);
    notifyListeners();

    DBHelper.insert(
      'user_memory',
      {
        'id': newMemory.id!,
        'title': newMemory.title,
        'description': newMemory.description,
        'date': newMemory.date,
        'images1': newMemory.image1.path,
        'images2': newMemory.image2.path,
        'images3': newMemory.image3.path,
        'images4': newMemory.image4.path,
        'images5': newMemory.image5.path,
      },
    );
  }

  Future<void> fetchAndSetMemory() async {
    final dataList = await DBHelper.getData('user_memory');
    _items = dataList
        .map(
          (item) => Memory(
            id: item["id"],
            title: item["title"],
            description: item["description"],
            date: item["date"],
            image1: File(item["images1"]),
            image2: File(item["images2"]),
            image3: File(item["images3"]),
            image4: File(item["images4"]),
            image5: File(item["images5"]),
          ),
        )
        .toList();
    notifyListeners();
  }

  Future<void> updateMemory(
    String id,
    String pickedTitle,
    String pickedDescription,
    List<XFile> pickedImage,
    String selectedDate,
  ) async {
    final newMemory = Memory(
      id: id,
      title: pickedTitle,
      description: pickedDescription,
      date: selectedDate,
      image1: File(pickedImage[0].path),
      image2: pickedImage.length >= 2 ? File(pickedImage[1].path) : File(""),
      image3: pickedImage.length >= 3 ? File(pickedImage[2].path) : File(""),
      image4: pickedImage.length >= 4 ? File(pickedImage[3].path) : File(""),
      image5: pickedImage.length >= 5 ? File(pickedImage[4].path) : File(""),
    );
    int i = _items.indexWhere((element) => element.id == id);
    _items[i] = newMemory;
    notifyListeners();

    DBHelper.update(
      newMemory.id!,
      'user_memory',
      {
        'id': newMemory.id!,
        'title': newMemory.title,
        'description': newMemory.description,
        'date': newMemory.date,
        'images1': newMemory.image1.path,
        'images2': newMemory.image2.path,
        'images3': newMemory.image3.path,
        'images4': newMemory.image4.path,
        'images5': newMemory.image5.path,
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    int i = _items.indexWhere((element) => element.id == id);
    _items.removeAt(i);
    notifyListeners();
    DBHelper.delete(id, 'user_memory');
  }
}
