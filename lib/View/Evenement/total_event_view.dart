import 'package:erp_mob/Controller/User_controller.dart';
import 'package:erp_mob/Controller/Evenement_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Model/User.dart';

class TotalEventView extends StatefulWidget {
  User? loggedInUser;
  TotalEventView({required this.loggedInUser});
  @override
  _TotalEventViewState createState() => _TotalEventViewState();
}

class _TotalEventViewState extends State<TotalEventView> {
  Widget build(BuildContext context) {
    final evenementController = Provider.of<EvenementController>(context);
    final userController = Provider.of<UserController>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text("Nombre d'événements participés"),
          backgroundColor: Colors.deepPurple,
        ),
        body: FutureBuilder<int?>(
          future: evenementController.obtenirNombreEvenementsParticipesForUser(
              widget.loggedInUser!.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              int nombreEvenements = snapshot.data!;
              return _buildContent(nombreEvenements);
            } else {
              return Text('No data available');
            }
          },
        ));
  }

  Widget _buildContent(int nombreEvenements) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Vous avez participé à',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          _buildAnimatedNumber(nombreEvenements),
          SizedBox(height: 16),
          Text(
            'événements',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedNumber(int nombreEvenements) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: nombreEvenements),
      duration: Duration(seconds: 1),
      builder: (context, value, child) {
        return Text(
          value.toString(),
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        );
      },
    );
  }
}
