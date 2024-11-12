import 'package:flutter/material.dart';
import 'package:mazdoor/Hinglish_Screen.dart';
import 'package:mazdoor/hindi_screen.dart';
import 'package:mazdoor/english_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.08,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Select Your Language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'From the below',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.5,
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildLanguageOption('English'),
                    _buildLanguageOption('हिन्दी'),
                    _buildLanguageOption('Hinglish'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (_selectedLanguage != null) {
                // Navigate based on selected language
                switch (_selectedLanguage) {
                  case 'English':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EnglishScreen(),
                      ),
                    );
                    break;
                  case 'हिन्दी':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HindiScreen(),
                      ),
                    );
                    break;
                  case 'Hinglish':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HinglishScreen(),
                      ),
                    );
                    break;
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select a language")),
                );
              }
            },
            child: Text(
              'Proceed',
              style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.04,
        ),
        decoration: BoxDecoration(
          color: _selectedLanguage == language ? Colors.grey[200] : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: TextStyle(fontSize: screenWidth * 0.045),
            ),
            Radio<String>(
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
