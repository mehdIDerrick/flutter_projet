import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_dash/Layout/Profile.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:my_dash/services/activation_client_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/services.dart'; // Import for controlling screen orientation

class PageChartDetailedPerf extends StatefulWidget {
  final String entityName;

  const PageChartDetailedPerf({Key? key, required this.entityName})
      : super(key: key);

  @override
  _PageChartDetailedPerfState createState() => _PageChartDetailedPerfState();
}

class _PageChartDetailedPerfState extends State<PageChartDetailedPerf> {
  List<_SalesData> data = [];
  List<String> activationDateList = [];
  List<String> selectedActivationDates = [];
  List<String> transactionDateList = [];
  List<String> selectedTransactionDates = [];
  List<String> offerNames = [];
  List<String> selectedOfferNames = [];
  List<String> entityTypeNames = [];
  List<String> selectedEntityTypeNames = [];
  bool loading = true;
  String userRole = '';
  List<String> transactionMonths = [];
  String? selectedMonth;
  @override
  void initState() {
    super.initState();
    _loadUserRole();
    // Set the preferred orientations to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Reset the preferred orientations to allow all orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  List<String> extractMonths(List<String> dates) {
    final Set<String> months = {};
    for (var date in dates) {
      final parsedDate = DateTime.parse(date);
      final month = DateFormat('yyyy-MM').format(parsedDate);
      months.add(month);
    }
    return months.toList()..sort((a, b) => b.compareTo(a));
  }

  Future<void> _loadDataFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('salesData');

    if (jsonData != null) {
      List<dynamic> decodedData = jsonDecode(jsonData);
      data = decodedData.map<_SalesData>((item) {
        return _SalesData(
          item['activation_date'] ?? '',
          item['trnsaction_date'] ?? '',
          item['tmcode'] ?? 0,
          item['offer_name'] ?? '',
          item['entity_type_name'] ?? '',
          item['entity_name'] ?? '',
          item['seller_id'] ?? '',
          item['nbr_transaction'] ?? 0,
          item['nbr_activation'] ?? 0,
          item['taux_conversion_global'] ?? 0.0,
        );
      }).toList();

      activationDateList =
          data.map((salesData) => salesData.activationDate).toSet().toList();
      transactionDateList =
          data.map((salesData) => salesData.transactionDate).toSet().toList();
      offerNames =
          data.map((salesData) => salesData.offerName).toSet().toList();
      entityTypeNames =
          data.map((salesData) => salesData.entityTypeName).toSet().toList();
      // Obtenir les dates distinctes de transaction
      List<String> distinctTransactionDates =
          transactionDateList.toSet().toList();

      // Trier les dates par ordre décroissant
      distinctTransactionDates.sort((a, b) => b.compareTo(a));

      // Sélectionner les 7 dernières dates
      List<String> last7TransactionDates =
          distinctTransactionDates.take(7).toList();

      selectedTransactionDates = last7TransactionDates;

      setState(() {
        loading = false;
        selectedActivationDates = [];
        selectedTransactionDates = last7TransactionDates;
        transactionMonths = extractMonths(transactionDateList);

        selectedOfferNames = [];
        selectedEntityTypeNames = userRole == 'restricted' ? ['FRANCHISE'] : [];
      });
    } else {
      await fetchData();
    }
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('userRole') ?? '';
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonData = prefs.getString('salesData');
      List<dynamic> fetchedData = [];

      if (jsonData != null) {
        List<dynamic> allData = json.decode(jsonData);
        fetchedData = allData
            .where((item) => item['entity_name'] == widget.entityName)
            .toList();
      }

      if (fetchedData.isEmpty) {
        String? jsonData = prefs.getString('salesData');
        fetchedData = json.encode(jsonData) as List;
        // Stocker toutes les données dans SharedPreferences
      }

      data = fetchedData.map<_SalesData>((item) {
        return _SalesData(
          item['activation_date'] ?? '',
          item['trnsaction_date'] ?? '',
          item['tmcode'] ?? 0,
          item['offer_name'] ?? '',
          item['entity_type_name'] ?? '',
          item['entity_name'] ?? '',
          item['seller_id'] ?? '',
          item['nbr_transaction'] ?? 0,
          item['nbr_activation'] ?? 0,
          item['taux_conversion_global'] ?? 0.0,
        );
      }).toList();

