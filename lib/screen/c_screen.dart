import 'package:assignment/data/gyro.dart';
import 'package:assignment/data/magneto.dart';
import 'package:flutter/material.dart';
import '../data/accelero.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CcScreen extends StatefulWidget {
  const CcScreen({Key? key, required this.accelerometerData, required this.gyroscopeData, required this.magnetoData}) : super(key: key);
  final List<AccelerometerData> accelerometerData;
  final List<GyroscopeData> gyroscopeData;
  final List<MagnetoData> magnetoData;

  @override
  State<CcScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<CcScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('C Screen'),
        ),
        body: SingleChildScrollView(
            child: Column(
                children: [
                  //Initialize the chart widget
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(text: 'Acceleration Sensor Data'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: false),
                      series: <ChartSeries<AccelerometerData, DateTime>>[
                        LineSeries<AccelerometerData, DateTime>(
                            dataSource: widget.accelerometerData,
                            xValueMapper: (AccelerometerData value, _) => value.getDate,
                            yValueMapper: (AccelerometerData value, _) => value.getValue[0],
                            name: 'X',
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true)),
                        LineSeries<AccelerometerData, DateTime>(
                            dataSource: widget.accelerometerData,
                            xValueMapper: (AccelerometerData value, _) => value.getDate,
                            yValueMapper: (AccelerometerData value, _) => value.getValue[1],
                            name: 'Y',
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true)),
                        LineSeries<AccelerometerData, DateTime>(
                            dataSource: widget.accelerometerData,
                            xValueMapper: (AccelerometerData value, _) => value.getDate,
                            yValueMapper: (AccelerometerData value, _) => value.getValue[2],
                            name: 'Z',
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true))
                      ]),
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(text: 'Gyroscope Sensor Data'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: false),
                      series: <ChartSeries<GyroscopeData, DateTime>>[
                        LineSeries<GyroscopeData, DateTime>(
                            dataSource: widget.gyroscopeData,
                            xValueMapper: (GyroscopeData value, _) => value.getDate,
                            yValueMapper: (GyroscopeData value, _) => value.getValue[0],
                            name: 'X',
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true)),
                        LineSeries<GyroscopeData, DateTime>(
                            dataSource: widget.gyroscopeData,
                            xValueMapper: (GyroscopeData value, _) => value.getDate,
                            yValueMapper: (GyroscopeData value, _) => value.getValue[1],
                            name: 'Y',
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true)),
                        LineSeries<GyroscopeData, DateTime>(
                            dataSource: widget.gyroscopeData,
                            xValueMapper: (GyroscopeData value, _) => value.getDate,
                            yValueMapper: (GyroscopeData value, _) => value.getValue[2],
                            name: 'Z',
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true))
                      ]),
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(text: 'Magneto Sensor Data'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: false),
                      series: <ChartSeries<MagnetoData, DateTime>>[
                        LineSeries<MagnetoData, DateTime>(
                            dataSource: widget.magnetoData,
                            xValueMapper: (MagnetoData value, _) => value.getDate,
                            yValueMapper: (MagnetoData value, _) => value.getValue[0],
                            name: 'X',
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true)),
                        LineSeries<MagnetoData, DateTime>(
                            dataSource: widget.magnetoData,
                            xValueMapper: (MagnetoData value, _) => value.getDate,
                            yValueMapper: (MagnetoData value, _) => value.getValue[1],
                            name: 'Y',
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true)),
                        LineSeries<MagnetoData, DateTime>(
                            dataSource: widget.magnetoData,
                            xValueMapper: (MagnetoData value, _) => value.getDate,
                            yValueMapper: (MagnetoData value, _) => value.getValue[2],
                            name: 'Z',
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true))
                      ]),

                ]
            ),
        )
    );
  }
}