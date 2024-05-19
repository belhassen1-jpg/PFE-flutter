import 'package:erp_mob/Controller/Demission_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/User.dart';
import '../../Controller/User_controller.dart';
import 'package:intl/intl.dart';

class CreateDemissionView extends StatefulWidget {
  @override
  _CreateDemissionViewState createState() => _CreateDemissionViewState();
}

class _CreateDemissionViewState extends State<CreateDemissionView> {
  final _formKey = GlobalKey<FormState>();
  String motif = '';
  bool isLoading = false;
  User? loggedInUser;
  UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    fetchMe();
  }

  fetchMe() async {
    setState(() => isLoading = true);
    User? user = await userController.getMe();
    setState(() {
      loggedInUser = user;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Créer une Démission',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[800], // Red background for alert
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Motif',
                                prefixIcon: Icon(Icons.warning,
                                    color: Colors.red), // Red warning icon
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un motif';
                                }
                                return null;
                              },
                              onSaved: (value) => motif = value ?? '',
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (loggedInUser != null) {
                                    String currentDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now());
                                    Map<String, dynamic> jsonData = {
                                      "dateDemande": currentDate,
                                      "motif": motif,
                                      "employe": {"empId": loggedInUser?.id}
                                    };
                                    Provider.of<DemissionController>(context,
                                            listen: false)
                                        .createDemission(
                                            body: jsonData,
                                            userId: loggedInUser!.id,
                                            context: context);
                                  }
                                }
                              },
                              child: Text('Soumettre'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red[800],
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
