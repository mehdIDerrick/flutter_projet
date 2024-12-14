// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'https://client-data-pwya.onrender.com/get-data/';

//   Future<List<dynamic>> fetchData({int? tmcode, String? entityName, String? activationDate}) async {
//     try {
//       final uri = Uri.parse(baseUrl).replace(queryParameters: {
//         if (tmcode != null) 'tmcode': tmcode.toString(),
//         if (entityName != null) 'entity_name': entityName,
//         if (activationDate != null) 'activation_date': activationDate,
//       });
//       print('Requesting data from: $uri'); // Debugging line to check the URL

//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['data'];
//       } else {
//         print('Failed to load data. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error in fetchData: $e');
//       throw Exception('Failed to load data');
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'https://client-data-pwya.onrender.com/get-data/';

//   Future<List<dynamic>> fetchData({int? tmcode, String? entityName, String? activationDate, String? role}) async {
//     try {
//       // Construct query parameters based on role
//       final Map<String, String> queryParameters = {
//         if (tmcode != null) 'tmcode': tmcode.toString(),
//         if (entityName != null) 'entity_name': entityName,
//         if (activationDate != null) 'activation_date': activationDate,
//       };

//       if (role == 'restricted') {
//         queryParameters['entity_name'] = 'Franchise Mourouj 4'; // Example entity name for restricted access
//       }

//       final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
//       print('Requesting data from: $uri'); // Debugging line to check the URL

//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['data'];
//       } else {
//         print('Failed to load data. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         throw Exception('Failed to load data');
//       }
//     }
//     catch (e) {
//       print('Error in fetchData: $e');
//       throw Exception('Failed to load data');
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl1 = 'https://client-data-pwya.onrender.com/get-data/';
//   // static const String baseUrl2 = 'https://client-data-pwya.onrender.com/get_evolution/';
//   // static const String baseUrl3 = 'https://client-data-pwya.onrender.com/calculate_kpi/';

//   Future<List<dynamic>> fetchData({int? tmcode, String? entityName, String? activationDate, String? role}) async {
//     try {
//       // Construct query parameters based on role
//       final Map<String, String> queryParameters = {
//         if (tmcode != null) 'tmcode': tmcode.toString(),
//         if (entityName != null) 'entity_name': entityName,
//         if (activationDate != null) 'activation_date': activationDate,
//       };

//       if (role == 'restricted') {
//         queryParameters['entity_name'] = 'Franchise Mourouj 4'; // Example entity name for restricted access
//       }

//       final uri1 = Uri.parse(baseUrl1).replace(queryParameters: queryParameters);
//       // final uri2 = Uri.parse(baseUrl2).replace(queryParameters: queryParameters);
//       // final uri3  = Uri.parse(baseUrl3).replace(queryParameters: queryParameters);

//       print('Requesting data from: $uri1');
//       // print('Requesting data from: $uri2');
//       // print('Requesting data from: $uri3');

//       // Make HTTP requests to all three URLs
//       final responses = await Future.wait([
//         http.get(uri1),
//         // http.get(uri2),
//         // http.get(uri3),
//       ]);

//       // Check if all responses are successful
//       for (var response in responses) {
//         if (response.statusCode != 200) {
//           print('Failed to load data from one of the URLs. Status code: ${response.statusCode}');
//           print('Response body: ${response.body}');
//           throw Exception('Failed to load data');
//         }
//       }

//       // Combine the data from all responses
//       List<dynamic> combinedData = [];
//       for (var response in responses) {
//         final data = json.decode(response.body);
//         combinedData.addAll(data['data']);
//       }

//       return combinedData;
//     } catch (e) {
//       print('Error in fetchData: $e');
//       throw Exception('Failed to load data');
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   final String baseUrl = "https://client-data-pwya.onrender.com";

//   // GET request for get-data
//   Future<List<dynamic>> fetchData() async {
//     final response = await http.get(Uri.parse('$baseUrl/get-data'));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   // GET request for get_evolution
//   Future<List<dynamic>> fetchEvolution() async {
//     final response = await http.get(Uri.parse('$baseUrl/get_evolution'));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load evolution data');
//     }
//   }

//   // GET request for calculate_kpi
//   Future<List<dynamic>> fetchKpi() async {
//     final response = await http.get(Uri.parse('$baseUrl/calculate_kpi'));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load KPI data');
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "https://client-data-pwya.onrender.com";

  Future<String?> _getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('msisdn');
  }

  Future<String?> _getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  Future<Map<String, dynamic>> fetchUser() async {
    String? phoneNumber = await _getPhoneNumber();
    String? password = await _getPassword();
    if (phoneNumber == null) {
      throw Exception('Phone number not found in SharedPreferences');
    }
    if (password == null) {
      throw Exception('Password not found in SharedPreferences');
    }

    print('api phoneNumber ' + phoneNumber);
    final response = await http.get(Uri.parse(
        'https://script.googleusercontent.com/macros/echo?user_content_key=ui9NifYrhR43rqBVuirW8OIJo9EWV5oc6HswmI6Av7HrYky2tRdR-MUGSP4xsQIf9BoyFdoxuy1lj2JxkQHBdbYM6ndWtZHKm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnH4GDLK3Fvu7qkPF5uHejlPjBgQMwx8NmXjxh3YbOnVTc9MIhSZudMGkVSnVJRwfBT_8wQv9Q0nuDM2_9N3S-tdgPNYiCULuD9z9Jw9Md8uu&lib=MCLBqBtrw4yJazfRJYB5InOzNkRQCIOg8'));
    print(response);
    if (response.statusCode == 200) {
      print(response.body);

      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid phone number or password');
    } else {
      throw Exception('Failed to load data');
    }
  }

  // GET request for get-data
  Future<List<dynamic>> fetchData() async {
    // String? phoneNumber = await _getPhoneNumber();
    // String? password = await _getPassword();
    // if (phoneNumber == null) {
    //   throw Exception('Phone number not found in SharedPreferences');
    // }
    // if (password == null) {
    //   throw Exception('Password not found in SharedPreferences');
    // }
    // print('api phoneNumber ' + phoneNumber);
    // final response = await http.get(Uri.parse(
    //     '$baseUrl/get-data-by-user/?msisdn=$phoneNumber&password=$password'));
    final response = await http.get(Uri.parse(
        'https://script.googleusercontent.com/macros/echo?user_content_key=ui9NifYrhR43rqBVuirW8OIJo9EWV5oc6HswmI6Av7HrYky2tRdR-MUGSP4xsQIf9BoyFdoxuy1lj2JxkQHBdbYM6ndWtZHKm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnH4GDLK3Fvu7qkPF5uHejlPjBgQMwx8NmXjxh3YbOnVTc9MIhSZudMGkVSnVJRwfBT_8wQv9Q0nuDM2_9N3S-tdgPNYiCULuD9z9Jw9Md8uu&lib=MCLBqBtrw4yJazfRJYB5InOzNkRQCIOg8'));
    if (response.statusCode == 200) {
      // Extract the list from the parent object
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['data'];
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid phone number or password');
    } else {
      throw Exception('Failed to load data');
    }
  }

  // GET request for calculate_kpi
  Future<List<dynamic>> fetchKpi() async {
    final response = await http.get(Uri.parse('$baseUrl/calculate_kpi'));

    if (response.statusCode == 200) {
      // Extract the list from the parent object
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['best_sellers'];
    } else {
      throw Exception('Failed to load KPI data');
    }
  }
}
