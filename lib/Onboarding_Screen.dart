import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazdoor/Document_Verification_Screen.dart';

class OnboardingScreen extends StatelessWidget {
  final String phoneNumber;

  OnboardingScreen({required this.phoneNumber});

  Future<void> _applyForVerification(BuildContext context) async {
    String? phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
    CollectionReference onboardingStatusCollection = FirebaseFirestore.instance
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
                      },
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                    ElevatedButton(
                      onPressed: () => _applyForVerification(context),
                      child: Text("Apply for verification", style: TextStyle(fontSize: fontSizeMedium)),
                    ),
                    SizedBox(height: deviceHeight * 0.01),
                    Text(
                      "Usually verification happens within 72 hours. You may still use the app with limited access.",
                      style: TextStyle(fontSize: fontSizeSmall, color: Colors.grey),
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
