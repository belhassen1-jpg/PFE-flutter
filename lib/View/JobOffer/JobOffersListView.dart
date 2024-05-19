import 'package:erp_mob/Controller/JobOffer_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mob/View/JobOffer/JobOfferDetailView.dart'; // Ensure this import is correct

class JobOffersListView extends StatefulWidget {
  @override
  _JobOffersListViewState createState() => _JobOffersListViewState();
}

class _JobOffersListViewState extends State<JobOffersListView> {
  String searchTerm = '';
  @override
  void initState() {
    super.initState();
    Provider.of<JobOfferController>(context, listen: false).getAllJobOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Offers'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black, // Enhancing the AppBar color
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() => searchTerm = value);
                if (value.isEmpty) {
                  Provider.of<JobOfferController>(context, listen: false)
                      .getAllJobOffers();
                } else {
                  Provider.of<JobOfferController>(context, listen: false)
                      .findJobOffersWithFilters(value, null);
                }
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<JobOfferController>(
              builder: (context, controller, child) {
                return ListView.builder(
                  itemCount: controller.jobOffers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(8),
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.work, color: Colors.orangeAccent),
                        title: Text(
                          controller.jobOffers[index].title ?? "No Title",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(
                          controller.jobOffers[index].location ?? "No Location",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 8, 8, 8)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Colors.orangeAccent),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => JobOfferDetailView(
                                  jobOffer: controller.jobOffers[index]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
