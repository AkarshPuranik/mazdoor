import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazdoor/address_proof.dart';
import 'package:mazdoor/adhar.dart';
import 'package:mazdoor/police_verification.dart';

class DocumentVerificationScreen extends StatefulWidget {
  final String userId;

  const DocumentVerificationScreen({required this.userId});

  @override
  _DocumentVerificationScreenState createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {
  bool aadharCard = false;
  bool addressProof = false;
  bool policeVerification = false;

  Future<void> _saveVerificationData() async {
    await FirebaseFirestore.instance
        .collection('service_user')
        .doc(widget.userId)
        .update({
      'documentVerification': {
        'aadharCard': aadharCard,
        'addressProof': addressProof,
        'policeVerification': policeVerification,
      },
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Document verification saved')));
  }

  void _navigateToScreen(String documentType) {
    Widget screen;

    switch (documentType) {
      case 'Aadhar Card':
        screen = Adhar(); // Navigate to ExampleScreen1
        break;
      case 'Address Proof':
        screen = AddressProof(); // Navigate to ExampleScreen2
        break;
      case 'Police Verification':
        screen = PoliceVerification(); // Navigate to ExampleScreen3
        break;
      default:
        return; // No navigation if the type is unknown
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckboxListTile(
              title: Text("Aadhar Card"),
              value: aadharCard,
              onChanged: (value) {
                setState(() {
                  aadharCard = value!;
                });
                if (value!) {
                  _navigateToScreen("Aadhar Card");
                }
              },
            ),
            CheckboxListTile(
              title: Text("Address Proof"),
              value: addressProof,
              onChanged: (value) {
                setState(() {
                  addressProof = value!;
                });
                if (value!) {
                  _navigateToScreen("Address Proof");
                }
              },
            ),
            CheckboxListTile(
              title: Text("Police Verification"),
              value: policeVerification,
              onChanged: (value) {
                setState(() {
                  policeVerification = value!;
                });
                if (value!) {
                  _navigateToScreen("Police Verification");
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveVerificationData,
              child: Text("Save Verification Data"),
            ),
          ],
        ),
      ),
    );
  }
}
