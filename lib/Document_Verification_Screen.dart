import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mazdoor/document_uplaod_screen.dart';

class DocumentVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const DocumentVerificationScreen({super.key, required this.phoneNumber});

  @override
  _DocumentVerificationScreenState createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {
  final List<String> documentTypes = [
    "AadharCard",
    "AddressProof",
    "PoliceVerification"
  ];
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
  }

  Future<Map<String, dynamic>> getDocumentStatus() async {
    if (phoneNumber == null) {
      return {}; // Return an empty map if no phone number is found.
    }

    Map<String, dynamic> documentStatus = {};

    for (var docType in documentTypes) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('service_user')
          .doc(phoneNumber)
          .collection('document_verification')
          .doc(docType)
          .get();

      if (snapshot.exists) {
        documentStatus[docType] = snapshot.data()?['status'] ?? 'pending';
      } else {
        documentStatus[docType] = 'pending';
      }
    }

    return documentStatus;
  }

  Future<void> updateDocumentStatus(String docType, String newStatus) async {
    if (phoneNumber == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('service_user')
          .doc(phoneNumber)
          .collection('document_verification')
          .doc(docType)
          .update({'status': newStatus});
      setState(() {}); // Refresh the UI after updating the status
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status for $docType updated to $newStatus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Document Verification")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getDocumentStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading document statuses"));
          } else {
            Map<String, dynamic> documentStatus = snapshot.data ?? {};

            return ListView.builder(
              itemCount: documentTypes.length,
              itemBuilder: (context, index) {
                String docType = documentTypes[index];
                String status = documentStatus[docType] ?? 'pending';

                return ListTile(
                  title: Text(docType),
                  subtitle: Text('Status: ${status.toUpperCase()}'),
                  trailing: Icon(
                    status == "approved"
                        ? Icons.check_circle
                        : (status == "rejected"
                        ? Icons.cancel
                        : Icons.hourglass_empty),
                    color: status == "approved"
                        ? Colors.green
                        : (status == "rejected" ? Colors.red : Colors.orange),
                  ),
                  onTap: () {
                    // Navigate to DocumentUploadScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocumentUploadScreen(
                          documentType: docType,
                          phoneNumber: phoneNumber!,
                        ),
                      ),
                    ).then((_) {
                      setState(() {}); // Refresh status when returning to this screen
                    });
                  },
                  onLongPress: () {
                    // Show a dialog to update the status
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Update Status for $docType'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('Approve'),
                                leading: Radio<String>(
                                  value: "approved",
                                  groupValue: status,
                                  onChanged: (value) {
                                    Navigator.pop(context);
                                    updateDocumentStatus(docType, "approved");
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text('Reject'),
                                leading: Radio<String>(
                                  value: "rejected",
                                  groupValue: status,
                                  onChanged: (value) {
                                    Navigator.pop(context);
                                    updateDocumentStatus(docType, "rejected");
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text('Pending'),
                                leading: Radio<String>(
                                  value: "pending",
                                  groupValue: status,
                                  onChanged: (value) {
                                    Navigator.pop(context);
                                    updateDocumentStatus(docType, "pending");
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
