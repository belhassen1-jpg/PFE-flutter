import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Controller/Conge_controller.dart';

class TotalCongesView extends StatefulWidget {
  final int employeId;

  TotalCongesView({required this.employeId});

  @override
  _TotalCongesViewState createState() => _TotalCongesViewState();
}

class _TotalCongesViewState extends State<TotalCongesView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _totalJoursConges = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });
    _controller.forward();
    fetchTotalJoursConges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Total de congés",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Text(
              '${_totalJoursConges.toString()} jours',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void fetchTotalJoursConges() async {
    try {
      final totalJoursConges =
          await Provider.of<DemandeCongeController>(context, listen: false)
              .calculerTotalJoursCongesPourEmploye(widget.employeId);
      setState(() {
        _totalJoursConges = totalJoursConges;
      });
    } catch (e) {
      print('Calculate Total Jours Conges Error: ${e.toString()}');
    }
  }
}
