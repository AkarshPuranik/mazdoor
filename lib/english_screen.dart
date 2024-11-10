import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor/otp.dart';

class EnglishScreen extends StatefulWidget {
  const EnglishScreen({super.key});

  @override
  State<EnglishScreen> createState() => _EnglishScreenState();
}

class _EnglishScreenState extends State<EnglishScreen> {
  final TextEditingController _phoneController = TextEditingController();
  var phone = "";
  bool _isValidNumber = false;

  void _checkPhoneNumber(String value) {
    setState(() {
      phone = value; // Update the phone variable with the entered value
      _isValidNumber = RegExp(r'^\d{10}$')
          .hasMatch(value); // Check if it's a 10-digit number
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: 670,
            child: Image.asset(
              'images/people.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: SizedBox(
              height: 150,
              child: Image.asset(
                'images/1.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'WelcomeMazdoor App',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.black, // Change color if needed
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      // Country code input field
                      Expanded(
                        flex: 1,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '+91', // Country code
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Phone number input field
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          onChanged: _checkPhoneNumber,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your mobile number',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // "Continue" button
                  SizedBox(
                    width: double.infinity, // Button covers the full width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Black background color
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _isValidNumber
                          ? () async {
                              // Prepare the full phone number
                              String fullPhoneNumber = '+91$phone';

                              // Start verification
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: fullPhoneNumber,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {
                                  FirebaseAuth.instance
                                      .signInWithCredential(credential);
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Verification failed: ${e.message}'),
                                    ),
                                  );
                                },
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OTP(verificationId: verificationId),
                                    ),
                                  );
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {
                                  print(
                                      'Code auto retrieval timeout: $verificationId');
                                },
                              );
                            }
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please enter a valid 10-digit number'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
