import 'package:flutter/material.dart';
import 'package:flutter_laravel/components/appointment_card.dart';
import 'package:flutter_laravel/components/doctor_card.dart';
import 'package:flutter_laravel/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_laravel/models/auth_model.dart';
import 'package:flutter_laravel/screens/profile_page.dart'; // Importez la page de profil ici

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};
  Map<String, dynamic> appointment = {};
  List<dynamic> favList = [];
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "General",
    },
    {
      "icon": FontAwesomeIcons.brain,
      "category": "Psychology",
    },
    {
      "icon": FontAwesomeIcons.hand,
      "category": "Dermatology",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Gynecology",
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Dental",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Cardiology",
    },
  ];

  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    // Obtenir les données de l'utilisateur, les rendez-vous et la liste des favoris depuis AuthModel
    user = Provider
        .of<AuthModel>(context, listen: false)
        .getUser;
    appointment = Provider
        .of<AuthModel>(context, listen: false)
        .getAppointment;
    favList = Provider
        .of<AuthModel>(context, listen: false)
        .getFav;

    // Vérifiez si l'utilisateur est un médecin et obtenir les détails du médecin
    bool isDoctor = user['type'] == 'doctor';
    List<dynamic> doctorDetailsList = user['doctor'] ?? [];
    Map<String, dynamic> doctorDetails = doctorDetailsList.isNotEmpty
        ? doctorDetailsList[0]
        : {};
    String doctorProfile = doctorDetails['doctor_profile'] ?? '';

    // Filtrer les médecins par la catégorie sélectionnée
    List<dynamic> filteredDoctors = selectedCategory.isEmpty
        ? user['doctor'] ?? []
        : user['doctor']?.where((doctor) =>
    doctor['category'] == selectedCategory)?.toList() ?? [];

    return Scaffold(
      body: user.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      user['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: isDoctor
                            ? NetworkImage("http://10.0.2.2:8000$doctorProfile")
                            : AssetImage(
                            'assets/user.png') as ImageProvider,
                      ),
                    ),
                  ],
                ),
                Config.spaceMedium,
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                SizedBox(
                  height: Config.heightSize * 0.05,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(medCat.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = medCat[index]['category'];
                          });
                        },
                        child: Card(
                          margin: const EdgeInsets.only(right: 20),
                          color: selectedCategory == medCat[index]['category']
                              ? Config.primaryColor
                              : Colors.grey.shade300,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FaIcon(
                                  medCat[index]['icon'] as IconData,
                                  color: selectedCategory ==
                                      medCat[index]['category']
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  medCat[index]['category'] ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedCategory ==
                                        medCat[index]['category']
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Config.spaceSmall,
                const Text(
                  'Appointment Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                appointment.isNotEmpty
                    ? AppointmentCard(
                  doctor: appointment,
                  color: Config.primaryColor,
                )
                    : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No Appointment Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Config.spaceSmall,
                const Text(
                  'Top Doctors',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                Column(
                  children: List.generate(filteredDoctors.length, (index) {
                    return DoctorCard(
                      doctor: filteredDoctors[index],
                      isFav: favList.contains(filteredDoctors[index]['doc_id'])
                          ? true
                          : false,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}