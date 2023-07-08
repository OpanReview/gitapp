import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ogchat/models/user.dart';
import 'package:ogchat/providers/user_provider.dart';
import 'package:ogchat/resources/firestore_methods.dart';
import 'package:ogchat/utils/colors.dart';
import 'package:ogchat/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, uid, _file!, username, profImage);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Publicación creada');
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
            title: const Text(
              'Crea una publicación',
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Haz una foto',
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Escoge una foto',
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Cancelar',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]);
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Column(
            children: [
              const Text(
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  'Sube una rucada'),
              const SizedBox(
                height: 20,
              ),
              IconButton(
                  splashColor: Color.fromARGB(255, 51, 118, 68),
                  icon: const Icon(Icons.upload),
                  onPressed: () => _selectImage(context)),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Subir Foto'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () => postImage(
                          user.uid,
                          user.username,
                          user.photoUrl,
                        ),
                    child: const Text('Subir',
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 118, 68),
                            fontWeight: FontWeight.w400,
                            fontSize: 20)))
              ],
            ),
            body: Column(children: [
              _isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
              const Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.photoUrl,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un comentario...',
                        border: InputBorder.none,
                      ),
                      maxLines: 4,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter)),
                      ),
                    ),
                  ),
                  const Divider()
                ],
              )
            ]),
          );
  }
}
