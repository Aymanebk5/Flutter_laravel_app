import 'package:flutter/material.dart';
import 'package:flutter_laravel/screens/doctor_details.dart';
import 'package:flutter_laravel/utils/config.dart';
import 'package:flutter_laravel/main.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.isFav,
  }) : super(key: key);

  final Map<String, dynamic> doctor;
  final bool isFav; // Declared as class attribute

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    // Example ratings and review count (replace with actual API data)
    double averageRating = doctor['averageRating'] ?? 0.0;
    int totalReviews = doctor['totalReviews'] ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                child: doctor['doctor_profile'] != null
                    ? Image.network(
                  "http://10.0.2.2:8000${doctor['doctor_profile']}",
                  fit: BoxFit.fill,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Text('Failed to load image');
                  },
                )
                    : Text('No profile image'),
              ),
              Flexible(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Dr ${doctor['doctor_name']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${doctor['category']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.star_border,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text('$averageRating'),
                          const SizedBox(width: 4),
                          Text('Reviews'),
                          const SizedBox(width: 4),
                          Text('($totalReviews)'),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          // Navigate to doctor details page
          MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (_) => DoctorDetails(
                doctor: doctor,
                isFav: isFav, // Using class attribute isFav
              ),
            ),
          );
        },
      ),
    );
  }
}
