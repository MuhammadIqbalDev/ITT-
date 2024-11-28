import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_to_text_project_fyp/Screens/expanded_tile.dart';

class ImageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Images'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('captions').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20)),
                      child: Text("${index+1}",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)),
                
                    TileContainer(title: document['caption'], description:document['imageUrl']),
                  ],
                ),
              );
             
            
            },
          );
        },
      ),
    );
  }
}
