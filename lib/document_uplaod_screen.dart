import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DocumentUploadScreen extends StatefulWidget {
  final String documentType;
  final String phoneNumber;

  DocumentUploadScreen({required this.documentType, required this.phoneNumber});

  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  String? frontImageUrl;
  String? backImageUrl;

  Future<void> _pickImage(BuildContext context, String side) async {
    final XFile? pickedImage = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context,
                    await _picker.pickImage(source: ImageSource.camera));
              },
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context,
                    await _picker.pickImage(source: ImageSource.gallery));
              },
              child: Text('Gallery'),
            ),
          ],
        );
      },
    );

    if (pickedImage != null) {
      await uploadDocument(pickedImage, side);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$side image uploaded')),
      );
    }
  }

  Future<void> uploadDocument(XFile pickedImage, String side) async {
    String storagePath =
        'documents/${widget.phoneNumber}/${widget.documentType}_$side.jpg';
    File file = File(pickedImage.path);

    try {
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(storagePath).putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('service_user')
          .doc(widget.phoneNumber)
          .collection('document_verification')
          .doc(widget.documentType)
          .set(
        {"${side}ImageUrl": downloadUrl},
        SetOptions(merge: true),
      );

      setState(() {
        if (side == 'front') {
          frontImageUrl = downloadUrl;
        } else {
          backImageUrl = downloadUrl;
        }
      });
    } catch (e) {
      print("Error uploading document: $e");
    }
  }

  Future<void> deleteImage(String side) async {
    String storagePath =
        'documents/${widget.phoneNumber}/${widget.documentType}_$side.jpg';

    try {
      // Delete image from Firebase Storage
      await FirebaseStorage.instance.ref(storagePath).delete();

      // Remove the URL from Firestore
      await FirebaseFirestore.instance
          .collection('service_user')
          .doc(widget.phoneNumber)
          .collection('document_verification')
          .doc(widget.documentType)
          .update({"${side}ImageUrl": FieldValue.delete()});

      setState(() {
        if (side == 'front') {
          frontImageUrl = null;
        } else {
          backImageUrl = null;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$side image deleted')),
      );
    } catch (e) {
      print("Error deleting image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.documentType} Upload')),
      body: Column(
        children: [
          // Front Image Upload
          ElevatedButton(
            onPressed: () => _pickImage(context, 'front'),
            child: Text('Upload Front Image'),
          ),
          if (frontImageUrl != null)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Image.network(frontImageUrl!, width: 150, height: 150),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteImage('front'),
                ),
              ],
            ),
          SizedBox(height: 20),

          // Back Image Upload
          ElevatedButton(
            onPressed: () => _pickImage(context, 'back'),
            child: Text('Upload Back Image'),
          ),
          if (backImageUrl != null)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Image.network(backImageUrl!, width: 150, height: 150),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteImage('back'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
