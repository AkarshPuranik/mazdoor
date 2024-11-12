import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mazdoor/document_uplaod_screen.dart';

class DocumentVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const DocumentVerificationScreen({super.key, required this.phoneNumber});

  @override
  _DocumentVerificationScreenState createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {
  final List<String> documentTypes = [
    "AadharCard",
    "AddressProof",
    "PoliceVerification"
  ];
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
  }

  Future<Map<String, bool>> getDocumentStatus() async {
    if (phoneNumber == null) {
      return {}; // Return an empty map if no phone number is found.
    }

    Map<String, bool> documentStatus = {};

    for (var docType in documentTypes) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('service_user')
          .doc(phoneNumber)
          .collection('document_verification')
          .doc(docType)
          .get();

      bool isUploaded = snapshot.exists &&
          snapshot.data()?['frontImageUrl'] != null &&
          snapshot.data()?['backImageUrl'] != null;

      documentStatus[docType] = isUploaded;
    }

    return documentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Document Verification")),
      body: FutureBuilder<Map<String, bool>>(
        future: getDocumentStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading document statuses"));
          } else {
            Map<String, bool> documentStatus = snapshot.data ?? {};

            return ListView.builder(
              itemCount: documentTypes.length,
              itemBuilder: (context, index) {
                String docType = documentTypes[index];
                bool isUploaded = documentStatus[docType] ?? false;

                return ListTile(
                  title: Text(docType),
                  trailing: Icon(
                    isUploaded ? Icons.check_circle : Icons.cancel,
                    color: isUploaded ? Colors.green : Colors.red,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocumentUploadScreen(
                          documentType: docType,
                          phoneNumber: phoneNumber!,
                        ),
                      ),
                    ).then((_) {
                      setState(
                          () {}); // Refresh status when returning to this screen.
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
