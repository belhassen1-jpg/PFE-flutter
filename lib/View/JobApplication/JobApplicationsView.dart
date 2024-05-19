import 'package:erp_mob/Controller/JobApplication_controller.dart';
import 'package:erp_mob/Controller/User_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mob/Model/JobApplication.dart';

class JobApplicationsView extends StatefulWidget {
  @override
  _JobApplicationsViewState createState() => _JobApplicationsViewState();
}

class _JobApplicationsViewState extends State<JobApplicationsView> {
  bool isLoading = true;
  List<JobApplication> applications = [];

  @override
  void initState() {
    super.initState();
    fetchUserAndApplications();
  }

  void fetchUserAndApplications() async {
    setState(() => isLoading = true);
    UserController userController =
        Provider.of<UserController>(context, listen: false);
    userController.getMe().then((loggedInUser) {
      if (loggedInUser != null && loggedInUser.id != null) {
        Provider.of<JobApplicationController>(context, listen: false)
            .getApplicationsByUserId(loggedInUser.id!)
            .then((fetchedApplications) {
          setState(() {
            applications = fetchedApplications;
            isLoading = false;
          });
        }).catchError((error) {
          print("Error fetching applications: $error");
          setState(() => isLoading = false);
        });
      } else {
        print("User is not logged in or ID is null");
        setState(() => isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Job Applications'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : applications.isEmpty
              ? Center(
                  child: Text("No applications found.",
                      style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
                  itemCount: applications.length,
                  itemBuilder: (context, index) =>
                      _buildJobApplicationCard(applications[index]),
                ),
    );
  }

  Widget _buildJobApplicationCard(JobApplication application) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(application.applicantName ?? 'Unknown Applicant',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  )),
              SizedBox(height: 10),
              Text(
                  'Job Offer: ${application.jobOffer?.title ?? "Not specified"}', // Ensure you have this field or object available
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  )),
              SizedBox(height: 10),
              Text('Email: ${application.applicantEmail ?? "Not specified"}',
                  style: TextStyle(fontSize: 16)),
              Text('Phone: ${application.applicantPhone ?? "Not specified"}',
                  style: TextStyle(fontSize: 16)),
              Text(
                  'Address: ${application.applicantAddress ?? "Not specified"}',
                  style: TextStyle(fontSize: 16)),
              Text(
                  'Years of Experience: ${application.yearsOfExperience?.toString() ?? "Not specified"}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orangeAccent,
                  ),
                  onPressed: () {
                    // Add your onTap functionality here
                  },
                  child: Text(
                    application.status == null
                        ? 'EN ATTENTE'
                        : application.status!.name.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
