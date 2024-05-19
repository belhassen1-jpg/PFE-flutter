import 'dart:convert';
import 'package:erp_mob/Controller/Environnement.dart';
import 'package:erp_mob/Controller/User_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:erp_mob/componenet/custom_drawer.dart';
import 'package:erp_mob/Model/User.dart';
import 'package:erp_mob/Controller/FeuilleTemps_controller.dart';
import 'package:erp_mob/Controller/Statistiques_controller.dart';

class DashboardViewEmploye extends StatefulWidget {
  const DashboardViewEmploye({Key? key}) : super(key: key);

  @override
  _DashboardViewEmployeState createState() => _DashboardViewEmployeState();
}

class _DashboardViewEmployeState extends State<DashboardViewEmploye> {
  String _userRole = "Loading role...";
  User? loggedInUser;
  String userRole = "User";
  UserController userController = UserController();
  late FeuilleTempsController feuilleTempsController;
  late StatisticsController statisticsController;
  List<BarChartGroupData> statisticsChartData = [];
  List<BarChartGroupData> rankingsChartData = [];
  bool _isLoading = true;
  List<String> projectNames = [];
  String selectedProject = "Default Project";

  @override
  void initState() {
    super.initState();
    feuilleTempsController =
        Provider.of<FeuilleTempsController>(context, listen: false);
    statisticsController =
        Provider.of<StatisticsController>(context, listen: false);
    _loadUserDetails();
    _fetchProjects();
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

  Future<void> _loadUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userRole = prefs.getString('userRole') ?? 'Guest';
    String? userData = prefs.getString('userData');
    if (userData != null) {
      loggedInUser = User.fromJson(jsonDecode(userData));
    }
    setState(() {});
  }

  Future<void> _fetchProjects() async {
    try {
      final response = await http
          .get(Uri.parse('${Environnement.baseUrl}api/plannings/allDetails'));
      if (response.statusCode == 200) {
        List<dynamic> projects = json.decode(response.body);
        setState(() {
          projectNames = projects
              .map<String>((project) => project['nomProjet'] as String)
              .toList();
          if (projectNames.isNotEmpty) {
            selectedProject = projectNames.first;
          }
        });
        _fetchData();
      } else {
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      print('Failed to load projects: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to load projects: $e")));
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _fetchParticipationStatistics();
      await _fetchEmployeeRankings(selectedProject);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to fetch data: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchParticipationStatistics() async {
    try {
      await statisticsController.getParticipationStatistics(context);
      setState(() {
        statisticsChartData =
            statisticsController.participationStatistics.entries.map((entry) {
          int xValue = entry.key.hashCode; // Use hashCode for unique values
          double yValue = entry.value.values.reduce((a, b) => a + b);
          return BarChartGroupData(
              x: xValue,
              barRods: [BarChartRodData(toY: yValue, color: Colors.lightBlue)]);
        }).toList();
      });
    } catch (e) {
      print('Failed to fetch participation statistics: $e');
      throw Exception('Failed to fetch participation statistics: $e');
    }
  }

  Future<void> _fetchEmployeeRankings(String projectName) async {
    try {
      var rankings = await feuilleTempsController
          .getEmployeeRankingByProjectName(projectName, context);
      if (rankings != null && rankings.isNotEmpty) {
        setState(() {
          rankingsChartData = rankings.map((ranking) {
            double hoursWorked =
                (ranking['heuresTravaillees'] as num).toDouble();
            return BarChartGroupData(x: ranking['employeId'], barRods: [
              BarChartRodData(toY: hoursWorked, color: Colors.orange)
            ]);
          }).toList();
        });
      } else {
        print("No rankings data received or planning not found.");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "No rankings data available for the project: $projectName")));
      }
    } catch (e) {
      print('Failed to fetch employee rankings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load employee rankings: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
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
      drawer: customDrawer(context, _userRole, loggedInUser),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : buildContent(),
    );
  }

  Widget buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Participation Statistics'),
            buildBarChart(statisticsChartData, 'Months', 'Count'),
            SizedBox(height: 32),
            buildProjectDropdown(),
            SizedBox(height: 16),
            buildSectionTitle('Employee Hours Ranking'),
            buildBarChart(rankingsChartData, 'Employee', 'Hours Worked'),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildBarChart(
      List<BarChartGroupData> barGroups, String xAxisLabel, String yAxisLabel) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text(
                      value.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text(
                      value.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 1,
              );
            },
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProjectDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButton<String>(
        value: selectedProject,
        onChanged: (String? newValue) {
          setState(() {
            selectedProject = newValue!;
            _fetchEmployeeRankings(selectedProject);
          });
        },
        items: projectNames.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
