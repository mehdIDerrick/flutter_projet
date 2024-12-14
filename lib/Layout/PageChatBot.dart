import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

class PageChartDetailedPerf extends StatefulWidget {
  final String entityName;

  const PageChartDetailedPerf({Key? key, required this.entityName})
      : super(key: key);

  @override
  _PageChartDetailedPerfState createState() => _PageChartDetailedPerfState();
}

class _PageChartDetailedPerfState extends State<PageChartDetailedPerf> {
  late Future<Map<String, double>> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData(widget.entityName);
  }

  Future<Map<String, double>> fetchData(String entityName) async {
    final response = await http.get(Uri.parse(
        'https://client-data-pwya.onrender.com/get-data/?entity_name=$entityName'));

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> rawData = json.decode(response.body);
      Map<String, double> processedData = rawData.map((key, value) {
        if (value is List) {
          return MapEntry(key, value.length.toDouble());
        } else {
          return MapEntry(key, (value as num).toDouble());
        }
      });
      return processedData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Performance for ${widget.entityName}'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, double>>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available for ${widget.entityName}');
            } else {
              final data = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: SfCircularChart(
                      title: ChartTitle(text: 'Performance KPI'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CircularSeries>[
                        PieSeries<MapEntry<String, double>, String>(
                          dataSource: data.entries.toList(),
                          xValueMapper: (MapEntry<String, double> entry, _) =>
                              entry.key,
                          yValueMapper: (MapEntry<String, double> entry, _) =>
                              entry.value,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: 'Performance by KPI'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries>[
                        BarSeries<MapEntry<String, double>, String>(
                          dataSource: data.entries.toList(),
                          xValueMapper: (MapEntry<String, double> entry, _) =>
                              entry.key,
                          yValueMapper: (MapEntry<String, double> entry, _) =>
                              entry.value,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
