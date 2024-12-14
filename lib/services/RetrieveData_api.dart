// lib/RetrieveData_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // final String apiUrl = "http://127.0.0.1:5000/data";
// final String apiUrl = "http://192.168.208.54:5000/data";
final String apiUrl = "https://flaskapi-86tv.onrender.com/data";
  Future<List<Fact>> fetchFacts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print(response.body);
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((fact) => Fact.fromJson(fact)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class Fact {
  final int idFact;
  final int fkTypeRecharge;
  final String typeRecharge;
  final int nombreRecharge;
  final double totalRechargeTNDHT;
  final double totalRechargeTNDTTC_Digital;
  final double pourcentageRechargeDigitalVsGlobal;
  final double pourcentageNombreRechargeDigitalVsGlobal;
  final String date;
  final int nbrOptionGlobal;
  final double montantOptionGlobal;
  final int nbrOptionDigital;
  final double montantOptionDigital;
  final int nbrDataGlobal;
  final double montantDataGlobal;
  final int nbrDataDigital;
  final double montantDataDigital;

  Fact({
    required this.idFact,
    required this.fkTypeRecharge,
    required this.typeRecharge,
    required this.nombreRecharge,
    required this.totalRechargeTNDHT,
    required this.totalRechargeTNDTTC_Digital,
    required this.pourcentageRechargeDigitalVsGlobal,
    required this.pourcentageNombreRechargeDigitalVsGlobal,
    required this.date,
    required this.nbrOptionGlobal,
    required this.montantOptionGlobal,
    required this.nbrOptionDigital,
    required this.montantOptionDigital,
    required this.nbrDataGlobal,
    required this.montantDataGlobal,
    required this.nbrDataDigital,
    required this.montantDataDigital,
  });

  factory Fact.fromJson(Map<String, dynamic> json) {
    return Fact(
      idFact: json['id_fact'],
      fkTypeRecharge: json['FK_TypeRecharge'],
      typeRecharge: json['TypeRecharge'],
      nombreRecharge: json['NombreRecharge'],
      totalRechargeTNDHT: json['TotalRechargeTNDHT'],
      totalRechargeTNDTTC_Digital: json['TotalRechargeTNDTTC_Digital'],
      pourcentageRechargeDigitalVsGlobal: json['PourcentageRechargeDigitalVsGlobal'],
      pourcentageNombreRechargeDigitalVsGlobal: json['PourcentageNombreRechargeDigitalVsGlobal'],
      date: json['Date'],
      nbrOptionGlobal: json['NbrOptionGlobal'],
      montantOptionGlobal: json['MontantOptionGlobal'],
      nbrOptionDigital: json['NbrOptionDigital'],
      montantOptionDigital: json['MontantOptionDigital'],
      nbrDataGlobal: json['NbrDataGlobal'],
      montantDataGlobal: json['MontantDataGlobal'],
      nbrDataDigital: json['NbrDataDigital'],
      montantDataDigital: json['MontantDataDigital'],
    );
  }
}
