import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazdoor/Document_Verification_Screen.dart';

class OnboardingScreen extends StatelessWidget {
  final String userId;

  OnboardingScreen({required this.userId});

  Future<void> _applyForVerification(BuildContext context) async {
    // Reference to the "onboardingStatus" subcollection inside the user's document
    CollectionReference onboardingStatusCollection = FirebaseFirestore.instance
        .collection('service_user')
        .doc(userId)
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
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DocumentVerificationScreen(userId: userId)),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Bank Details"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to Bank Details screen
              },
            ),
            Divider(),
            ListTile(
              title: Text("Training Module"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to Training Module screen
              },
            ),
            Divider(),
            ListTile(
              title: Text("Verify Vaccination Status"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to Vaccination Status screen
              },
            ),
            Divider(),
            ListTile(
              title: Text("About you"),
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
