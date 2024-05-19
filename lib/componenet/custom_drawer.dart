import 'package:erp_mob/View/Conge/create_demande_conge_view.dart';
import 'package:erp_mob/View/Convention/CreateConventionsView.dart';
import 'package:erp_mob/View/Demission/create_demission_view.dart';
import 'package:erp_mob/View/Evenement/CreateEventView.dart';
import 'package:erp_mob/View/FeuilleTemps/FeuilleTempsView.dart';
import 'package:erp_mob/View/Finance/AnalyseFinanciereView.dart';
import 'package:erp_mob/View/Finance/DepensesView.dart';
import 'package:erp_mob/View/Finance/ObjectifsEpargneView.dart';
import 'package:erp_mob/View/JobApplication/JobApplicationsView.dart';
import 'package:erp_mob/View/JobOffer/JobOffersListView.dart';
import 'package:erp_mob/View/Paie/bulletins_view.dart';
import 'package:erp_mob/View/SessionFormation/CreateSessionView.dart';
import 'package:erp_mob/View/User/login.dart';
import 'package:erp_mob/View/contact_us_view.dart';
import 'package:erp_mob/View/dashboard_view_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/User.dart';

void clearLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Widget customDrawer(
    BuildContext context, String _userRole, User? loggedInUser) {
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          color: Colors.black,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/user-1.jpg'),
              ),
              SizedBox(
                height: 20,
              ),
              loggedInUser != null
                  ? Text(
                      '${loggedInUser?.firstName ?? ''} ${loggedInUser?.lastName ?? ''}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loggedInUser?.email ?? '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      // Implement logout functionality
                      clearLocalStorage();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        if (_userRole == 'Employee') ...[
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: const Text('Dépenses'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DepensesView()));
            },
          ),
          ListTile(
            leading: Icon(Icons.trending_up),
            title: const Text('Objectifs Épargne'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ObjectifsEpargneView()));
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: const Text('Analyse Financier'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AnalyseFinanciereView()));
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: const Text('Feuille de Temps'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FeuilleTempsView()));
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: const Text('Bulletin Paie'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BulletinListView()));
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: const Text('Formation List'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateSessionsView()));
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: const Text('Event List'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateEventsView()));
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: const Text('Convention List'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateConventionsView()));
            },
          ),
          ListTile(
            leading: Icon(Icons.beach_access_rounded),
            title: const Text('Demande de Conge'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateDemandeCongeView()));
              // Add navigation code for Convention List page
            },
          ),
          ListTile(
            leading: Icon(Icons.add_alert),
            title: const Text('Demande de Demission'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateDemissionView()));
              // Add navigation code for Convention List page
            },
          ),
        ],
        if (_userRole == 'User') ...[
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DashboardViewUser()));
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DashboardViewUser()));
            },
          ),
          ListTile(
            leading: Icon(Icons.contacts),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ContactUsView()));
            },
          ),
          ListTile(
            leading: Icon(Icons.work_outline),
            title: const Text('Job Offers'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => JobOffersListView()));
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_turned_in),
            title: const Text('My Application'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => JobApplicationsView()));
            },
          ),
        ]
      ],
    ),
  );
}
