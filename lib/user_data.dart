import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazdoor/location_screen.dart';

class UserDetailsFormScreen extends StatefulWidget {
  @override
  _UserDetailsFormScreenState createState() => _UserDetailsFormScreenState();
}

class _UserDetailsFormScreenState extends State<UserDetailsFormScreen> {
  final _nameController = TextEditingController();
  final _workController = TextEditingController();
  final _cityController = TextEditingController();
  bool _termsAccepted = false;

  Future<void> _saveUserData() async {
    String? phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
    if (phoneNumber != null &&
        _nameController.text.isNotEmpty &&
        _workController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _termsAccepted) {
      // Save user data to Firestore using phone number as document ID
      await FirebaseFirestore.instance
          .collection('service_user')
          .doc(phoneNumber)
          .set({
        'name': _nameController.text,
        'work': _workController.text,
        'city': _cityController.text,
      });

      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LocationScreen()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete the form and accept terms.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 90,
              child: Image.asset(
                'images/1.png',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Let's know you more", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _workController,
              decoration: InputDecoration(labelText: "What work you do"),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: "City of your resident"),
            ),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _termsAccepted = value!;
                    });
                  },
                ),
                Expanded(child: Text("You accept all the Terms & Conditions")),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
