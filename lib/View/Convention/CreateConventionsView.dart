import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:erp_mob/Model/Convention.dart';
import '../../Model/User.dart';
import '../../Controller/User_controller.dart';
import '../../Controller/Convention_controller.dart';
import 'package:intl/intl.dart';

class CreateConventionsView extends StatefulWidget {
  @override
  _CreateConventionsViewState createState() => _CreateConventionsViewState();
}

class _CreateConventionsViewState extends State<CreateConventionsView> {
  bool isLoading = true;
  User? loggedInUser;
  UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null); // Initialize date formatting
    fetchMeAndConventions();
  }

  void fetchMeAndConventions() async {
    User? user = await userController.getMe();
    setState(() {
      loggedInUser = user;
      isLoading = false;
    });
    if (user != null) {
      Provider.of<ConventionController>(context, listen: false)
          .listerConventionsAvecParticipants();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conventions"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Consumer<ConventionController>(
              builder: (context, controller, child) {
                return ListView.builder(
                  itemCount: controller.conventions.length,
                  itemBuilder: (context, index) {
                    Convention convention = controller.conventions[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 5,
                      child: ListTile(
                        leading:
                            Icon(Icons.event_note, color: Colors.deepPurple),
                        title: Text(convention.nom ?? "Pas de nom",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            "Objet : ${convention.objet ?? "Pas de description"}\nDates : ${_formatDateRange(convention.dateDebut, convention.dateFin)}"),
                        onTap: () => _confirmParticipation(context, convention),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _confirmParticipation(BuildContext context, Convention convention) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmer la participation"),
        content: Text("Voulez-vous participer à '${convention.nom}' ?"),
        actions: <Widget>[
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Confirmer"),
            onPressed: () {
              Navigator.of(context).pop();
              if (loggedInUser != null &&
                  loggedInUser!.id != null &&
                  convention.id != null) {
                Provider.of<ConventionController>(context, listen: false)
                    .creerDemandeParticipation(
                        loggedInUser!.id!, convention.id!)
                    .then((result) {
                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Participation confirmée pour ${convention.nom}"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Échec de l'inscription."),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Erreur : Les identifiants nécessaires ne sont pas disponibles."),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return "Informations sur la date non disponibles";
    }
    return "${DateFormat('dd MMM yyyy', 'fr_FR').format(start)} - ${DateFormat('dd MMM yyyy', 'fr_FR').format(end)}";
  }
}
