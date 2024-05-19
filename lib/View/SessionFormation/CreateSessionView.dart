import 'package:erp_mob/Controller/SessionFormation_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mob/Model/SessionFormation.dart';
import '../../Model/User.dart';
import '../../Controller/User_controller.dart';

class CreateSessionsView extends StatefulWidget {
  @override
  _CreateSessionsViewState createState() => _CreateSessionsViewState();
}

class _CreateSessionsViewState extends State<CreateSessionsView> {
  bool isLoading = true;
  User? loggedInUser;
  UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    fetchMe();
  }

  void fetchMe() async {
    User? user = await userController.getMe();
    if (user != null) {
      print(user.username);
    }
    setState(() {
      loggedInUser = user;
      isLoading = false;
    });
    // Fetch all sessions once the user data is fetched
    Provider.of<SessionFormationController>(context, listen: false)
        .fetchAllSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sessions de Formation"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Consumer<SessionFormationController>(
              builder: (context, controller, child) {
                return ListView.builder(
                  itemCount: controller.sessions.length,
                  itemBuilder: (context, index) {
                    SessionFormation session = controller.sessions[index];
                    return Card(
                      child: ListTile(
                        // Add a leading icon based on the session theme
                        leading: Icon(
                          Icons
                              .school, // Replace with a more relevant icon based on session theme
                          color: Colors.deepPurple,
                        ),
                        title: Text(
                          session.intitule ?? "Pas de Titre",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text(session.description ?? "Pas de Description"),
                        trailing: Text(session.lieu ?? "Pas de Lieu"),
                        onTap: () => _confirmParticipation(context, session),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _confirmParticipation(BuildContext context, SessionFormation session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmer la participation"),
        content: Text("Souhaitez-vous participer à '${session.intitule}'?"),
        actions: <Widget>[
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Confirmer"),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog first
              if (loggedInUser != null && loggedInUser?.id != null) {
                try {
                  await Provider.of<SessionFormationController>(context,
                          listen: false)
                      .inscribeEmployeeToSession(
                          session.id!, loggedInUser!.id!);
                  // After successful registration show the SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Inscription confirmée pour ${session.intitule}"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } catch (e) {
                  // Handle errors if any during the inscription
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Échec d'inscription: ${e.toString()}"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              } else {
                // Handle the case where user ID is null
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Erreur: l'identifiant d'utilisateur n'est pas disponible."),
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
