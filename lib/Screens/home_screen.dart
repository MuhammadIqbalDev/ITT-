import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text_project_fyp/Screens/saved_files.dart';
import 'package:image_to_text_project_fyp/api/image_text_api.dart';
import 'package:translator/translator.dart';

class ImageCaptioningScreen extends StatefulWidget {
  @override
  _ImageCaptioningScreenState createState() => _ImageCaptioningScreenState();
}

class _ImageCaptioningScreenState extends State<ImageCaptioningScreen> {
  String _caption = '';

  Uint8List? _imageBytes;

  // Define the list of languages
  List<String> languages = [
    'English',
    'Turkish',
    'Spanish',
    'Russian',
    'Urdu',
    'Hindi',
    'Sindhi',
    'Arabic',
    'Czech',
    'Bengali (Bangla)',
  ]; // Add more languages if needed
  String selectedLanguage = 'Turkish';

  final FlutterTts flutterTts = FlutterTts();
  GoogleTranslator translator = GoogleTranslator();
  String targetLanguageCode = '';
  Future<void> _getImageAndCaption(ImageSource source) async {
    try {
      final bytes = await APIService.loadImageBytes(source);
      final caption = await APIService.getCaption(bytes);
      setState(() {
        _imageBytes = bytes as Uint8List?;
        _caption = caption;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void translate(String language) {
    switch (language) {
      case 'English':
        targetLanguageCode = 'en';
        break;
      case 'Turkish':
        targetLanguageCode = 'tr';
        break;
      case 'Spanish':
        targetLanguageCode = 'es';
        break;
      case 'Russian':
        targetLanguageCode = 'ru';
      case 'Urdu':
        targetLanguageCode = 'ur';
      case 'Hindi':
        targetLanguageCode = 'hi';
      case 'Sindhi':
        targetLanguageCode = 'sd';
      case 'Arabic':
        targetLanguageCode = 'ar';
      case 'Czech':
        targetLanguageCode = 'cs';
      case 'Bengali (Bangla)':
        targetLanguageCode = 'bn';
        break;
    }

    translator.translate(_caption, to: targetLanguageCode).then((output) {
      setState(() {
        _caption = output.toString();
      });
    });
  }

  Future<void> _speakCaption() async {
    await flutterTts.setLanguage(targetLanguageCode);
   
    await flutterTts.setPitch(1);
     await flutterTts.speak(_caption);
    
  }

  Future<void> saveImageAndCaption(String caption, Uint8List imageBytes) async {
    try {
      // Upload image to Firebase Storage
      final imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('$imageFileName.jpg');
      await ref.putData(imageBytes);

      // Get the download URL of the uploaded image
      final imageUrl = await ref.getDownloadURL();

      // Save image URL and caption to Firestore
      await FirebaseFirestore.instance.collection('captions').add({
        'imageUrl': imageUrl,
        'caption': caption,
      });

      // Show a success message or perform any other action
      print('Image and caption saved successfully!');
    } catch (e) {
      // Handle any errors
      print('Error saving image and caption: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      drawer: Container(
        width: 250,
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Container(
                decoration:
                    BoxDecoration(color: Colors.white,border: Border.all(),borderRadius: BorderRadius.circular(20)),
                child: Image.asset('assets/lenguaLens.png'),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ImageListScreen();
                  }));
                },
                leading: Icon(Icons.save_as_outlined,color: Colors.white,),
                title: Text('Saved Images',style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Lingua Lens',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_caption.isNotEmpty && _imageBytes != null) {
                saveImageAndCaption(_caption, _imageBytes!);
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('Image has been saved successfully.'),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('Please select an image and caption before saving.'),
                ));
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageBytes != null
                ? Image.memory(
                    _imageBytes!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 20.0),
            _caption.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.white,),borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          _caption,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0,color: Colors.white),
                        ),
                    ),
                  ),
                )
                : Container(),
            SizedBox(height: 20.0),
            InkWell(
              onTap: (){
                _getImageAndCaption(ImageSource.gallery);
              },
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.white),borderRadius: BorderRadius.circular(9)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Select Image From Gallery',style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
           
            SizedBox(height: 10.0),
            InkWell(
              onTap: (){
               _getImageAndCaption(ImageSource.camera);
              },
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.white),borderRadius: BorderRadius.circular(9)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Take Picture From Camera',style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
         
            SizedBox(height: 10.0),
            _caption.isNotEmpty
                ? 
              //   InkWell(
              // onTap: (){
              //   // log(_caption);
              //  _speakCaption;
              // },
              // child: Container(
              //   decoration: BoxDecoration(border: Border.all(color: Colors.white),borderRadius: BorderRadius.circular(9)),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text('Speak Caption',style: TextStyle(color: Colors.white),),
              //   ),
              // ),
            
                ElevatedButton(
                    onPressed: _speakCaption,
                    child: Text('Speak Caption'),
                  )
                : SizedBox(),
            SizedBox(height: 10.0),
            _caption.isNotEmpty
                ? DropdownButton<String>(
                    value: selectedLanguage,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedLanguage = newValue;
                          translate(newValue);
                        });
                      }
                    },
                    items:
                        languages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(),),
                      );
                    }).toList(),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
