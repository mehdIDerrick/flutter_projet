// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:syncfusion_flutter_charts/charts.dart';

// class PageC extends StatefulWidget {
//   PageC({Key? key}) : super(key: key);

//   @override
//   PageCState createState() => PageCState();
// }

// class PageCState extends State<PageC> {
//   List<MyDataModel> data = [];
//   List<String> dateList = [];
//   bool loading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData("assets/RechargeGlobal.json");
//   }

//   Future<void> fetchData(String jsonFileName) async {
//     try {
//       String jsonString = await rootBundle.loadString(jsonFileName);
//       final jsonData = json.decode(jsonString);

//       data = jsonData.map<MyDataModel>((chartData) {
//         String date = chartData['date'] ?? '';
//         double totalRechargeJourJ = (chartData["total_recharge_jour_j"] ?? 0).toDouble();
//         double totalRechargeJourJ7 = (chartData["total_recharge_jour_j_7"] ?? 0).toDouble();
//         double totalRechargeJourM1 = (chartData["total_recharge_jour_m_1"] ?? 0).toDouble();
//         double totalRechargeJourY1 = (chartData["total_recharge_jour_y_1"] ?? 0).toDouble();
//         double totalRechargeCummulM = (chartData["total_recharge_cummul_m"] ?? 0).toDouble();
//         double totalRechargeCummulM1 = (chartData["total_recharge_cummul_m_1"] ?? 0).toDouble();
//         double totalRechargeCummulY1 = (chartData["total_recharge_cummul_y_1"] ?? 0).toDouble();

//         return MyDataModel(
//           date,
//           totalRechargeJourJ,
//           totalRechargeJourJ7,
//           totalRechargeJourM1,
//           totalRechargeJourY1,
//           totalRechargeCummulM,
//           totalRechargeCummulM1,
//           totalRechargeCummulY1,
//         );
//       }).toList();

//       dateList = data.map((salesData) => salesData.date).toSet().toList();

//       setState(() {
//         loading = false;
//       });
//     } catch (e) {
//       print("Error loading/processing data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Bar Chart from JSON Data',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: loading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     'Total Recharge by Dates',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Expanded(
//                     child: SfCartesianChart(
//                       primaryXAxis: CategoryAxis(),
//                       primaryYAxis: NumericAxis(title: AxisTitle(text: 'Total Recharge')),
//                       series: _buildBarSeries(),
//                       tooltipBehavior: TooltipBehavior(enable: true),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   List<BarSeries<MyDataModel, String>> _buildBarSeries() {
//     return [
//       BarSeries<MyDataModel, String>(
//         dataSource: data,
//         xValueMapper: (datum, _) => datum.date,
//         yValueMapper: (datum, _) => datum.totalRechargeJourJ,
//         name: 'Total Recharge Jour J',
//         dataLabelSettings: DataLabelSettings(isVisible: true),
//       ),
//       BarSeries<MyDataModel, String>(
//         dataSource: data,
//         xValueMapper: (datum, _) => datum.date,
//         yValueMapper: (datum, _) => datum.totalRechargeJourJ7,
//         name: 'Total Recharge Jour J-7',
//         dataLabelSettings: DataLabelSettings(isVisible: true),
//       ),
//       BarSeries<MyDataModel, String>(
//         dataSource: data,
//         xValueMapper: (datum, _) => datum.date,
//         yValueMapper: (datum, _) => datum.totalRechargeJourM1,
//         name: 'Total Recharge Jour M-1',
//         dataLabelSettings: DataLabelSettings(isVisible: true),
//       ),
//       BarSeries<MyDataModel, String>(
//         dataSource: data,
//         xValueMapper: (datum, _) => datum.date,
//         yValueMapper: (datum, _) => datum.totalRechargeJourY1,
//         name: 'Total Recharge Jour Y-1',
//         dataLabelSettings: DataLabelSettings(isVisible: true),
//       ),
//       BarSeries<MyDataModel, String>(
//         dataSource: data,
//         xValueMapper: (datum, _) => datum.date,
//         yValueMapper: (datum, _) => datum.totalRechargeCummulM,
//         name: 'Total Recharge Cummul M',
//         dataLabelSettings: DataLabelSettings(isVisible: true),
//       ),
//       BarSeries<MyDataModel, String>(
//         dataSource: data,
//         xValueMapper: (datum, _) => datum.date,
//         yValueMapper: (datum, _) => datum.totalRechargeCummulM1,
//         name: 'Total Recharge Cummul M-1',
//         dataLabelSettings: DataLabelSettings(isVisible: true),
//       ),
//       BarSeries<MyDataModel, String>(
//         dataSource: data,
//         xValueMapper: (datum, _) => datum.date,
//         yValueMapper: (datum, _) => datum.totalRechargeCummulY1,
//         name: 'Total Recharge Cummul Y-1',
//         dataLabelSettings: DataLabelSettings(isVisible: true),
//       ),
//     ];
//   }
// }

