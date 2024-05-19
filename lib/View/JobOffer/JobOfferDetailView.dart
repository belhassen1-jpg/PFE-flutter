import 'package:erp_mob/View/JobApplication/apply_job_screen.dart';
import 'package:flutter/material.dart';
import 'package:erp_mob/Model/JobOffer.dart'; // Assuming this is your model's location

class JobOfferDetailView extends StatelessWidget {
  final JobOffer jobOffer;

  JobOfferDetailView({required this.jobOffer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobOffer.title ?? "Job Offer Details"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(10),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  jobOffer.title ?? "No Title",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  jobOffer.location ?? "No Location",
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 7, 6, 6),
                  ),
                ),
              ),
              Divider(),
              _buildDetailItem(
                  "Category", jobOffer.category ?? "Not specified"),
              _buildDetailItem(
                  "Keywords", jobOffer.keywords?.join(', ') ?? "Not specified"),
              _buildDetailItem(
                  "Required Years", "${jobOffer.requiredExperienceYears}"),
              _buildDetailItem("Salary", "\$${jobOffer.salary}"),
              Divider(),
              _buildDetailItem("Description",
                  jobOffer.description ?? "No description provided."),
              Divider(),
              _buildDetailItem("Project Details",
                  jobOffer.projectDetails ?? "No project details provided."),
              Divider(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orangeAccent,
                  ),
                  onPressed: () => _navigateToApplyScreen(context),
                  child: Text('Apply'),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToApplyScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ApplyJobScreen(jobOfferId: jobOffer.id!),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: const Color.fromARGB(255, 8, 8, 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
