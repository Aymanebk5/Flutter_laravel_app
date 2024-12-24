import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  final Dio _dio = Dio();

  // Get token
  //envoie request Post pour recuperer le token apres authentification
  //stocke le token dans sharedpreference
  Future<bool> getToken(String email, String password) async {
    try {
      var response = await _dio.post(
        'http://10.0.2.2:8000/api/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data.toString());
        return true; // Successful login
      } else {
        return false; // Login failed
      }
    } catch (error) {
      print('Error in getToken: $error');
      return false;
    }
  }

  // Get user data
  //requête GET pour récupérer les données de l'utilisateur à partir de l'API, en utilisant le token pour l'authentification.
  Future<String?> getUser(String token) async {
    try {
      var response = await _dio.get(
        'http://10.0.2.2:8000/api/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return json.encode(response.data);
      } else {
        return null;
      }
    } catch (error) {
      print('Error in getUser: $error');
      return null;
    }
  }

  // Register new user
  Future<bool> registerUser(String username, String email, String password) async {
    try {
      var response = await _dio.post(
        'http://10.0.2.2:8000/api/register/',
        data: {'name': username, 'email': email, 'password': password},
      );

      if (response.statusCode == 201 && response.data != null) {
        return true; //  successful
      } else {
        return false; //  failed
      }
    } catch (error) {
      print('Dio Error in registerUser: $error');
      throw Exception('Failed to register user');
    }
  }

  // Get token after registration
  Future<String> fetchToken(String email, String password) async {
    try {
      var response = await _dio.post(
        'http://10.0.2.2:8000/api/login/',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null && response.data['token'] != null) {
        return response.data['token']; // Return token
      } else {
        throw Exception('Login failed');
      }
    } catch (error) {
      print('Dio Error in fetchToken: $error');
      throw Exception('Failed to get token');
    }
  }



  //store booking details
  Future<dynamic> bookAppointment(
      String date, String day, String time, int doctor, String token) async {
    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/book',
          data: {'date': date, 'day': day, 'time': time, 'doctor_id': doctor},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //retrieve booking details
  Future<dynamic> getAppointments(String token) async {
    try {
      var response = await Dio().get('http://10.0.2.2:8000/api/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //store rating details
  Future<dynamic> storeReviews(
      String reviews, double ratings, int id, int doctor, String token) async {
    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/reviews',
          data: {
            'ratings': ratings,
            'reviews': reviews,
            'appointment_id': id,
            'doctor_id': doctor
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //store fav doctor
  Future<dynamic> storeFavDoc(String token, List<dynamic> favList) async {
    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/fav',
          data: {
            'favList': favList,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

//logout
  Future<dynamic> logout(String token) async {
    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }
}
