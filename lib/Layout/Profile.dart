import 'package:flutter/material.dart';
import 'package:my_dash/Authentification/Authentification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _msisdn = ''; // Variable pour stocker le numéro de téléphone

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Chargement des données utilisateur au démarrage de la page
  }

  // Méthode pour charger les données utilisateur depuis SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _msisdn = prefs.getString('msisdn') ??
          ''; // Charger msisdn depuis SharedPreferences
      // Vous pouvez charger d'autres données utilisateur ici si nécessaire
    });
  }

  // Méthode pour déconnecter l'utilisateur
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Effacer toutes les données de SharedPreferences

    // Redirection vers la page de connexion après déconnexion
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignInPage()),
      (Route<dynamic> route) => false, // Empêche le retour en arrière
    );
  }

  void _saveProfile() {
    // Logique pour sauvegarder le profil
    print('Profile Saved!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 201, 196, 196),
                // backgroundImage: AssetImage('path_to_your_image'),
              ),
              SizedBox(height: 16),
              Text(
                'Phone Number: $_msisdn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Save Profile',
                  style: TextStyle(
                    color: Colors.black,
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
