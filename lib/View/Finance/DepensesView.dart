import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Model/Depense.dart';
import '../../Model/User.dart';
import '../../Controller/User_controller.dart';
import '../../Controller/Finance_controller.dart';

class DepensesView extends StatefulWidget {
  @override
  _DepensesViewState createState() => _DepensesViewState();
}

class _DepensesViewState extends State<DepensesView> {
  User? loggedInUser;
  UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    fetchUserAndDepenses();
  }

  void fetchUserAndDepenses() async {
    User? user = await userController.getMe();
    if (user != null) {
      Provider.of<FinanceController>(context, listen: false)
          .listerDepenses(user.id!);
    }
    setState(() {
      loggedInUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des Dépenses"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<FinanceController>(
        builder: (context, controller, child) {
          return ListView.builder(
            itemCount: controller.depenses?.length ?? 0,
            itemBuilder: (context, index) {
              Depense depense = controller.depenses![index];
              return Card(
                margin: EdgeInsets.all(8),
                elevation: 4,
                child: ListTile(
                  leading: Icon(Icons.monetization_on, color: Colors.green),
                  title: Text(depense.categorie ?? "Sans catégorie",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Montant : ${depense.montant?.toStringAsFixed(2)}€",
                          style: TextStyle(fontSize: 16)),
                      Text(
                          "Date : ${depense.dateDepense != null ? DateFormat('dd/MM/yyyy').format(depense.dateDepense!) : "Date non disponible"}",
                          style: TextStyle(fontSize: 16)),
                      Text(
                          "Description : ${depense.description ?? "Pas de description"}",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600])),
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
        onPressed: _showAddExpenseDialog,
        backgroundColor: Colors.purple,
        tooltip: 'Ajouter une dépense',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        String categorie = '';
        double montant = 0.0;
        String description = '';
        TextEditingController _dateController = TextEditingController();

        return AlertDialog(
          title: Text("Ajouter une nouvelle dépense"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Catégorie'),
                    onSaved: (value) => categorie = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Montant'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => montant = double.parse(value!),
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration:
                        InputDecoration(labelText: 'Date de la dépense'),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
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
                    Depense newDepense = Depense(
                      categorie: categorie,
                      montant: montant,
                      description: description,
                      dateDepense:
                          DateFormat('yyyy-MM-dd').parse(_dateController.text),
                      employeId: loggedInUser!.id,
                    );
                    Provider.of<FinanceController>(context, listen: false)
                        .ajouterDepense(loggedInUser!.id!, newDepense, context)
                        .then((_) {
                      Navigator.of(context).pop();
                      fetchUserAndDepenses(); // Refresh the list after adding
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
}
