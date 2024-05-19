import 'package:erp_mob/View/Evenement/total_event_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mob/Model/Evenement.dart';
import '../../Model/User.dart';
import '../../Controller/User_controller.dart';
import '../../Controller/Evenement_controller.dart';

class CreateEventsView extends StatefulWidget {
  @override
  _CreateEventsViewState createState() => _CreateEventsViewState();
}

class _CreateEventsViewState extends State<CreateEventsView> {
  bool isLoading = true;
  User? loggedInUser;
  UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    fetchMeAndEvents();
  }

  void fetchMeAndEvents() async {
    User? user = await userController.getMe();
    if (user != null) {
      print(user.username);
    }
    setState(() {
      loggedInUser = user;
      isLoading = false;
    });
    Provider.of<EvenementController>(context, listen: false)
        .listEvenementsWithParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  TotalEventView(loggedInUser: loggedInUser),
            ),
          );
        },
        label: Row(
          children: [
            Icon(Icons.analytics_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text('Total Événements', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.deepPurple,
      ),
      appBar: AppBar(
        title: Text("Événements"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Consumer<EvenementController>(
              builder: (context, controller, child) {
                return ListView.builder(
                  itemCount: controller.evenements.length,
                  itemBuilder: (context, index) {
                    Evenement event = controller.evenements[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(Icons.event, color: Colors.deepPurple),
                        title: Text(event.titre ?? "Sans titre",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple)),
                        subtitle: Text(
                            "${event.description ?? "Pas de description"}\nLieu: ${event.lieu ?? "Pas de lieu"}",
                            style: TextStyle(color: Colors.black54)),
                        onTap: () => _confirmParticipation(context, event),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _confirmParticipation(BuildContext context, Evenement event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmer la participation"),
        content: Text("Souhaitez-vous participer à '${event.titre}'?"),
        actions: <Widget>[
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Confirmer"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog first
              if (loggedInUser != null &&
                  loggedInUser!.id != null &&
                  event.id != null) {
                try {
                  Provider.of<EvenementController>(context, listen: false)
                      .createDemandeParticipation(loggedInUser!.id!, event.id!)
                      .then((result) {
                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Participation confirmée pour ${event.titre}"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else {
                      throw Exception("Échec de l'inscription.");
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Échec de l'inscription : ${e.toString()}"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Erreur : Identifiants nécessaires non disponibles."),
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
}
