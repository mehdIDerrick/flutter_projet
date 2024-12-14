import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:my_dash/services/activation_client_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/services.dart'; // Import for controlling screen orientation

class Page2 extends StatefulWidget {
  Page2({Key? key}) : super(key: key);

  @override
  Page2State createState() => Page2State();
}

class Page2State extends State<Page2> {
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
    _loadSelectedFilters(); // Ajouter cette ligne pour charger les filtres sélectionnés
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

  Future<void> _loadSelectedFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedTransactionDatesJson =
        prefs.getString('selectedTransactionDates');
    List<String>? storedEntityTypeNames =
        prefs.getStringList('selectedEntityTypeNames');

    if (selectedTransactionDatesJson != null) {
      setState(() {
        selectedTransactionDates =
            jsonDecode(selectedTransactionDatesJson).cast<String>();
      });
    }
    if (storedEntityTypeNames != null) {
      setState(() {
        selectedEntityTypeNames = storedEntityTypeNames;
      });
    }
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

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('userRole') ?? '';
    await _loadDataFromLocalStorage();
  }

  Future<void> _loadDataFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('salesData');
    String systemDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? salesDatatime = prefs.getString('salesDatatime');
    if (jsonData != null && salesDatatime == systemDate) {
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

      setState(() {
        loading = false;
        selectedActivationDates = [];
        selectedTransactionDates = last7TransactionDates;
        selectedOfferNames = [];
        //selectedEntityTypeNames = userRole == 'restricted' ? ['FRANCHISE'] : [];
        selectedEntityTypeNames =
            prefs.getStringList('selectedEntityTypeNames') ?? [];
      });
      transactionMonths = extractMonths(transactionDateList);
    } else {
      await fetchData();
    }
  }

  Future<void> fetchData() async {
    setState(() {
      loading = true;
    });
    try {
      ApiService apiService = ApiService();
      List<dynamic> fetchedData = await apiService.fetchData();
      print(fetchedData);
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

      // Save data to local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('salesData', jsonEncode(fetchedData));
      String systemDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      prefs.setString('salesDatatime', systemDate);
      // Load saved filters
      selectedTransactionDates =
          prefs.getStringList('selectedTransactionDates') ?? [];
      selectedEntityTypeNames = prefs.getStringList('entity_type_name') ?? [];

      setState(() {
        loading = false;
        selectedActivationDates = [];
        if (selectedTransactionDates.isEmpty) {
          // Obtenir les dates distinctes de transaction
          List<String> distinctTransactionDates =
              transactionDateList.toSet().toList();

          // Trier les dates par ordre décroissant
          distinctTransactionDates.sort((a, b) => b.compareTo(a));

          // Sélectionner les 7 dernières dates
          List<String> last7TransactionDates =
              distinctTransactionDates.take(7).toList();
        }
        selectedOfferNames = [];
        if (selectedEntityTypeNames.isEmpty && userRole == 'restricted') {
          selectedEntityTypeNames = ['FRANCHISE'];
        }
      });
      transactionMonths = extractMonths(transactionDateList);
    } catch (e) {
      print("Error loading/processing data: $e");
    }
  }

  //get filterdata

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

  List<_SalesData> getFilteredDataByDate() {
    return getFilteredData()
        .where((d) => selectedTransactionDates.contains(d.transactionDate))
        .toList();
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

  List<StackedColumnSeries<_BarDatac, String>> getBarChartDatac() {
    List<_SalesData> filteredData = getFilteredData();

    // Convert _SalesData to _BarDatac
    List<_BarDatac> data = filteredData.map((entry) {
      return _BarDatac(
        entry.transactionDate, // Assuming this is `activationDate`
        entry.entityTypeName,
        entry.nbrActivation.toDouble(),
      );
    }).toList();

    // Group data by `entityTypeName`
    Map<String, List<_BarDatac>> groupedData = {};
    for (var entry in data) {
      if (!groupedData.containsKey(entry.entityTypeName)) {
        groupedData[entry.entityTypeName] = [];
      }
      groupedData[entry.entityTypeName]!.add(entry);
    }

    // Create a series for each `entityTypeName`
    return groupedData.entries.map((entry) {
      return StackedColumnSeries<_BarDatac, String>(
        dataSource: entry.value,
        xValueMapper: (_BarDatac data, _) => data.activationDate,
        yValueMapper: (_BarDatac data, _) => data.nbrActivation,
        name: entry.key, // Use `entityTypeName` as legend name
      );
    }).toList();
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

  List<_LineData> getLineChartData1() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Boutique Vente:',
              style: TextStyle(
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
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Add vertical scrolling
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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

// Transaction Month Filter
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Month:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: transactionMonths.map((month) {
                              bool isSelected = selectedMonth == month;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
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
                                  onPressed: () async {
                                    setState(() {
                                      if (isSelected) {
                                        selectedTransactionDates.remove(date);
                                      } else {
                                        selectedTransactionDates.add(date);
                                      }
                                    });

                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString("selectedTransactionDates",
                                        selectedTransactionDates.toString());
                                    print(
                                        "selectedTransactionDates$selectedEntityTypeNames");
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
                                  onPressed: () async {
                                    setState(() {
                                      if (isSelected) {
                                        selectedEntityTypeNames
                                            .remove(entityTypeName);
                                      } else {
                                        selectedEntityTypeNames
                                            .add(entityTypeName);
                                      }
                                    });
                                    _saveSelectedFilters(
                                        selectedEntityTypeNames);
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
                  //       text: "Valeurs de transaction et d'activation par jour",
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

                  // Doughnut Chart
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
                      //  title: ChartTitle(text: 'Performance By Date'),
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
                          name: 'Nbr Activation J',
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
                  // Bar Chart with Stacked Bar Graph
                  Container(
                    height: 300,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelRotation: -60,
                        interval: 1,
                        labelIntersectAction: AxisLabelIntersectAction.none,
                      ),
                      title: ChartTitle(
                        text: 'Activation Groupée par Type et Date',
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series:
                          getBarChartDatac(), // Dynamically generated series
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Future<void> _saveSelectedFilters(List<String> selectedEntityTypeNames) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('selectedEntityTypeNames', selectedEntityTypeNames);
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

class _BarData {
  _BarData(this.date, this.nbrTransaction, this.nbrActivation);

  final String date;
  double nbrTransaction;
  double nbrActivation;
}

class _BarDatac {
  _BarDatac(this.activationDate, this.entityTypeName, this.nbrActivation);

  final String activationDate; // Date for the X-axis
  final String entityTypeName; // Grouping category (e.g., "Agence Trade")
  final double nbrActivation; // Activation count for Y-axis
}
// class _DoughnutData {
//   _DoughnutData(this.date, this.value);

//   final String date;
//   final double value;
// }
class _LineData {
  _LineData(this.date, this.value);
  final String date;
  final double value;
}

class _DoughnutData {
  _DoughnutData(this.label, this.value, this.color);

  final String label;
  final double value;
  final Color color;
}

class _RadialGaugeData {
  _RadialGaugeData(this.label, this.value, this.color);

  final String label;
  final double value;
  final Color color;
}