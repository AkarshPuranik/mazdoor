import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:mazdoor/Onboarding_Screen.dart';

class UserDetailsFormScreen extends StatefulWidget {
  const UserDetailsFormScreen({super.key});

  @override
  _UserDetailsFormScreenState createState() => _UserDetailsFormScreenState();
}

class _UserDetailsFormScreenState extends State<UserDetailsFormScreen> {
  final _nameController = TextEditingController();
  bool _termsAccepted = false;
  String? phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;

  // Selected values for state and city
  String? _selectedState;
  String? _selectedCity;

  // Fixed country value
  final String _country = "India";

  // Selected work type
  String? _selectedWork;

  // Work options
  final List<String> _workOptions = ['Electrician', 'Plumber', 'Cleaner'];

  Future<void> _saveUserData() async {
    if (phoneNumber != null &&
        _nameController.text.isNotEmpty &&
        _selectedWork != null &&
        _selectedState != null &&
        _selectedCity != null &&
        _termsAccepted) {
      try {
        // Save data to Firestore
        await FirebaseFirestore.instance
            .collection('service_user')
            .doc(phoneNumber)
            .set({
          'name': _nameController.text,
          'work': _selectedWork,
          'city': _selectedCity,
          'state': _selectedState,
          'country': _country,
        });

        // Navigate to onboarding screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving data: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete the form and accept terms.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'images/1.png',
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Let us know you better",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedWork,
                      decoration: InputDecoration(
                        labelText: "Select Work Type",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      ),
                      items: _workOptions.map((work) {
                        return DropdownMenuItem<String>(
                          value: work,
                          child: Text(work),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedWork = value;
                        });
                      },
                      hint: Text("What work do you do?"),
                    ),
                    SizedBox(height: 20),
                    SelectState(
                      onCountryChanged: (value) {
                        // Do nothing, as the country is fixed
                      },
                      onStateChanged: (value) {
                        setState(() {
                          _selectedState = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              _termsAccepted = value!;
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                        Expanded(
                          child: Text(
                            "I accept all Terms & Conditions",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveUserData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