      activationDateList =
          data.map((salesData) => salesData.activationDate).toSet().toList();
      transactionDateList =
          data.map((salesData) => salesData.transactionDate).toSet().toList();
      offerNames =
          data.map((salesData) => salesData.offerName).toSet().toList();
      entityTypeNames =
          data.map((salesData) => salesData.entityTypeName).toSet().toList();

      // Calculate the best entity type based on sum of nbrTransaction and nbrActivation
      Map<String, int> entityTypeTransactionSum = {};
      Map<String, int> entityTypeActivationSum = {};

      for (var entry in data) {
        if (entityTypeTransactionSum.containsKey(entry.entityTypeName)) {
          entityTypeTransactionSum[entry.entityTypeName] =
              entityTypeTransactionSum[entry.entityTypeName]! +
                  entry.nbrTransaction;
        } else {
          entityTypeTransactionSum[entry.entityTypeName] = entry.nbrTransaction;
        }

        if (entityTypeActivationSum.containsKey(entry.entityTypeName)) {
          entityTypeActivationSum[entry.entityTypeName] =
              entityTypeActivationSum[entry.entityTypeName]! +
                  entry.nbrActivation;
        } else {
          entityTypeActivationSum[entry.entityTypeName] = entry.nbrActivation;
        }
      }

      String bestEntityType =
          entityTypeNames.isNotEmpty ? entityTypeNames.first : '';
      int maxTransactionSum = 0;
      int maxActivationSum = 0;

      entityTypeTransactionSum.forEach((entityType, sum) {
        if (sum > maxTransactionSum) {
          maxTransactionSum = sum;
          bestEntityType = entityType;
        }
      });

      entityTypeActivationSum.forEach((entityType, sum) {
        if (sum > maxActivationSum) {
          maxActivationSum = sum;
          bestEntityType = entityType;
        }
      });

      // Obtenir les dates distinctes de transaction
      List<String> distinctTransactionDates =
          transactionDateList.toSet().toList();

      // Trier les dates par ordre décroissant
      distinctTransactionDates.sort((a, b) => b.compareTo(a));

