import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mazdoor/home_splash.dart';
// import 'package:mazdoor_user/HomePage/homepage.dart';
// import 'package:mazdoor_user/HomePage/services.dart';
// import 'package:mazdoor_user/locationscreen.dart';

class OTP extends StatefulWidget {
  final String verificationId;

  OTP({required this.verificationId});

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  // Method to validate the entered OTP
  Future<void> _validateOTP(BuildContext context) async {
    String enteredOTP = _otpControllers
        .map((controller) => controller.text)
        .join(); // Concatenate OTP from all boxes

    try {
      // Create a credential using the verification ID and the entered OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: enteredOTP,
      );

      // Sign in using the credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // If successful, navigate to the homepage
      if (userCredential.user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeSplash(),
            ));
      }
    } catch (e) {
      // If OTP is incorrect or something goes wrong, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP. Please try again.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Verification code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Please enter the 6-digit code sent',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Container(
                  width: 40,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100, // Lightest orange shade
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1, // Allow only 1 digit per box
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        // Move to the next box if the current one is filled
                        FocusScope.of(context)
                            .requestFocus(_focusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        // Move to the previous box if current is empty
                        FocusScope.of(context)
                            .requestFocus(_focusNodes[index - 1]);
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _validateOTP(
                    context); // Call the Firebase OTP validation method
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