// class MyDataModel {
//   MyDataModel(
//     this.date,
//     this.totalRechargeJourJ,
//     this.totalRechargeJourJ7,
//     this.totalRechargeJourM1,
//     this.totalRechargeJourY1,
//     this.totalRechargeCummulM,
//     this.totalRechargeCummulM1,
//     this.totalRechargeCummulY1,
//   );

//   final String date;
//   final double totalRechargeJourJ;
//   final double totalRechargeJourJ7;
//   final double totalRechargeJourM1;
//   final double totalRechargeJourY1;
//   final double totalRechargeCummulM;
//   final double totalRechargeCummulM1;
//   final double totalRechargeCummulY1;
// }

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:my_dash/services/activation_client_api.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Page2 extends StatefulWidget {
//   Page2({Key? key}) : super(key: key);

//   @override
//   Page2State createState() => Page2State();
// }

// class Page2State extends State<Page2> {
//   List<_SalesData> data = [];
//   List<String> dateList = [];
//   List<String> selectedDates = [];
//   List<String> offerNames = [];
//   List<String> selectedOfferNames = [];
//   List<String> entityNames = [];
//   List<String> selectedEntityNames = [];
//   bool loading = true;
//   String userRole = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadUserRole();
//   }

//   Future<void> _loadUserRole() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userRole = prefs.getString('userRole') ?? '';
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     try {
//       ApiService apiService = ApiService();
//       List<dynamic> fetchedData = await apiService.fetchData();

//       data = fetchedData.map<_SalesData>((item) {
//         return _SalesData(
//           item['activation_date'],
//           item['tmcode'],
//           item['offer_name'],
//           item['entity_type_name'],
//           item['entity_name'],
//           item['seller_id'],
//           item['nb_count'],
//         );
//       }).toList();

//       dateList = data.map((salesData) => salesData.activationDate).toSet().toList();
//       offerNames = data.map((salesData) => salesData.offerName).toSet().toList();
//       entityNames = data.map((salesData) => salesData.entityName).toSet().toList();

//       setState(() {
//         loading = false;
//         selectedDates = [];
//         selectedOfferNames = [];
//         selectedEntityNames = [];
//       });
//     } catch (e) {
//       print("Error loading/processing data: $e");
//     }
//   }

//   List<_SalesData> getFilteredData() {
//     return data.where((d) {
//       bool dateCondition = selectedDates.isEmpty || selectedDates.contains(d.activationDate);
//       bool offerCondition = selectedOfferNames.isEmpty || selectedOfferNames.contains(d.offerName);
//       bool entityCondition = userRole == 'full' || d.entityName == 'Franchise Mourouj 4';
//       return dateCondition && offerCondition && entityCondition;
//     }).toList();
//   }

//   List<_SalesData> getTop5Data(List<_SalesData> list, double Function(_SalesData) getValue) {
//     list.sort((a, b) => getValue(b).compareTo(getValue(a)));
//     return list.take(5).toList();
//   }

//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text(
//         'KPIs',
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//     body: loading
//         ? const Center(child: CircularProgressIndicator())
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Dates filter (unchanged)
//               Container(
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Dates:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: dateList.map((date) {
//                           bool isSelected = selectedDates.contains(date);
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   if (isSelected) {
//                                     selectedDates.remove(date);
//                                   } else {
//                                     selectedDates.add(date);
//                                   }
//                                 });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 primary: isSelected ? Colors.black : null,
//                               ),
//                               child: Text(
//                                 date,
//                                 style: TextStyle(
//                                   color: isSelected ? Colors.white : Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Offers filter (unchanged)
//               Container(
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Offers:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: offerNames.map((offer) {
//                           bool isSelected = selectedOfferNames.contains(offer);
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   if (isSelected) {
//                                     selectedOfferNames.remove(offer);
//                                   } else {
//                                     selectedOfferNames.add(offer);
//                                   }
//                                 });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 primary: isSelected ? Colors.black : null,
//                               ),
//                               child: Text(
//                                 offer,
//                                 style: TextStyle(
//                                   color: isSelected ? Colors.white : Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Entity name filter (conditionally shown)
//               if (userRole != 'restricted')
//                 Container(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         'Entity name:',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(height: 8.0),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: entityNames.map((entity) {
//                             bool isSelected = selectedEntityNames.contains(entity);
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     if (isSelected) {
//                                       selectedEntityNames.remove(entity);
//                                     } else {
//                                       selectedEntityNames.add(entity);
//                                     }
//                                   });
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   primary: isSelected ? Colors.black : null,
//                                 ),
//                                 child: Text(
//                                   entity,
//                                   style: TextStyle(
//                                     color: isSelected ? Colors.white : Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Charts
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // Bar chart based on selected dates and selected offer names
//                         Container(
//                           height: 300,
//                           padding: const EdgeInsets.all(8.0),
//                           child: SfCartesianChart(
//                             primaryXAxis: CategoryAxis(),
//                             title: ChartTitle(
//                               text: selectedDates.isEmpty
//                                   ? 'Offer count by Seller'
//                                   : 'Bar Chart for ${selectedDates.join(", ")}',
//                             ),
//                             legend: Legend(isVisible: true),
//                             tooltipBehavior: TooltipBehavior(enable: true),
//                             series: <CartesianSeries<_SalesData, String>>[
//                               BarSeries<_SalesData, String>(
//                                 color: Color.fromARGB(223, 255, 115, 34),
//                                 dataSource: getFilteredData()
//                                     .where((d) => selectedOfferNames.isEmpty || selectedOfferNames.contains(d.offerName))
//                                     .toList(),
//                                 xValueMapper: (_SalesData sales, _) => sales.sellerId,
//                                 yValueMapper: (_SalesData sales, _) => sales.nbCount.toDouble(),
//                                 name: 'Offer Count',
//                                 dataLabelSettings: DataLabelSettings(isVisible: true),
//                                 pointColorMapper: (_SalesData sales, _) {
//                                   double maxVal = selectedDates.isEmpty
//                                       ? data.map((d) => d.nbCount.toDouble()).reduce((a, b) => a > b ? a : b)
//                                       : data.where((d) => selectedDates.contains(d.activationDate))
//                                           .map((d) => d.nbCount.toDouble())
//                                           .reduce((a, b) => a > b ? a : b);

//                                   return sales.nbCount.toDouble() == maxVal ? Colors.red : Color.fromARGB(223, 255, 115, 34);
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Line chart
//                         Container(
//                           padding: const EdgeInsets.all(8.0),
//                           child: SfCartesianChart(
//                             primaryXAxis: CategoryAxis(),
//                             title: ChartTitle(text: 'Offer count by Seller'),
//                             legend: Legend(isVisible: true),
//                             tooltipBehavior: TooltipBehavior(enable: true),
//                             series: <CartesianSeries<_SalesData, String>>[
//                               LineSeries<_SalesData, String>(
//                                 dataSource: getFilteredData(),
//                                 xValueMapper: (_SalesData sales, _) => sales.sellerId,
//                                 yValueMapper: (_SalesData sales, _) => sales.nbCount.toDouble(),
//                                 name: 'Offer Name Count',
//                                 dataLabelSettings: DataLabelSettings(isVisible: true),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Another bar chart based on selected dates and selected entity names
//                         Container(
//                           height: 300,
//                           padding: const EdgeInsets.all(8.0),
//                           child: SfCartesianChart(
//                             primaryXAxis: CategoryAxis(),
//                             title: ChartTitle(
//                               text: selectedDates.isEmpty
//                                   ? 'Offer count by Entity'
//                                   : 'Bar Chart for ${selectedDates.join(", ")} by Entity',
//                             ),
//                             legend: Legend(isVisible: true),
//                             tooltipBehavior: TooltipBehavior(enable: true),
//                             series: <CartesianSeries<_SalesData, String>>[
//                               BarSeries<_SalesData, String>(
//                                 color: Color.fromARGB(223, 61, 150, 215), // Adjust color as needed
//                                 dataSource: getFilteredData()
//                                     .where((d) => selectedEntityNames.isEmpty || selectedEntityNames.contains(d.entityName))
//                                     .toList(),
//                                 xValueMapper: (_SalesData sales, _) => sales.entityName,
//                                 yValueMapper: (_SalesData sales, _) => sales.nbCount.toDouble(),
//                                 name: 'Offer Count by Entity',
//                                 dataLabelSettings: DataLabelSettings(isVisible: true),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Pie chart classifying entity_name by entity_type_name
//                         Container(
//                           height: 300,
//                           padding: const EdgeInsets.all(8.0),
//                           child: SfCircularChart(
//                             title: ChartTitle(text: 'Entity Classification by Type'),
//                             legend: Legend(isVisible: true),
//                             series: <CircularSeries<_SalesData, String>>[
//                               PieSeries<_SalesData, String>(
//                                 dataSource: getEntityTypeSummary(),
//                                 xValueMapper: (_SalesData data, _) => data.entityTypeName,
//                                 yValueMapper: (_SalesData data, _) => data.nbCount.toDouble(),
//                                 dataLabelMapper: (_SalesData data, _) => data.entityTypeName,
//                                 dataLabelSettings: DataLabelSettings(isVisible: true),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   List<_SalesData> getEntityTypeSummary() {
//     Map<String, int> entityTypeCounts = {};
//     for (var entry in data) {
//       entityTypeCounts.update(entry.entityTypeName, (value) => value + entry.nbCount, ifAbsent: () => entry.nbCount);
//     }
//     return entityTypeCounts.entries
//         .map((entry) => _SalesData('', 0, '', entry.key, '', '', entry.value))
//         .toList();
//   }
// }

// class _SalesData {
//   _SalesData(
//     this.activationDate,
//     this.tmcode,
//     this.offerName,
//     this.entityTypeName,
//     this.entityName,
//     this.sellerId,
//     this.nbCount,
//   );

//   final String activationDate;
//   final int tmcode;
//   final String offerName;
//   final String entityTypeName;
//   final String entityName;
//   final String sellerId;
//   final int nbCount;
// }

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:my_dash/services/activation_client_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageC extends StatefulWidget {
  PageC({Key? key}) : super(key: key);

  @override
  PageCState createState() => PageCState();
}

class PageCState extends State<PageC> {
  List<_SalesData> data = [];
  List<String> dateList = [];
  List<String> selectedDates = [];
  List<String> offerNames = [];
  List<String> selectedOfferNames = [];
  List<String> entityNames = [];
  List<String> selectedEntityNames = [];
  bool loading = true;
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('userRole') ?? '';
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      ApiService apiService = ApiService();
      List<dynamic> fetchedData = await apiService.fetchData();

      data = fetchedData.map<_SalesData>((item) {
        return _SalesData(
          item['activation_date'],
          item['tmcode'],
          item['offer_name'],
          item['entity_type_name'],
          item['entity_name'],
          item['seller_id'],
          item['nbr_transaction'],
        );
      }).toList();

      dateList =
          data.map((salesData) => salesData.activationDate).toSet().toList();
      offerNames =
          data.map((salesData) => salesData.offerName).toSet().toList();
      entityNames =
          data.map((salesData) => salesData.entityName).toSet().toList();

      setState(() {
        loading = false;
        selectedDates = [];
        selectedOfferNames = [];
        selectedEntityNames = [];
      });
    } catch (e) {
      print("Error loading/processing data: $e");
    }
  }

  List<_SalesData> getFilteredData() {
    return data.where((d) {
      bool dateCondition =
          selectedDates.isEmpty || selectedDates.contains(d.activationDate);
      bool offerCondition = selectedOfferNames.isEmpty ||
          selectedOfferNames.contains(d.offerName);
      bool entityCondition =
          userRole == 'full' || d.entityName == 'Franchise Mourouj 4';
      return dateCondition && offerCondition && entityCondition;
    }).toList();
  }

  List<_SalesData> getTop5Data(
      List<_SalesData> list, double Function(_SalesData) getValue) {
    list.sort((a, b) => getValue(b).compareTo(getValue(a)));
    return list.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KPIs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dates filter (unchanged)
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Dates:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: dateList.map((date) {
                            bool isSelected = selectedDates.contains(date);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedDates.remove(date);
                                    } else {
                                      selectedDates.add(date);
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isSelected ? Colors.black : null,
                                ),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Entity name filter (conditionally shown)
                if (userRole != 'restricted')
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Entity name:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: entityNames.map((entity) {
                              bool isSelected =
                                  selectedEntityNames.contains(entity);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedEntityNames.remove(entity);
                                      } else {
                                        selectedEntityNames.add(entity);
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isSelected ? Colors.black : null,
                                  ),
                                  child: Text(
                                    entity,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Charts
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Bar chart based on selected dates and selected offer names
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(8.0),
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(
                              text: selectedDates.isEmpty
                                  ? 'Offer count by Seller'
                                  : 'Bar Chart for ${selectedDates.join(", ")}',
                            ),
                            legend: Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <CartesianSeries<_SalesData, String>>[
                              BarSeries<_SalesData, String>(
                                color: Color.fromARGB(223, 255, 115, 34),
                                dataSource: getFilteredData()
                                    .where((d) =>
                                        selectedOfferNames.isEmpty ||
                                        selectedOfferNames
                                            .contains(d.offerName))
                                    .toList(),
                                xValueMapper: (_SalesData sales, _) =>
                                    sales.sellerId,
                                yValueMapper: (_SalesData sales, _) =>
                                    sales.nbrTransaction.toDouble(),
                                name: 'Offer Count',
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                                pointColorMapper: (_SalesData sales, _) {
                                  double maxVal = selectedDates.isEmpty
                                      ? data
                                          .map((d) =>
                                              d.nbrTransaction.toDouble())
                                          .reduce((a, b) => a > b ? a : b)
                                      : data
                                          .where((d) => selectedDates
                                              .contains(d.activationDate))
                                          .map((d) =>
                                              d.nbrTransaction.toDouble())
                                          .reduce((a, b) => a > b ? a : b);

                                  return sales.nbrTransaction.toDouble() ==
                                          maxVal
                                      ? Colors.red
                                      : Color.fromARGB(223, 255, 115, 34);
                                },
                              ),
                            ],
                          ),
                        ),
                        // Line chart
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(text: 'Offer count by Seller'),
                            legend: Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <CartesianSeries<_SalesData, String>>[
                              LineSeries<_SalesData, String>(
                                dataSource: getFilteredData(),
                                xValueMapper: (_SalesData sales, _) =>
                                    sales.sellerId,
                                yValueMapper: (_SalesData sales, _) =>
                                    sales.nbrTransaction.toDouble(),
                                name: 'Offer Name Count',
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                              ),
                            ],
                          ),
                        ),
                        // Another bar chart based on selected dates and selected entity names
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(8.0),
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(
                              text: selectedDates.isEmpty
                                  ? 'Offer count by Entity'
                                  : 'Bar Chart for ${selectedDates.join(", ")} by Entity',
                            ),
                            legend: Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <CartesianSeries<_SalesData, String>>[
                              BarSeries<_SalesData, String>(
                                color: Color.fromARGB(223, 61, 150,
                                    215), // Adjust color as needed
                                dataSource: getFilteredData()
                                    .where((d) =>
                                        selectedEntityNames.isEmpty ||
                                        selectedEntityNames
                                            .contains(d.entityName))
                                    .toList(),
                                xValueMapper: (_SalesData sales, _) =>
                                    sales.entityName,
                                yValueMapper: (_SalesData sales, _) =>
                                    sales.nbrTransaction.toDouble(),
                                name: 'Offer Count by Entity',
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                              ),
                            ],
                          ),
                        ),
                        // Pie chart classifying entity_name by entity_type_name
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(8.0),
                          child: SfCircularChart(
                            title: ChartTitle(
                                text: 'Entity Classification by Type'),
                            legend: Legend(isVisible: true),
                            series: <CircularSeries<_SalesData, String>>[
                              PieSeries<_SalesData, String>(
                                dataSource: getEntityTypeSummary(),
                                xValueMapper: (_SalesData data, _) =>
                                    data.entityTypeName,
                                yValueMapper: (_SalesData data, _) =>
                                    data.nbrTransaction.toDouble(),
                                dataLabelMapper: (_SalesData data, _) =>
                                    data.entityTypeName,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<_SalesData> getEntityTypeSummary() {
    Map<String, int> entityTypeCounts = {};
    for (var entry in data) {
      entityTypeCounts.update(
          entry.entityTypeName, (value) => value + entry.nbrTransaction,
          ifAbsent: () => entry.nbrTransaction);
    }
    return entityTypeCounts.entries
        .map((entry) => _SalesData('', 0, '', entry.key, '', '', entry.value))
        .toList();
  }
}

class _SalesData {
  _SalesData(
    this.activationDate,
    this.tmcode,
    this.offerName,
    this.entityTypeName,
    this.entityName,
    this.sellerId,
    this.nbrTransaction,
  );

  final String activationDate;
  final int tmcode;
  final String offerName;
  final String entityTypeName;
  final String entityName;
  final String sellerId;
  final int nbrTransaction;
}
