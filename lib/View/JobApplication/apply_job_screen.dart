import 'dart:io';

import 'package:erp_mob/Controller/JobApplication_controller.dart';
import 'package:erp_mob/Model/JobApplication.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ApplyJobScreen extends StatefulWidget {
  final int jobOfferId;

  const ApplyJobScreen({Key? key, required this.jobOfferId}) : super(key: key);

  @override
  _ApplyJobScreenState createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  PlatformFile? _resumeFile;
  PlatformFile? _coverLetterFile;

  Future<void> _pickFile(bool isResume) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        if (isResume) {
          _resumeFile = result.files.first;
        } else {
          _coverLetterFile = result.files.first;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for Job"),
      ),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'applicantName',
                decoration: InputDecoration(labelText: 'Name'),
              ),
              FormBuilderTextField(
                name: 'applicantEmail',
                decoration: InputDecoration(labelText: 'Email'),
              ),
              FormBuilderTextField(
                name: 'applicantPhone',
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              FormBuilderTextField(
                name: 'applicantAddress',
                decoration: InputDecoration(labelText: 'Address'),
              ),
              FormBuilderTextField(
                name: 'yearsOfExperience',
                decoration: InputDecoration(labelText: 'Years of Experience'),
              ),
              ListTile(
                title: Text(_resumeFile?.name ?? "No file selected"),
                leading: Icon(Icons.attach_file),
                onTap: () => _pickFile(true),
                subtitle: Text('Tap to pick resume'),
              ),
              ListTile(
                title: Text(_coverLetterFile?.name ?? "No file selected"),
                leading: Icon(Icons.attach_file),
                onTap: () => _pickFile(false),
                subtitle: Text('Tap to pick cover letter'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitApplication,
                child: Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitApplication() async {
    if (_formKey.currentState!.saveAndValidate()) {
      var formData = _formKey.currentState!.value;
      var resumeFile = File(_resumeFile!.path!);
      var coverLetterFile = File(_coverLetterFile!.path!);

      var applicationDto = {
        'applicantName': formData['applicantName'],
        'applicantEmail': formData['applicantEmail'],
        'applicantPhone': formData['applicantPhone'],
        'applicantAddress': formData['applicantAddress'],
        'yearsOfExperience': formData['yearsOfExperience'],
      };

      var controller =
          Provider.of<JobApplicationController>(context, listen: false);
      JobApplication? application = await controller.submitApplication(
        jobOfferId: widget.jobOfferId,
        userId: 4, // You need to determine how to get/set the userId
        resume: resumeFile,
        coverLetter: coverLetterFile,
        applicationDto: applicationDto,
      );

      if (application != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Application submitted successfully!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit application.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
