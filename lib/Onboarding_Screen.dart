import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazdoor/Document_Verification_Screen.dart';
import 'package:mazdoor/home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  String phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
  String userId = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';

  OnboardingScreen({
    super.key,
  });

  Future<void> checkDocumentStatuses(BuildContext context) async {
    try {
      // Fetch the statuses of required documents
      final aadharDoc = await FirebaseFirestore.instance
          .collection('service_user')
          .doc(userId)
          .collection('document_verification')
          .doc('AadharCard')
          .get();
      final addressProofDoc = await FirebaseFirestore.instance
          .collection('service_user')
          .doc(userId)
          .collection('document_verification')
          .doc('AddressProof')
          .get();
      final policeVerificationDoc = await FirebaseFirestore.instance
          .collection('service_user')
          .doc(userId)
          .collection('document_verification')
          .doc('PoliceVerification')
          .get();

      // Print the fetched data in the debug console for debugging
      print("AadharCard: ${aadharDoc.data()}");
      print("AadharCard Status: ${aadharDoc['status']}");
      print("AddressProof: ${addressProofDoc.data()}");
      print("AddressProof Status: ${addressProofDoc['status']}");
      print("PoliceVerification: ${policeVerificationDoc.data()}");
      print("PoliceVerification Status: ${policeVerificationDoc['status']}");

      // Check if all statuses are 'approved'
      if (aadharDoc.exists &&
          addressProofDoc.exists &&
          policeVerificationDoc.exists &&
          aadharDoc['status']?.toLowerCase() == 'approved' &&
          addressProofDoc['status']?.toLowerCase() == 'approved' &&
          policeVerificationDoc['status']?.toLowerCase() == 'approved') {
        // All documents approved, navigate directly to home screen
        print("All documents are approved. Navigating to home screen...");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Show a message if any document is not approved
        print("Not all documents are approved.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All documents must be approved!')),
        );
      }
    } catch (e) {
      print('Error checking document statuses: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking document statuses.')),
      );
    }
  }

  // Function to apply for verification and update onboarding status
  Future<void> _applyForVerification(BuildContext context) async {
    String phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in. Please log in again.")),
      );
      return;
    }

    try {
      // Set onboarding status in Firestore
      CollectionReference onboardingStatusCollection = FirebaseFirestore
          .instance
          .collection('service_user')
          .doc(phoneNumber)
          .collection('onboardingStatus');

      await onboardingStatusCollection.doc('status').set({
        'documentVerification': 'Complete',
        'bankDetails': 'Complete',
        'trainingModule': 'In Progress',
        'vaccinationStatus': 'Verified',
        'aboutYou': 'Short description here',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification status updated")),
      );

      // After updating, check document statuses
      await checkDocumentStatuses(context);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating verification status.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceWidth = mediaQuery.size.width;
    final deviceHeight = mediaQuery.size.height;
    final double padding = deviceWidth * 0.04;
    final double fontSizeSmall = deviceWidth * 0.025;
    final double fontSizeMedium = deviceWidth * 0.045;

    return Scaffold(
      appBar: AppBar(
        title: Text("Onboarding", style: TextStyle(fontSize: fontSizeMedium)),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text(
                        "Document Verification",
                        style: TextStyle(fontSize: fontSizeMedium),
                      ),
                      subtitle: Text(
                        "Police Verification, Pan Card, Aadhar card, Driving License",
                        style: TextStyle(fontSize: fontSizeSmall),
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
                      title: Text(
                        "Bank Details",
                        style: TextStyle(fontSize: fontSizeMedium),
                      ),
                      subtitle: Text(
                        "Add your bank details",
                        style: TextStyle(fontSize: fontSizeSmall),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to Bank Details screen
                        // Implement the navigation
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "Training Module",
                        style: TextStyle(fontSize: fontSizeMedium),
                      ),
                      subtitle: Text(
                        "Basic training modules for skill development",
                        style: TextStyle(fontSize: fontSizeSmall),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to Training Module screen
                        // Implement the navigation
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "Verify Vaccination Status",
                        style: TextStyle(fontSize: fontSizeMedium),
                      ),
                      subtitle: Text(
                        "Health Safety",
                        style: TextStyle(fontSize: fontSizeSmall),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to Vaccination Status screen
                        // Implement the navigation
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "About You",
                        style: TextStyle(fontSize: fontSizeMedium),
                      ),
                      subtitle: Text(
                        "Let's know more about you",
                        style: TextStyle(fontSize: fontSizeSmall),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to About You screen
                        // Implement the navigation
                      },
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                    ElevatedButton(
                      onPressed: () => checkDocumentStatuses(context),
                      child: Text("Apply for verification",
                          style: TextStyle(fontSize: fontSizeMedium)),
                    ),
                    SizedBox(height: deviceHeight * 0.01),
                    Text(
                      "Usually verification happens within 72 hours. You may still use the app with limited access.",
                      style: TextStyle(
                          fontSize: fontSizeSmall, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: deviceWidth * 0.07),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail, size: deviceWidth * 0.07),
            label: "Contact EM",
          ),
        ],
        selectedFontSize: fontSizeSmall,
        unselectedFontSize: fontSizeSmall,
      ),
    );
  }
}