      // Sélectionner les 7 dernières dates
      List<String> last7TransactionDates =
          distinctTransactionDates.take(7).toList();
      setState(() {
        loading = false;
        selectedActivationDates = [];
        selectedTransactionDates = last7TransactionDates;
        transactionMonths = extractMonths(transactionDateList);

        selectedOfferNames = [];
        selectedEntityTypeNames = userRole == 'restricted' ? ['FRANCHISE'] : [];
      });
    } catch (e) {
      print("Error loading/processing data: $e");
    }
  }

  List<_SalesData> getFilteredData() {
    return data.where((d) {
      bool activationDateCondition = selectedActivationDates.isEmpty ||
          selectedActivationDates.contains(d.activationDate);
      bool transactionDateCondition = selectedTransactionDates.isEmpty ||
          selectedTransactionDates.contains(d.transactionDate);
      bool offerCondition = selectedOfferNames.isEmpty ||
          selectedOfferNames.contains(d.offerName);
      bool entityTypeCondition = selectedEntityTypeNames.isEmpty ||
          selectedEntityTypeNames.contains(d.entityTypeName);
      return activationDateCondition &&
          transactionDateCondition &&
          offerCondition &&
          entityTypeCondition;
    }).toList();
  }

  List<_PieData> getPieChartData() {
    List<_SalesData> filteredData = getFilteredData();
    int totalTransactions = 0;
    int totalActivations = 0;

    for (var entry in filteredData) {
      totalTransactions += entry.nbrTransaction;
      totalActivations += entry.nbrActivation;
    }

    return [
      _PieData('Nbr Transaction', totalTransactions.toDouble(), Colors.blue,
          'Nbr Transaction'),
      _PieData('Nbr Activation', totalActivations.toDouble(), Colors.orange,
          'Nbr Activation'),
    ];
  }

  List<_LinesellerId> getLineChartsellerId() {
    List<_SalesData> filteredData = getFilteredDataByDate();
    Map<String, double> lineDataMap = {};

    for (var entry in filteredData) {
      if (lineDataMap.containsKey(entry.sellerId)) {
        lineDataMap[entry.sellerId] =
            lineDataMap[entry.sellerId]! + entry.tauxConversionGlobal;
      } else {
        lineDataMap[entry.sellerId] = entry.tauxConversionGlobal;
      }
    }

    return lineDataMap.entries
        .map((e) => _LinesellerId(e.key, e.value))
        .toList();
  }

  List<_RadialGaugeData> getRadialGaugeData() {
    List<_SalesData> filteredData = getFilteredData();
    int totalTransactions = 0;
    int totalActivations = 0;

    for (var entry in filteredData) {
      totalTransactions += entry.nbrTransaction;
      totalActivations += entry.nbrActivation;
    }

    double conversionRate = totalActivations > 0
        ? (totalActivations / totalTransactions) * 100
        : 0.0;

    return [
      _RadialGaugeData('Conversion Rate', conversionRate, Colors.green),
    ];
  }

  List<_BarDataSellerid> getBarChartsellerId() {
    List<_SalesData> filteredData = getFilteredDataByDate();
    Map<String, _BarDataSellerid> barDataMap = {};

    for (var entry in filteredData) {
      if (barDataMap.containsKey(entry.sellerId)) {
        barDataMap[entry.sellerId]!.nbrTransaction +=
            entry.nbrTransaction.toDouble();
        barDataMap[entry.sellerId]!.nbrActivation +=
            entry.nbrActivation.toDouble();
      } else {
        barDataMap[entry.sellerId] = _BarDataSellerid(
          entry.sellerId,
          entry.nbrTransaction.toDouble(),
          entry.nbrActivation.toDouble(),
        );
      }
    }

    return barDataMap.values.toList();
  }

  List<_LineData> getLineChartData() {
    List<_SalesData> filteredData = getFilteredDataByDate();
    Map<String, double> lineDataMap = {};

    for (var entry in filteredData) {
      if (lineDataMap.containsKey(entry.transactionDate)) {
        lineDataMap[entry.transactionDate] =
            lineDataMap[entry.transactionDate]! + entry.tauxConversionGlobal;
      } else {
        lineDataMap[entry.transactionDate] = entry.tauxConversionGlobal;
      }
    }

    return lineDataMap.entries.map((e) => _LineData(e.key, e.value)).toList();
  }

  List<_SalesData> getFilteredDataByDate() {
    return getFilteredData()
        .where((d) => selectedTransactionDates.contains(d.transactionDate))
        .toList();
  }

  List<_BarData> getBarChartDataC() {
    List<_SalesData> filteredData = getFilteredDataByDate();
    Map<String, _BarData> barDataMap = {};

    for (var entry in filteredData) {
      if (barDataMap.containsKey(entry.transactionDate)) {
        barDataMap[entry.transactionDate]!.nbrTransaction +=
            entry.nbrTransaction.toDouble();
        barDataMap[entry.transactionDate]!.nbrActivation +=
            entry.nbrActivation.toDouble();
      } else {
        barDataMap[entry.transactionDate] = _BarData(
            entry.transactionDate, // or entry.activationDate if needed
            entry.nbrTransaction.toDouble(),
            entry.nbrActivation.toDouble());
      }
    }

    return barDataMap.values.toList();
  }

  List<_BarData> getBarChartData() {
    List<_SalesData> filteredData = getFilteredDataByDate();
    Map<String, _BarData> barDataMap = {};

    for (var entry in filteredData) {
      if (barDataMap.containsKey(entry.transactionDate)) {
        barDataMap[entry.transactionDate]!.nbrTransaction +=
            entry.nbrTransaction.toDouble();
        barDataMap[entry.transactionDate]!.nbrActivation +=
            entry.nbrActivation.toDouble();
      } else {
        barDataMap[entry.transactionDate] = _BarData(entry.transactionDate,
            entry.nbrTransaction.toDouble(), entry.nbrActivation.toDouble());
      }
    }

    return barDataMap.values.toList();
  }

  List<_DoughnutData> getDoughnutChartData() {
    List<_SalesData> filteredData = getFilteredData();
    int totalTransactions = 0;
    int totalActivations = 0;

    for (var entry in filteredData) {
      totalTransactions += entry.nbrTransaction;
      totalActivations += entry.nbrActivation;
    }

    double conversionRate = totalActivations > 0
        ? (totalActivations / totalTransactions) * 100
        : 0.0;
    double noConversionRate = 100 - conversionRate;

    return [
      _DoughnutData('Conversion Rate', conversionRate, Colors.green),
      _DoughnutData('No Conversion Rate', noConversionRate, Colors.red),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance ${widget.entityName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Mob PREP aux client Data',
              style: TextStyle(
                fontSize: 14.0, // Adjust the size as needed
                color: Colors.grey, // Adjust the color as needed
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to the profile page when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Add vertical scrolling
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Unselect all button

                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 8.0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Clear button
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedTransactionDates.clear();
                                      selectedActivationDates.clear();
                                      selectedOfferNames.clear();
                                      selectedEntityTypeNames.clear();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.white, // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Rounded corners
                                    ),
                                    side: BorderSide(
                                        color: Colors.black,
                                        width: 1.0), // Border color and width
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10.0), // Button padding
                                    minimumSize: Size(
                                        120, 40), // Button size (width, height)
                                  ),
                                  child: Text(
                                    'clear',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          14, // Adjust the font size as needed
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Transaction Dates Filter
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Mois:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedTransactionDates.clear();
                                    selectedActivationDates.clear();
                                    selectedOfferNames.clear();
                                    selectedEntityTypeNames.clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                  'Clear Filters',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ...transactionMonths.map((month) {
                                bool isSelected = selectedMonth == month;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        if (isSelected) {
                                          selectedMonth = null;
                                        } else {
                                          selectedMonth = month;
                                          selectedTransactionDates =
                                              transactionDateList
                                                  .where((date) =>
                                                      date.startsWith(month))
                                                  .toList();
                                        }
                                      });

                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setStringList(
                                          "selectedTransactionDates",
                                          selectedTransactionDates);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isSelected ? Colors.black : null,
                                    ),
                                    child: Text(
                                      month,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Add your other UI components here

                  // Transaction Dates filter
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Date de Transaction:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: transactionDateList.map((date) {
                              bool isSelected =
                                  selectedTransactionDates.contains(date);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedTransactionDates.remove(date);
                                      } else {
                                        selectedTransactionDates.add(date);
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
                  // Entity type name filter
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Canal:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: entityTypeNames.map((entityTypeName) {
                              bool isSelected = selectedEntityTypeNames
                                  .contains(entityTypeName);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedEntityTypeNames
                                            .remove(entityTypeName);
                                      } else {
                                        selectedEntityTypeNames
                                            .add(entityTypeName);
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isSelected ? Colors.black : null,
                                  ),
                                  child: Text(
                                    entityTypeName,
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
                  // Pie Chart
                  // Container(
                  //   height: 300, // Increase the height of the pie chart
                  //   child: SfCircularChart(
                  //     title: ChartTitle(
                  //       text: "Valeurs de transaction et d'activation par date",
                  //       textStyle: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     legend: Legend(
                  //       isVisible: true,
                  //       overflowMode: LegendItemOverflowMode.wrap,
                  //     ),
                  //     series: <CircularSeries<_PieData, String>>[
                  //       PieSeries<_PieData, String>(
                  //         dataSource: getPieChartData(),
                  //         xValueMapper: (_PieData data, _) => data.xData,
                  //         yValueMapper: (_PieData data, _) => data.value,
                  //         dataLabelMapper: (_PieData data, _) =>
                  //             '${data.text}: ${data.value}',
                  //         dataLabelSettings: DataLabelSettings(
                  //           isVisible: true,
                  //           textStyle: TextStyle(
                  //             color: Colors
                  //                 .black, // Set the color of the data labels to black
                  //           ),
                  //         ),
                  //         pointColorMapper: (_PieData data, _) => data.color,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // // Radial Gauge
                  // Container(
                  //   height: 300, // Adjusted height to accommodate the title
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         'Taux de conversion',
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: SfRadialGauge(
                  //           axes: <RadialAxis>[
                  //             RadialAxis(
                  //               minimum: 0,
                  //               maximum: 100,
                  //               startAngle: 180,
                  //               endAngle: 0,
                  //               ranges: <GaugeRange>[
                  //                 GaugeRange(
                  //                     startValue: 0,
                  //                     endValue: 35,
                  //                     color: Colors.red),
                  //                 GaugeRange(
                  //                     startValue: 35,
                  //                     endValue: 70,
                  //                     color: Colors.yellow),
                  //                 GaugeRange(
                  //                     startValue: 70,
                  //                     endValue: 100,
                  //                     color: Colors.green),
                  //               ],
                  //               pointers: <GaugePointer>[
                  //                 NeedlePointer(
                  //                     value: getRadialGaugeData().first.value),
                  //               ],
                  //               annotations: <GaugeAnnotation>[
                  //                 GaugeAnnotation(
                  //                   widget: Container(
                  //                     child: Text(
                  //                       '${getRadialGaugeData().first.value.toStringAsFixed(2)}%',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.bold,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   angle: 0,
                  //                   positionFactor: 0.5,
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Container(
                  //   height: 300,
                  //   child: SfCircularChart(
                  //     title: ChartTitle(
                  //       text: 'Taux de conversion VS Taux de non conversion',
                  //       textStyle: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     legend: Legend(
                  //       isVisible: true,
                  //       overflowMode: LegendItemOverflowMode.wrap,
                  //     ),
                  //     series: <CircularSeries<_DoughnutData, String>>[
                  //       DoughnutSeries<_DoughnutData, String>(
                  //         dataSource: getDoughnutChartData(),
                  //         xValueMapper: (_DoughnutData data, _) => data.label,
                  //         yValueMapper: (_DoughnutData data, _) => data.value,
                  //         dataLabelMapper: (_DoughnutData data, _) =>
                  //             ' ${data.value.toStringAsFixed(2)}%',
                  //         dataLabelSettings: DataLabelSettings(
                  //           isVisible: true,
                  //           textStyle: TextStyle(
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //         pointColorMapper: (_DoughnutData data, _) =>
                  //             data.color,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Bar Chart
                  Container(
                    height: 300, // Increase the height of the bar chart
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelRotation: -60, // Rotate labels to be vertical
                        interval: 1, // Set the interval between labels
                        desiredIntervals:
                            5, // Set desired intervals between labels
                        labelIntersectAction: AxisLabelIntersectAction
                            .none, // Avoid label intersection
                      ),
                      title: ChartTitle(
                        text: 'Comparaison Activation de Semaine',
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries>[
                        ColumnSeries<_BarData, String>(
                          dataSource: getBarChartData(),
                          xValueMapper: (_BarData sales, _) => sales.date,
                          yValueMapper: (_BarData sales, _) =>
                              sales.nbrTransaction,
                          name: 'Nbr Activation',
                          color: Colors.blue,
                        ),
                        ColumnSeries<_BarData, String>(
                          dataSource: getBarChartData(),
                          xValueMapper: (_BarData sales, _) => sales.date,
                          yValueMapper: (_BarData sales, _) =>
                              sales.nbrActivation,
                          name: 'Nbr Activation',
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      // Fixed title
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Taux de conversion par jour',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Fixed legend
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.line_axis_sharp, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Global Conversion Rate'),
                          ],
                        ),
                      ),
                      // Scrollable chart
                      Container(
                        height: 300,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: 800, // Adjust the width as needed
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                labelRotation:
                                    -60, // Rotate labels to be vertical
                                interval: 1, // Set the interval between labels
                                desiredIntervals:
                                    5, // Set desired intervals between labels
                                labelIntersectAction: AxisLabelIntersectAction
                                    .none, // Avoid label intersection
                              ),
                              primaryYAxis: NumericAxis(),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              legend: Legend(
                                  isVisible: true,
                                  toggleSeriesVisibility: true),
                              series: <CartesianSeries<dynamic, dynamic>>[
                                LineSeries<_LineData, String>(
                                  dataSource: getLineChartData(),
                                  xValueMapper: (_LineData data, _) =>
                                      data.date,
                                  yValueMapper: (_LineData data, _) =>
                                      data.value,
                                  name: 'Global Conversion Rate',
                                  color:
                                      Colors.green, // Set line color to green
                                  dataLabelMapper: (_LineData data, _) =>
                                      '${(data.value * 10).toStringAsFixed(1)}%',
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // Fixed title
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Taux de  non conversion par jour',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Fixed legend
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.line_axis_sharp, color: Colors.red),
                            SizedBox(width: 8),
                            Text('No Conversion Rate'),
                          ],
                        ),
                      ),
                      // Scrollable chart
                      Container(
                        height: 300,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: 800, // Adjust the width as needed
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                labelRotation:
                                    -60, // Rotate labels to be vertical
                                interval: 1, // Set the interval between labels
                                desiredIntervals:
                                    5, // Set desired intervals between labels
                                labelIntersectAction: AxisLabelIntersectAction
                                    .none, // Avoid label intersection
                              ),
                              primaryYAxis: NumericAxis(),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              legend: Legend(
                                  isVisible: true,
                                  toggleSeriesVisibility: true),
                              series: <CartesianSeries<dynamic, dynamic>>[
                                LineSeries<_LineData, String>(
                                  dataSource: getLineChartData(),
                                  xValueMapper: (_LineData data, _) =>
                                      data.date,
                                  yValueMapper: (_LineData data, _) =>
                                      (100 - (data.value * 10)),
                                  name: 'No Conversion Rate',
                                  color: Colors.red,
                                  dataLabelMapper: (_LineData data, _) =>
                                      '${(100 - (data.value * 10)).toStringAsFixed(1)}%',
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      ///Performance par seller
                      Container(
                        height: 300,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelRotation: -60, // Rotate labels to be vertical
                            interval: 1, // Set the interval between labels
                            desiredIntervals:
                                5, // Set desired intervals between labels
                            labelIntersectAction: AxisLabelIntersectAction
                                .none, // Avoid label intersection
                          ),
                          title: ChartTitle(
                            text: 'Performance par seller',
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CartesianSeries>[
                            ColumnSeries<_BarDataSellerid, String>(
                              dataSource: getBarChartsellerId(),
                              xValueMapper: (_BarDataSellerid data, _) =>
                                  data.sellerId,
                              yValueMapper: (_BarDataSellerid data, _) =>
                                  data.nbrTransaction,
                              name: 'Nbr Transaction',
                              color: Colors.blue,
                            ),
                            ColumnSeries<_BarDataSellerid, String>(
                              dataSource: getBarChartsellerId(),
                              xValueMapper: (_BarDataSellerid data, _) =>
                                  data.sellerId,
                              yValueMapper: (_BarDataSellerid data, _) =>
                                  data.nbrActivation,
                              name: 'Nbr Activation',
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),

//getLineChart by sellerId
                      // Fixed title
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Taux de conversion par seller',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Scrollable chart
                      Container(
                        height: 300,
                        width:
                            double.infinity, // Set to fill the available width
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelRotation: -60, // Rotate labels to be vertical
                            interval: 1, // Set the interval between labels
                            desiredIntervals:
                                5, // Set desired intervals between labels
                            labelIntersectAction: AxisLabelIntersectAction
                                .none, // Avoid label intersection
                          ),
                          primaryYAxis: NumericAxis(),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          legend: Legend(
                            isVisible: true,
                            toggleSeriesVisibility: true,
                          ),
                          zoomPanBehavior: ZoomPanBehavior(
                            enablePanning: false, // Disable horizontal swipe
                          ),
                          series: <CartesianSeries<dynamic, dynamic>>[
                            LineSeries<_LinesellerId, String>(
                              dataSource: getLineChartsellerId(),
                              xValueMapper: (_LinesellerId data, _) =>
                                  data.sellerId, // Change to sellerId
                              yValueMapper: (_LinesellerId data, _) =>
                                  data.value,
                              name: 'Global Conversion Rate',
                              color: Colors.green, // Set line color to green
                              dataLabelMapper: (_LinesellerId data, _) =>
                                  '${(data.value * 10).toStringAsFixed(1)}%',
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _SalesData {
  _SalesData(
    this.activationDate,
    this.transactionDate,
    this.tmCode,
    this.offerName,
    this.entityTypeName,
    this.entityName,
    this.sellerId,
    this.nbrTransaction,
    this.nbrActivation,
    this.tauxConversionGlobal,
  );

  final String activationDate;
  final String transactionDate;
  final int tmCode;
  final String offerName;
  final String entityTypeName;
  final String entityName;
  final String sellerId;
  final int nbrTransaction;
  final int nbrActivation;
  final double tauxConversionGlobal;
}

class _PieData {
  _PieData(this.xData, this.value, this.color, this.text);

  final String xData;
  double value;
  final Color color;
  final String text;
}

class _BarDataSellerid {
  final String sellerId;
  double nbrTransaction;
  double nbrActivation;

  _BarDataSellerid(this.sellerId, this.nbrTransaction, this.nbrActivation);
}

class _BarData {
  _BarData(this.date, this.nbrTransaction, this.nbrActivation);

  final String date;
  double nbrTransaction;
  double nbrActivation;
}

class _DoughnutData {
  _DoughnutData(this.label, this.value, this.color);

  final String label;
  final double value;
  final Color color;
}

class _LinesellerId {
  final String sellerId;
  final double value;

  _LinesellerId(this.sellerId, this.value);
}

class _LineData {
  _LineData(this.date, this.value);
  final String date;
  final double value;
}

class _RadialGaugeData {
  _RadialGaugeData(this.label, this.value, this.color);

  final String label;
  final double value;
  final Color color;
}
