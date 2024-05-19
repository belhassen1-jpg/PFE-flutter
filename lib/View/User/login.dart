import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:erp_mob/Controller/Auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  AuthService authService = AuthService(baseUrl: 'http://localhost:8090/GRH');

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF303030)
            ], // Adjusted colors here
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 80),
                Image.asset('assets/images/SascodeLOGO.png', width: 100),
                SizedBox(height: 20),
                Text(
                  'Bienvenue à Sascode',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'Connectez-vous pour continuer',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 30),
                _buildTextField(usernameController, 'Nom d\'utilisateur',
                    Icons.person_outline),
                SizedBox(height: 15),
                _buildTextField(
                    passwordController, 'Mot de passe', Icons.lock_outline,
                    isPassword: true),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final Map<String, dynamic>? userData =
                          await authService.login(
                              usernameController.text, passwordController.text);
                      if (userData != null) {
                        await _storeUserData(userData['username'],
                            userData['user'].toString(), userData['userRole']);
                        if (userData['userRole'] != null) {
                          _navigateBasedOnRole(userData['userRole'], context);
                        }
                      } else {
                        _showErrorDialog(
                            context, 'Login failed. Please try again.');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Connexion'),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigation logic to registration page
                  },
                  child: Text('Créer un compte',
                      style: TextStyle(color: Colors.white70)),
                ),
                SizedBox(height: 30),
                Text('Ou connectez-vous avec',
                    style: TextStyle(color: Colors.white60)),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.facebook, color: Colors.blue)),
                      SizedBox(width: 20),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.account_circle,
                              color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _storeUserData(
      String username, String userId, String userRole) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('userId', userId);
    await prefs.setString('userRole', userRole);
  }

  void _navigateBasedOnRole(String role, BuildContext context) {
    switch (role) {
      case 'Employee':
        Navigator.pushReplacementNamed(context, '/dashboardEmploye');
        break;
      case 'User':
      case 'Guest':
        Navigator.pushReplacementNamed(context, '/dashboardUser');
        break;
      default:
        _showErrorDialog(context, 'Unexpected role: $role');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Connection Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
