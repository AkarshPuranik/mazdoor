import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazdoor/Document_Verification_Screen.dart';

class OnboardingScreen extends StatelessWidget {
  final String phoneNumber;

  OnboardingScreen({required this.phoneNumber});

  Future<void> _applyForVerification(BuildContext context) async {
    String? phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
    // Reference to the "onboardingStatus" subcollection inside the user's document
    CollectionReference onboardingStatusCollection = FirebaseFirestore.instance
        .collection('service_user')
        .doc(phoneNumber)
        .collection('onboardingStatus');

    // Set the onboarding status data in the subcollection
    await onboardingStatusCollection.doc('status').set({
      'documentVerification': 'Complete',
      'bankDetails': 'Complete',
      'trainingModule': 'In Progress',
      'vaccinationStatus': 'Verified',
      'aboutYou': 'Short description here',
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Verification status updated")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Onboarding"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text("Document Verification"),
              subtitle: Text(
                "Police Verification, Pan Card, Aadhar card, Driving License,",
                style: TextStyle(fontSize: 10),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DocumentVerificationScreen(
                            phoneNumber: phoneNumber,
                          )),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Bank Details"),
              subtitle: Text(
                "Add your bank Details",
                style: TextStyle(fontSize: 10),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to Bank Details screen
              },
            ),
            Divider(),
            ListTile(
              title: Text("Training Module"),
              subtitle: Text(
                "Some Basic training modules for skill development",
                style: TextStyle(fontSize: 10),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to Training Module screen
              },
            ),
            Divider(),
            ListTile(
              title: Text("Verify Vaccination Status"),
              subtitle: Text(
                "Health Safety",
                style: TextStyle(fontSize: 10),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to Vaccination Status screen
              },
            ),
            Divider(),
            ListTile(
              title: Text("About you"),
              subtitle: Text(
                "Lets know more about you",
                style: TextStyle(fontSize: 10),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to About You screen
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _applyForVerification(context),
              child: Text("Apply for verification"),
            ),
            SizedBox(height: 10),
            Text(
              "Usually verification happens within 72 hours. You may still use the app with limited access.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: "Contact EM",
          ),
        ],
      ),
    );
  }
}
