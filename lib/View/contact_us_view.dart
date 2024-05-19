import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactUsView extends StatefulWidget {
  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Contactez-nous",
          style: TextStyle(color: Colors.white), // Set the color to white
        ),
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/SascodeLOGO.png',
                    width: 100, height: 100),
                SizedBox(height: 20),
                Text(
                  'Nous sommes là pour vous aider !',
                  style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Votre Email",
                    hintStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orangeAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => email = value!,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Comment pouvons-nous vous aider ?",
                    hintStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orangeAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  onSaved: (value) => message = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre message';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Soumettre"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Implement the sending functionality or further processing here
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Soumission réussie"),
          content: Text(
              "Merci de nous avoir contactés, $email ! Nous reviendrons vers vous rapidement."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
