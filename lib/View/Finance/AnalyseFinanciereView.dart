import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Model/Analyse_Financiere.dart';
import '../../Controller/Finance_controller.dart';
import '../../Model/User.dart';
import '../../Controller/User_controller.dart';

class AnalyseFinanciereView extends StatefulWidget {
  @override
  _AnalyseFinanciereViewState createState() => _AnalyseFinanciereViewState();
}

class _AnalyseFinanciereViewState extends State<AnalyseFinanciereView> {
  User? loggedInUser;
  AnalyseFinanciere? analyse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      fetchUserAndAnalyse();
    });
  }

  void fetchUserAndAnalyse() async {
    loggedInUser =
        await Provider.of<UserController>(context, listen: false).getMe();
    if (loggedInUser != null) {
      analyse = await Provider.of<FinanceController>(context, listen: false)
          .obtenirAnalyseFinanciere(loggedInUser!.id!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analyse Financière"),
        backgroundColor: Colors.deepPurple,
      ),
      body: analyse == null
          ? Center(child: CircularProgressIndicator())
          : buildAnalyseCard(),
    );
  }

  Widget buildAnalyseCard() {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle("Résumé"),
              buildSectionContent(analyse!.resume ?? "Aucun résumé disponible"),
              Divider(),
              buildSectionTitle("Recommandations"),
              buildSectionContent(
                  analyse!.recommandations ?? "Aucune recommandation fournie"),
              Divider(),
              buildSectionTitle("Métriques Financières"),
              buildMetric("Taux d'épargne mensuel :",
                  "${analyse!.tauxEpargneMensuel?.toStringAsFixed(2)}%"),
              buildMetric("Dépenses mensuelles moyennes :",
                  "\$${analyse!.depenseMoyenneMensuelle?.toStringAsFixed(2)}"),
              buildMetric("Épargne mensuelle moyenne :",
                  "\$${analyse!.epargneMoyenneMensuelle?.toStringAsFixed(2)}"),
              analyse!.dateAnalyse != null
                  ? buildMetric("Date de l'analyse :",
                      DateFormat('yyyy-MM-dd').format(analyse!.dateAnalyse!))
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.deepPurple));
  }

  Widget buildSectionContent(String content) {
    return Text(content, style: TextStyle(fontSize: 16, height: 1.5));
  }

  Widget buildMetric(String metricName, String value) {
    return Row(
      children: [
        Expanded(
            child: Text(metricName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
