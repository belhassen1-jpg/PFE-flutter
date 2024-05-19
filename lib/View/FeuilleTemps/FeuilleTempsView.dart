import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Controller/FeuilleTemps_controller.dart';
import '../../Controller/Planning_controller.dart';
import '../../Controller/User_controller.dart';
import '../../Model/FeuilleTemps.dart';
import '../../Model/Planning.dart';
import '../../Model/User.dart';

class FeuilleTempsView extends StatefulWidget {
  @override
  _FeuilleTempsViewState createState() => _FeuilleTempsViewState();
}

class _FeuilleTempsViewState extends State<FeuilleTempsView> {
  final _formKey = GlobalKey<FormState>();
  List<Planning>? _planning;
  bool isLoading = false;
  bool isLoadingFeuille = false;

  User? loggedInUser;
  List<FeuilleTemps>? _feuilleTemps;

  @override
  void initState() {
    fetch();
    fetchPlanning();
    super.initState();
  }

  fetchPlanning() async {
    setState(() {
      isLoading = true;
    });

    _planning = await Provider.of<PlanningController>(context, listen: false)
        .obtenirTousLesPlanningsAvecDetails();

    setState(() {
      isLoading = false;
    });
  }

  void fetch() async {
    setState(() {
      isLoadingFeuille = true;
    });

    loggedInUser =
        await Provider.of<UserController>(context, listen: false).getMe();

    if (loggedInUser != null) {
      await Provider.of<FeuilleTempsController>(context, listen: false)
          .getFeuilleTempsForUser(loggedInUser!.id!, context);
    }

    setState(() {
      isLoadingFeuille = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Sheet Management"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<FeuilleTempsController>(
        builder: (context, controller, child) {
          return isLoadingFeuille
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: controller.feuilleTempsList.length,
                  itemBuilder: (context, index) {
                    FeuilleTemps feuilleTemps =
                        controller.feuilleTempsList[index];
                    String formattedDate = feuilleTemps.jour != null
                        ? DateFormat('yyyy-MM-dd').format(feuilleTemps.jour!)
                        : 'No Date';
                    String formattedHeureDebut = feuilleTemps.heureDebut != null
                        ? DateFormat('HH:mm').format(feuilleTemps.heureDebut!)
                        : 'N/A';
                    String formattedHeureFin = feuilleTemps.heureFin != null
                        ? DateFormat('HH:mm').format(feuilleTemps.heureFin!)
                        : 'N/A';

                    return Card(
                      margin: EdgeInsets.all(8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(feuilleTemps.planningName ?? "No Project"),
                        subtitle: Text(
                            '$formattedDate, Hours: $formattedHeureDebut - $formattedHeureFin'),
                        trailing: Text(feuilleTemps.estApprouve ?? false
                            ? "Approved"
                            : "Pending"),
                        leading: CircleAvatar(
                          backgroundColor: feuilleTemps.estApprouve ?? false
                              ? Colors.green
                              : Colors.red,
                          child: Icon(
                            feuilleTemps.estApprouve ?? false
                                ? Icons.check
                                : Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFeuilleTempsDialog(context),
        tooltip: 'Add Time Sheet',
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showAddFeuilleTempsDialog(BuildContext context) {
    TextEditingController _jourController = TextEditingController();
    TextEditingController _heureDebutController = TextEditingController();
    TextEditingController _heureFinController = TextEditingController();
    int? selectedPlanningId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Add New Time Sheet"),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: 250,
                              child: DropdownButtonFormField<int>(
                                hint: Text("Planning"),
                                isExpanded: true,
                                value: selectedPlanningId,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedPlanningId = newValue;
                                  });
                                },
                                items: _planning?.map((Planning planning) {
                                      return DropdownMenuItem<int>(
                                        value: planning.id,
                                        child: Flexible(
                                          child: Text(planning.nomProjet ??
                                              "No Project"),
                                        ),
                                      );
                                    }).toList() ??
                                    [],
                              ),
                            ),
                      TextFormField(
                        controller: _jourController,
                        decoration: InputDecoration(labelText: 'Day'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            _jourController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                      ),
                      TextFormField(
                        controller: _heureDebutController,
                        decoration: InputDecoration(labelText: 'Start Time'),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            final now = DateTime.now();
                            // Créer un DateTime en utilisant le fuseau horaire local
                            final dateTime = DateTime(now.year, now.month,
                                now.day, pickedTime.hour, pickedTime.minute);
                            // Formater pour l'affichage ou l'envoi
                            _heureDebutController.text =
                                DateFormat('HH:mm').format(dateTime);
                          }
                        },
                      ),
                      TextFormField(
                        controller: _heureFinController,
                        decoration: InputDecoration(labelText: 'End Time'),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour: 17, minute: 0), // Default to 5:00 PM
                          );
                          if (pickedTime != null) {
                            final now = DateTime.now();
                            final dateTime = DateTime(now.year, now.month,
                                now.day, pickedTime.hour, pickedTime.minute);
                            final formattedTime = DateFormat('HH:mm')
                                .format(dateTime); // Using 24-hour format
                            _heureFinController.text = formattedTime;
                            // Ensure the UI refreshes to display the new time
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Conversion des champs de temps et date
                      DateTime? jour = _jourController.text.isNotEmpty
                          ? DateTime.tryParse(_jourController.text)
                          : null;
                      DateTime? heureDebut =
                          _heureDebutController.text.isNotEmpty
                              ? DateTime.tryParse(
                                  "2000-01-01 " + _heureDebutController.text)
                              : null;
                      DateTime? heureFin = _heureFinController.text.isNotEmpty
                          ? DateTime.tryParse(
                              "2000-01-01 " + _heureFinController.text)
                          : null;

                      // Création de l'objet FeuilleTemps
                      FeuilleTemps newFeuilleTemps = FeuilleTemps(
                        planningId: selectedPlanningId,
                        jour: jour,
                        heureDebut: heureDebut,
                        heureFin: heureFin,
                        // Vous devez adapter selon les champs de votre modèle FeuilleTemps
                      );

                      // Appel à la méthode du controller pour ajouter la feuille de temps
                      FeuilleTemps? addedFeuilleTemps =
                          await Provider.of<FeuilleTempsController>(context,
                                  listen: false)
                              .createAndAssociateFeuilleTemps(
                                  selectedPlanningId!,
                                  loggedInUser!.id!,
                                  newFeuilleTemps,
                                  context);

                      // Fermer le dialogue et actualiser si ajout réussi
                      if (addedFeuilleTemps != null) {
                        Navigator.of(context).pop();
                        fetch(); // Rafraîchir la liste des feuilles de temps
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
