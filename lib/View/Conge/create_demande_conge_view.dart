import 'package:erp_mob/Controller/Conge_controller.dart';
import 'package:erp_mob/Model/Conge.dart';
import 'package:erp_mob/Model/Employe.dart';
import 'package:erp_mob/View/Conge/total_conges_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controller/User_controller.dart';
import '../../Model/User.dart';

class CreateDemandeCongeView extends StatefulWidget {
  @override
  _CreateDemandeCongeViewState createState() => _CreateDemandeCongeViewState();
}

class _CreateDemandeCongeViewState extends State<CreateDemandeCongeView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController startDateInput = TextEditingController();
  TextEditingController endDateInput = TextEditingController();
  DateTime? dateDebut;
  DateTime? dateFin;
  TypeConge type = TypeConge.ANNUEL;
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    fetchMe();

    startDateInput.text = "";
    endDateInput.text = "";
  }

  User? loggedInUser;
  UserController userController = UserController();

  fetchMe() async {
    User? user = await userController.getMe();
    if (user != null) {
      print(user.username);
    }
    setState(() {
      loggedInUser = user;
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Créer une demande de congé",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: <Widget>[
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: startDateInput,
                              decoration: InputDecoration(
                                labelText: "Date de début",
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101));
                                if (pickedDate != null) {
                                  setState(() {
                                    dateDebut = pickedDate;
                                    startDateInput.text =
                                        "${pickedDate.toLocal()}".split(' ')[0];
                                  });
                                }
                              },
                            ),
                            TextFormField(
                              controller: endDateInput,
                              decoration: InputDecoration(
                                labelText: "Date de fin",
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101));
                                if (pickedDate != null) {
                                  setState(() {
                                    dateFin = pickedDate;
                                    endDateInput.text =
                                        "${pickedDate.toLocal()}".split(' ')[0];
                                  });
                                }
                              },
                            ),
                            DropdownButton<TypeConge>(
                              value: type,
                              onChanged: (TypeConge? newValue) {
                                setState(() {
                                  type = newValue!;
                                });
                              },
                              items:
                                  TypeConge.values.map((TypeConge classType) {
                                return DropdownMenuItem<TypeConge>(
                                  value: classType,
                                  child: Text(
                                      classType.toString().split('.').last),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (loggedInUser != null) {
                                    Map<String, dynamic> jsonData = {
                                      "dateDebut": startDateInput.text,
                                      "dateFin": endDateInput.text,
                                      "type": type,
                                      "employe": {"empId": loggedInUser?.id}
                                    };
                                    print(jsonData);
                                    Provider.of<DemandeCongeController>(context,
                                            listen: false)
                                        .createDemandeConge(
                                            body: jsonData,
                                            userId: loggedInUser?.id,
                                            context: context);
                                  }
                                }
                              },
                              child: Text('Soumettre'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue[800],
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TotalCongesView(
                                            employeId: loggedInUser?.id ?? 0,
                                          )),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.analytics_outlined,
                                      color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Total de congés',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
