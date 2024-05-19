import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Model/ObjectifEpargne.dart';
import '../../Model/User.dart';
import '../../Controller/User_controller.dart';
import '../../Controller/Finance_controller.dart';

class ObjectifsEpargneView extends StatefulWidget {
  @override
  _ObjectifsEpargneViewState createState() => _ObjectifsEpargneViewState();
}

class _ObjectifsEpargneViewState extends State<ObjectifsEpargneView> {
  User? loggedInUser;
  UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    fetchUserAndObjectifs();
  }

  void fetchUserAndObjectifs() async {
    User? user = await userController.getMe();
    if (user != null) {
      Provider.of<FinanceController>(context, listen: false)
          .listerObjectifsEpargne(user.id!);
    }
    setState(() {
      loggedInUser = user;
    });
  }

  void _showAddObjectifDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        double objectifMontant = 0.0;
        String description = '';
        TextEditingController _startDateController = TextEditingController();
        TextEditingController _endDateController = TextEditingController();

        return AlertDialog(
          title: Text("Ajouter un nouvel objectif d'épargne"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Montant de l\'objectif'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le montant de l\'objectif est requis.';
                      }
                      return null;
                    },
                    onSaved: (value) => objectifMontant = double.parse(value!),
                  ),
                  TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(labelText: 'Date de début'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La date de début est requise.';
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        _startDateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  ),
                  TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(labelText: 'Date de fin'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La date de fin est requise.';
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        _endDateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Une description est requise.';
                      }
                      return null;
                    },
                    onSaved: (value) => description = value!,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (loggedInUser != null) {
                    ObjectifEpargne newObjectif = ObjectifEpargne(
                      objectifMontant: objectifMontant,
                      description: description,
                      dateDebut: DateFormat('yyyy-MM-dd')
                          .parse(_startDateController.text),
                      dateFin: DateFormat('yyyy-MM-dd')
                          .parse(_endDateController.text),
                      employeId: loggedInUser!.id,
                    );
                    Provider.of<FinanceController>(context, listen: false)
                        .ajouterObjectifEpargne(
                            loggedInUser!.id!, newObjectif, context)
                        .then((_) {
                      Navigator.of(context).pop();
                      fetchUserAndObjectifs(); // Refresh the list after adding
                    });
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des Objectifs d'Épargne"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<FinanceController>(
        builder: (context, controller, child) {
          return ListView.builder(
            itemCount: controller.objectifsEpargne?.length ?? 0,
            itemBuilder: (context, index) {
              ObjectifEpargne objectif = controller.objectifsEpargne![index];
              return Card(
                margin: EdgeInsets.all(8),
                elevation: 4,
                child: ListTile(
                  leading: Icon(Icons.savings, color: Colors.green),
                  title: Text(objectif.description ?? "Sans description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Montant objectif: ${objectif.objectifMontant.toString()}€",
                          style: TextStyle(fontSize: 16)),
                      Text(
                          "Montant actuel: ${objectif.montantActuel.toString()}€",
                          style: TextStyle(fontSize: 16)),
                      Text(
                          "Date de début: ${objectif.dateDebut != null ? DateFormat('dd/MM/yyyy').format(objectif.dateDebut!) : "Non définie"}",
                          style: TextStyle(fontSize: 16)),
                      Text(
                          "Date de fin: ${objectif.dateFin != null ? DateFormat('dd/MM/yyyy').format(objectif.dateFin!) : "Non définie"}",
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddObjectifDialog,
        backgroundColor: Colors.purple,
        tooltip: 'Ajouter un objectif d\'épargne',
        child: Icon(Icons.add),
      ),
    );
  }
}
