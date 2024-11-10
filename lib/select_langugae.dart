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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select Your Language',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'From the below',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16),
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
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color:
              _selectedLanguage == language ? Colors.grey[200] : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: TextStyle(fontSize: 18),
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
