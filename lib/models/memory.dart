import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Memory with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final String date;
  final File image1;
  final File image2;
  final File image3;
  final File image4;
  final File image5;

  Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.image5,
  });

  // File get image => null;
}
