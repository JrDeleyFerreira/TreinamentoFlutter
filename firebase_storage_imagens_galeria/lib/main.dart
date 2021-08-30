import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late File _imagem;
  var _estadoUpload = 'Upload não iniciado';
  var _urlRecuperada = "";

  Future _recuperarImagem(bool daCamera) async {
    PickedFile imagemSelecionada;

    if (daCamera) {
      imagemSelecionada =
          // ignore: invalid_use_of_visible_for_testing_member
          (await ImagePicker.platform.pickImage(source: ImageSource.camera))!;
    } else {
      imagemSelecionada =
          // ignore: invalid_use_of_visible_for_testing_member
          (await ImagePicker.platform.pickImage(source: ImageSource.gallery))!;
    }
    setState(() {
      _imagem = imagemSelecionada as File;
    });
  }

  Future _uploadImagem() async {
    var storage = FirebaseStorage.instance;
    var referencia = storage.ref().child('pasta').child('imagem.jpg');

    var task = referencia.putFile(_imagem);
    task.snapshotEvents.listen((taskSnapshot) {
      if (taskSnapshot.state == TaskState.running) {
        setState(() {
          _estadoUpload = 'Em progresso...';
        });
      } else if (taskSnapshot.state == TaskState.success) {
        _recuperarUrlImgSalva(taskSnapshot);
        setState(() {
          _estadoUpload = 'Upload finalizado com Sucesso!';
        });
      }
    });
  }

  Future _recuperarUrlImgSalva(TaskSnapshot taskSnapshot) async {
    var url = await taskSnapshot.ref.getDownloadURL();
    _urlRecuperada = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selecionand imagens')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(_estadoUpload),
            ElevatedButton(
              child: Text('Câmera'),
              onPressed: () => _recuperarImagem(true),
            ),
            ElevatedButton(
              child: Text('Galeria'),
              onPressed: () => _recuperarImagem(false),
            ),
            _imagem == null ? Container() : Image.file(_imagem),
            ElevatedButton(
              child: Text('Upload Store'),
              onPressed: () => _uploadImagem(),
            ),
            _imagem == null ? Container() : Image.network(_urlRecuperada),
          ],
        ),
      ),
    );
  }
}
