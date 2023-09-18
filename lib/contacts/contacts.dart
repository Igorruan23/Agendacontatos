import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsDetailPage extends StatefulWidget {
  final String contactDetails;
  const ContactsDetailPage({super.key, required this.contactDetails});

  @override
  State<ContactsDetailPage> createState() => _ContactsDetailPageState();
}

class _ContactsDetailPageState extends State<ContactsDetailPage> {
  File? _image;
  String? _imageKey;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageKey = 'contact_image_${widget.contactDetails.hashCode}'; // Chave única para cada contato
    _loadImageFromSharedPreferences();
  }

  Future<void> _loadImageFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final bytes = prefs.getStringList(_imageKey!);

    if (bytes != null) {
      final imageBytes = bytes.map((byte) => int.parse(byte)).toList();
      setState(() {
        _image = File.fromRawPath(Uint8List.fromList(imageBytes));
      });
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _saveImageToSharedPreferences(); // Salvar a imagem em SharedPreferences
      }
    });
  }

  Future<void> _saveImageToSharedPreferences() async {
    if (_image == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final bytes = await _image!.readAsBytes();
    prefs.setStringList(_imageKey!, bytes.map((byte) => byte.toString()).toList());
  }

  @override
  Widget build(BuildContext context) {
    List<String> contactInfo = widget.contactDetails.split(' - ');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Detalhes do Contato'),
      ),
      backgroundColor: Colors.lightBlue[100],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _getImage, // Permite que o usuário clique na imagem para escolher uma nova
              child: Center(
                child: _image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_image!),
                      )
                    : CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nome'),
              subtitle: Text(contactInfo[0]),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Número de Telefone'),
              subtitle: Text(contactInfo[1]),
            ),
          ],
        ),
      ),
    );
  }
}