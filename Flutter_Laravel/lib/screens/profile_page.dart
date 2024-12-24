import 'package:flutter/material.dart';
import 'package:flutter_laravel/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_laravel/providers/dio_provider.dart';
import 'package:flutter_laravel/models/auth_model.dart';
import 'package:flutter_laravel/main.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    // Récupérer les données utilisateur (y compris les détails du docteur) à partir de AuthModel
    user = Provider.of<AuthModel>(context, listen: false).getUser;
  }

  @override
  Widget build(BuildContext context) {
    // Vérifier si le type d'utilisateur est "doctor"
    bool isDoctor = user['type'] == 'doctor';

    // Assurez-vous que les données du docteur existent et sont bien formatées
    List<dynamic> doctorDetailsList = user['doctor'] ?? [];
    Map<String, dynamic> doctorDetails = doctorDetailsList.isNotEmpty ? doctorDetailsList[0] : {};

    String doctorCategory = doctorDetails['category'] ?? 'Doctor Category';
    String doctorProfile = doctorDetails['doctor_profile'] ?? 'https://example.com/default_profile.jpg';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 4,
          child: Container(
            color: Config.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 65.0,
                  backgroundImage: isDoctor && doctorProfile != null
                      ? NetworkImage("http://10.0.2.2:8000$doctorProfile")
                      : AssetImage('assets/user.png') as ImageProvider,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  user['name'] ?? 'Doctor Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  isDoctor ? doctorCategory : 'Patient',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: 20),
                    buildProfileItem(Icons.person, "Edit Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
                      );
                    }),
                    buildProfileItem(Icons.phone, "Add Phone Number", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddNumberPage(user: user)),
                      );
                    }),
                    buildProfileItem(Icons.logout_outlined, "Logout", () async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('token') ?? '';

                      if (token.isNotEmpty && token != '') {
                        final response = await DioProvider().logout(token);

                        if (response == 200) {
                          await prefs.remove('token');
                          setState(() {
                            MyApp.navigatorKey.currentState!.pushReplacementNamed('/');
                          });
                        }
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProfileItem(IconData icon, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blueAccent[400],
            size: 35,
          ),
          SizedBox(width: 20),
          TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(
                color: Config.primaryColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;
  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String email;

  @override
  void initState() {
    super.initState();
    name = widget.user['name'] ?? '';
    email = widget.user['email'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Envoyer les données au backend pour mise à jour
                    // Implementer la logique de mise à jour ici
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddNumberPage extends StatefulWidget {
  final Map<String, dynamic> user;
  AddNumberPage({required this.user});

  @override
  _AddNumberPageState createState() => _AddNumberPageState();
}

class _AddNumberPageState extends State<AddNumberPage> {
  final _formKey = GlobalKey<FormState>();
  late String phoneNumber;

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.user['phone_number'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Phone Number")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: phoneNumber,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) => phoneNumber = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Envoyer les données au backend pour mise à jour
                    // Implementer la logique de mise à jour ici
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
