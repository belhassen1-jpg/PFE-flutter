import 'dart:convert';
import 'dart:developer';
import 'package:erp_mob/componenet/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:erp_mob/Model/User.dart';
import 'package:erp_mob/Controller/User_controller.dart';

class DashboardViewUser extends StatefulWidget {
  const DashboardViewUser({super.key});

  @override
  State<DashboardViewUser> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardViewUser> {
  User? loggedInUser;
  String userRole = "User";
  UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    log('0');
    fetchMe();
  }

  void fetchMe() async {
    User? user = await userController.getMe();
    if (user != null) {
      print(user.username);
    }
    setState(() {
      loggedInUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(
              top: 8), // Adjust padding to move logo and text down a bit
          child: Row(
            children: [
              Spacer(),
              Image.asset('assets/images/SascodeLOGO.png',
                  width: 50, height: 50),
              SizedBox(width: 10),
              Text('Sascode',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        centerTitle: false,
      ),
      drawer: customDrawer(context, userRole, loggedInUser),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.black87],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Image.asset('assets/images/Home.jpg', fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    SectionTitle(title: "Services et conseil en informatique"),
                    SizedBox(height: 16),
                    Text(
                      "Notre entreprise offre des solutions informatiques pour optimiser et sécuriser les systèmes d'entreprises, en fournissant des services de développement de logiciels sur mesure, gestion de projets, et audits de sécurité. Nous conseillons également sur les stratégies numériques et intégrons des technologies avancées comme le cloud computing et l'intelligence artificielle pour améliorer la prise de décision et la performance opérationnelle. Notre soutien à la transformation numérique permet aux entreprises de répondre efficacement aux défis actuels, en rendant leurs processus plus efficaces et sécurisés, tout en respectant les exigences du marché moderne.",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 60),
                    Center(child: SectionTitle(title: "Nos Services")),
                    SizedBox(height: 18),
                    ServiceTile(
                      icon: Icons.code,
                      title: "Développement et intégration",
                      description:
                          "Solutions logicielles personnalisées adaptées à vos besoins commerciaux uniques.",
                    ),
                    ServiceTile(
                      icon: Icons.security,
                      title: "Sécurité IT",
                      description:
                          "Mesures de cybersécurité robustes pour protéger vos systèmes et vos données.",
                    ),
                    ServiceTile(
                      icon: Icons.cloud,
                      title: "Services Cloud",
                      description:
                          "Solutions cloud évolutives pour vos besoins de stockage et de calcul.",
                    ),
                    ServiceTile(
                      icon: Icons.support,
                      title: "Support Technique",
                      description:
                          "Support 24/7 pour garantir le bon fonctionnement de votre infrastructure informatique.",
                    ),
                    SizedBox(height: 50),
                    Center(child: CallToActionWidget()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.orangeAccent,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ServiceTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: TextStyle(color: Colors.white70)),
      ),
    );
  }
}

class CallToActionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text("En savoir plus"),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }
}
