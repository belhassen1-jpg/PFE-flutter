import 'package:erp_mob/Controller/BulletinPaie_controller.dart';
import 'package:erp_mob/Controller/Conge_controller.dart';
import 'package:erp_mob/Controller/Convention_controller.dart';
import 'package:erp_mob/Controller/Demission_controller.dart';
import 'package:erp_mob/Controller/Evenement_controller.dart';
import 'package:erp_mob/Controller/FeuilleTemps_controller.dart';
import 'package:erp_mob/Controller/Finance_controller.dart';
import 'package:erp_mob/Controller/JobApplication_controller.dart';
import 'package:erp_mob/Controller/JobOffer_controller.dart';
import 'package:erp_mob/Controller/Planning_controller.dart';
import 'package:erp_mob/Controller/SessionFormation_controller.dart';
import 'package:erp_mob/Controller/Statistiques_controller.dart';
import 'package:erp_mob/Controller/User_controller.dart';
import 'package:erp_mob/View/User/login.dart';
import 'package:erp_mob/View/dashboard_view_Employe.dart';
import 'package:erp_mob/View/dashboard_view_User.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting('fr_FR', null).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DemandeCongeController()),
          ChangeNotifierProvider(create: (_) => DemissionController()),
          ChangeNotifierProvider(create: (_) => SessionFormationController()),
          ChangeNotifierProvider(create: (_) => EvenementController()),
          ChangeNotifierProvider(create: (_) => ConventionController()),
          ChangeNotifierProvider(create: (_) => FinanceController()),
          ChangeNotifierProvider(create: (_) => UserController()),
          ChangeNotifierProvider(create: (_) => FeuilleTempsController()),
          ChangeNotifierProvider(create: (_) => JobOfferController()),
          ChangeNotifierProvider(create: (_) => JobApplicationController()),
          ChangeNotifierProvider(create: (_) => PaieController()),
          ChangeNotifierProvider(create: (_) => StatisticsController()),
          ChangeNotifierProvider(create: (_) => PlanningController())
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/dashboardEmploye': (context) => DashboardViewEmploye(),
        '/dashboardUser': (context) => DashboardViewUser(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
