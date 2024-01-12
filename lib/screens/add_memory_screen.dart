import 'dart:io';
import 'package:diary_app/models/memory.dart';
import 'package:diary_app/widgets/adaptive_flat_button.dart';
import 'package:diary_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/image_input.dart';
import '../providers/memories.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();
  final List<XFile> _pickedImage = [];
  String _selectedDate = "NULL";

  var _editedMemory = Memory(
    id: '',
    title: '',
    description: '',
    date: '',
    image1: File(''),
    image2: File(''),
    image3: File(''),
    image4: File(''),
    image5: File(''),
  );
  var _initValues = {
    'id': '',
    'title': '',
    'description': '',
    'date': '',
    'image1': '',
    'image2': '',
    'image3': '',
    'image4': '',
    'image5': '',
  };
  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    if (_isInit) {
      final id = ModalRoute.of(context)?.settings.arguments as String?;
      if (id != null) {
        _editedMemory =
            Provider.of<Memories>(context, listen: false).findById(id);
        _initValues = {
          'id': id,
          'title': _editedMemory.title,
          'description': _editedMemory.description,
          'date': _editedMemory.date,
          'image1': _editedMemory.image1.path,
          'image2': _editedMemory.image1.path,
          'image3': _editedMemory.image1.path,
          'image4': _editedMemory.image1.path,
          'image5': _editedMemory.image1.path,
        };
      }
    }
    _isInit = false;
    if (_editedMemory.image1.path != "") {
      _pickedImage.add(
        XFile(_editedMemory.image1.path),
      );
    }
    if (_editedMemory.image2.path != "") {
      _pickedImage.add(
        XFile(_editedMemory.image2.path),
      );
    }
    if (_editedMemory.image3.path != "") {
      _pickedImage.add(
        XFile(_editedMemory.image3.path),
      );
    }
    if (_editedMemory.image4.path != "") {
      _pickedImage.add(
        XFile(_editedMemory.image4.path),
      );
    }
    if (_editedMemory.image5.path != "") {
      _pickedImage.add(
        XFile(_editedMemory.image5.path),
      );
    }
    super.didChangeDependencies();
  }

  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void onSelectImages(List<XFile> selectedImages) {
    _pickedImage.addAll(selectedImages);
    setState(() {});
  }

  Future<void> _savePlace() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedMemory.title == '' ||
        _pickedImage.isEmpty ||
        _editedMemory.description == '' ||
        _pickedImage.length > 5 ||
        _editedMemory.date == "") {
      if (_pickedImage.length > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Only 5 or less images are allowed',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
        );
      } else if (_pickedImage.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Select images',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
        );
      } else if (_editedMemory.date == "") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Choose a date',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (_editedMemory.id != '') {
      await Provider.of<Memories>(context, listen: false).updateMemory(
        _editedMemory.id!,
        _editedMemory.title,
        _editedMemory.description,
        _pickedImage,
        _editedMemory.date,
      );
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Memories>(context, listen: false).addMemory(
          _editedMemory.title,
          _editedMemory.description,
          _pickedImage,
          _editedMemory.date,
        );
        Navigator.of(context).pushReplacement(_createRoute());
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BottomNavBar(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _editedMemory = Memory(
            id: _editedMemory.id,
            title: _editedMemory.title,
            description: _editedMemory.description,
            date: DateFormat.yMMMd().format(pickedDate),
            image1: _editedMemory.image1,
            image2: _editedMemory.image2,
            image3: _editedMemory.image3,
            image4: _editedMemory.image4,
            image5: _editedMemory.image5,
          );
          ;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: _editedMemory.id != ''
              ? const Text(
                  'Update Memory',
                  style: TextStyle(
                    fontFamily: 'Concert',
                  ),
                )
              : const Text(
                  'Add a new Memory',
                  style: TextStyle(
                    fontFamily: 'Concert',
                  ),
                ),
        ),
        backgroundColor: const Color.fromARGB(255, 45, 45, 45),
      ),
      body: Center(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Title",
                    hintStyle: const TextStyle(fontFamily: "Acme"),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.orange,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, style: BorderStyle.solid),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.blueGrey,
                      ),
                    ),
                    prefixIconColor: Colors.black,
                  ),
                  initialValue: _initValues['title'],
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedMemory = Memory(
                      id: _editedMemory.id,
                      title: value!,
                      description: _editedMemory.description,
                      date: _editedMemory.date,
                      image1: _editedMemory.image1,
                      image2: _editedMemory.image2,
                      image3: _editedMemory.image3,
                      image4: _editedMemory.image4,
                      image5: _editedMemory.image5,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  initialValue: _initValues['description'],
                  maxLength: 500,
                  maxLines: 3,
                  decoration: InputDecoration(
                    // labelText: 'Description',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Add a description about your memory",
                    hintStyle: const TextStyle(fontFamily: "Acme"),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.orange,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, style: BorderStyle.solid),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.blueGrey,
                      ),
                    ),
                    prefixIconColor: Colors.black,
                  ),
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    if (value.length < 10) {
                      return 'Description should be at least 10 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedMemory = Memory(
                      id: _editedMemory.id,
                      title: _editedMemory.title,
                      description: value!,
                      date: _editedMemory.date,
                      image1: _editedMemory.image1,
                      image2: _editedMemory.image2,
                      image3: _editedMemory.image3,
                      image4: _editedMemory.image4,
                      image5: _editedMemory.image5,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(5),
                  child: _pickedImage.isEmpty
                      ? const Center(
                          child: Text(
                            "No images selected",
                            style: TextStyle(fontFamily: 'Acme'),
                          ),
                        )
                      : GridView.builder(
                          itemCount: _pickedImage.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                          ),
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: -5,
                                    blurRadius: 10,
                                    offset: Offset(-5, 7),
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: GridTile(
                                  footer: GridTileBar(
                                      title: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _pickedImage.removeAt(i);
                                      setState(() {});
                                    },
                                  )),
                                  child: Image.file(
                                    File(_pickedImage[i].path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ImageInput(onSelectImages),
                    const SizedBox(
                      width: 20,
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: Text(
                      _editedMemory.date == ""
                          ? 'Choose a date'
                          : _editedMemory.date,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Padauk',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_rounded),
                label: const Text('Save Memory'),
                onPressed: _savePlace,
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: MaterialStateProperty.all(Colors.black87),
                  enableFeedback: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
