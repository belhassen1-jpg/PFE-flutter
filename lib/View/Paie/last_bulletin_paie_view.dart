import 'package:erp_mob/Controller/BulletinPaie_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mob/Model/BulletinPaie.dart';

class LastBulletinView extends StatelessWidget {
  final int userId;

  LastBulletinView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dernier Bulletin de Paie"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<BulletinPaie>(
        future: Provider.of<PaieController>(context, listen: false)
            .fetchLatestBulletinForUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            BulletinPaie bulletin = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailRow(
                      "Nom de l'entreprise:", bulletin.nomEntreprise ?? "N/A"),
                  buildDetailRow("Adresse de l'entreprise:",
                      bulletin.adresseEntreprise ?? "N/A"),
                  buildDetailRow("Date de paie:", bulletin.datePaie.toString()),
                  buildDetailRow("Heures supplémentaires:",
                      "${bulletin.heuresSupplementaires} heures"),
                  buildDetailRow("Salaire net:", "${bulletin.salaireNet}€"),
                  buildDetailRow("Salaire brut:", "${bulletin.salaireBrut}€"),
                  buildDetailRow("Cotisations sociales:",
                      "${bulletin.cotisationsSociales}€"),
                  buildDetailRow(
                      "Impôt sur le revenu:", "${bulletin.impotSurRevenu}€"),
                ],
              ),
            );
          } else {
            return Center(child: Text("Aucune donnée disponible"));
          }
        },
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    fontSize: 16)),
          ),
          Expanded(
            flex: 2,
            child: Text(value,
                style: TextStyle(fontSize: 16, color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}
