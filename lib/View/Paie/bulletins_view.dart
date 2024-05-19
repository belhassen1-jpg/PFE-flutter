import 'package:erp_mob/Controller/BulletinPaie_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mob/Model/BulletinPaie.dart';
import 'package:erp_mob/Model/User.dart';
import 'package:erp_mob/Controller/User_controller.dart';
import 'last_bulletin_paie_view.dart';

class BulletinListView extends StatefulWidget {
  @override
  _BulletinListViewState createState() => _BulletinListViewState();
}

class _BulletinListViewState extends State<BulletinListView> {
  bool isLoading = true;
  User? loggedInUser;
  UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    fetchUserAndBulletins();
  }

  void fetchUserAndBulletins() async {
    User? user = await userController.getMe();
    if (user != null) {
      await Provider.of<PaieController>(context, listen: false)
          .fetchBulletinsForUser(user.id!);
    }
    setState(() {
      loggedInUser = user;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bulletins de paie"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Consumer<PaieController>(
              builder: (context, controller, child) {
                return ListView.builder(
                  itemCount: controller.bulletins.length,
                  itemBuilder: (context, index) {
                    BulletinPaie bulletin = controller.bulletins[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      elevation: 4,
                      child: ListTile(
                        leading:
                            Icon(Icons.monetization_on, color: Colors.green),
                        title: Text(bulletin.nomEntreprise ?? "Aucun nom",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "Date de Paie: ${bulletin.datePaie}\n"
                          "Cotisations Sociales: ${bulletin.cotisationsSociales}€\n"
                          "Heures Supplémentaires: ${bulletin.heuresSupplementaires}\n"
                          "Salaire Net: ${bulletin.salaireNet}€, Salaire Brut: ${bulletin.salaireBrut}€\n"
                          "Début de Période: ${bulletin.periodeDebut}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (loggedInUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LastBulletinView(userId: loggedInUser!.id!),
              ),
            );
          }
        },
        icon: Icon(Icons.visibility),
        label: Text('Voir dernier bulletin'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
