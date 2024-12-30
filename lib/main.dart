import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RiskHeatMapChart(),
    );
  }
}

class RiskHeatMapChart extends StatefulWidget {
  const RiskHeatMapChart({super.key});

  @override
  RiskHeatMapChartState createState() => RiskHeatMapChartState();
}

class RiskHeatMapChartState extends State<RiskHeatMapChart> {
  List<_SP500ReturnData>? _heatMapData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: true,
      tooltipPosition: TooltipPosition.pointer,
      textStyle: const TextStyle(color: Colors.white),
      color: Colors.black87,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        _SP500ReturnData data = _heatMapData![pointIndex];
        String label = '';
        switch (seriesIndex) {
          case 0:
            label =
                'Year: ${data.year.year}, 3M: ${data.threeMonthsAfterFirstRateCut}%';
            break;
          case 1:
            label =
                'Year: ${data.year.year}, 6M: ${data.sixMonthsAfterFirstRateCut}%';
            break;
          case 2:
            label =
                'Year: ${data.year.year}, 1Y: ${data.oneYearAfterFirstRateCut}%';
            break;
        }
        return Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(color: Colors.white)),
        );
      },
    );
    _heatMapData = <_SP500ReturnData>[
      _SP500ReturnData(DateTime(1973), 10, -10.2, -6.2, -36.0),
      _SP500ReturnData(DateTime(1974), 10, -14.7, -15.3, 7.5),
      _SP500ReturnData(DateTime(1980), 10, 15.0, 28.9, 30.3),
      _SP500ReturnData(DateTime(1981), 10, -11.0, -7.9, -17.8),
      _SP500ReturnData(DateTime(1982), 10, -4.8, 17.4, 36.5),
      _SP500ReturnData(DateTime(1987), 10, 0.1, 1.7, 7.5),
      _SP500ReturnData(DateTime(1989), 10, 7.4, 7.5, 11.9),
      _SP500ReturnData(DateTime(1995), 10, 10, 5.1, 13.4),
      _SP500ReturnData(DateTime(1998), 10, 17.2, 26.5, 27.3),
      _SP500ReturnData(DateTime(2001), 10, -16.3, -12.4, -14.9),
      _SP500ReturnData(DateTime(2007), 10, -4.4, -11.8, -27.2),
      _SP500ReturnData(DateTime(2019), 10, 3.8, 13.3, 14.5),
    ];
    super.initState();
  }

  Color _buildColor(num value) {
    switch (value) {
      case var val when val >= 20.0:
        return Colors.green.shade900; // Darkest green
      case var val when val >= 15.0:
        return Colors.green.shade700; // Dark green
      case var val when val >= 10.0:
        return Colors.green.shade500; // Medium green
      case var val when val >= 5.0:
        return Colors.green.shade300; // Light green
      case var val when val > 0.0:
        return Colors.orange.shade400; // Lighter orange
      case var val when val >= -2.5:
        return Colors.orange.shade600; // Medium orange
      case var val when val >= -5.0:
        return Colors.orange.shade800; // Darker orange
      case var val when val >= -10.0:
        return Colors.red.shade200; // Light red
      case var val when val >= -15.0:
        return Colors.red.shade400; // Medium red
      case var val when val >= -20.0:
        return Colors.red.shade600; // Dark red
      default:
        return Colors.red.shade800; // Darkest red
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildSP500Chart());
  }

  SfCartesianChart _buildSP500Chart() {
    return SfCartesianChart(
      backgroundColor: Colors.blueGrey.shade900,
      plotAreaBorderWidth: 0,
      isTransposed: true,
      title: const ChartTitle(
        text: 'S&P 500 Returns After Rate Cuts',
        textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            fontFamily: "Roboto"),
      ),
      primaryXAxis: DateTimeCategoryAxis(
        dateFormat: DateFormat.y(), // Format to display only the year
        intervalType: DateTimeIntervalType.years,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          color: Colors.white,
        ),
        majorTickLines: const MajorTickLines(size: 0),
        axisLine: const AxisLine(width: 0),
        isInversed: true,
        title: const AxisTitle(
          text: 'Year of First Rate Cut',
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        opposedPosition: true,
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorTickLines: const MajorTickLines(size: 0),
        borderWidth: 0,
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        labelStyle: const TextStyle(
          color: Colors.transparent, // Hide default labels
        ),
        multiLevelLabelStyle: const MultiLevelLabelStyle(
            borderWidth: 0, borderColor: Colors.transparent),
        multiLevelLabelFormatter: (MultiLevelLabelRenderDetails details) {
          return ChartAxisLabel(
            details.text,
            const TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          );
        },
        multiLevelLabels: const <NumericMultiLevelLabel>[
          NumericMultiLevelLabel(
              start: 5, end: 30, text: '3 months after \n first rate cut'),
          NumericMultiLevelLabel(
              start: 40, end: 60, text: '6 months after \n first rate cut'),
          NumericMultiLevelLabel(
            start: 70,
            end: 95,
            text: '1 year after \n first rate cut',
          ),
        ],
      ),
      series: _getStackedColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<CartesianSeries<_SP500ReturnData, DateTime>> _getStackedColumnSeries() {
    return <CartesianSeries<_SP500ReturnData, DateTime>>[
      StackedColumn100Series<_SP500ReturnData, DateTime>(
        dataSource: _heatMapData!,
        xValueMapper: (_SP500ReturnData data, int index) => data.year,
        yValueMapper: (_SP500ReturnData data, int index) =>
            data.returnValueIndicator,
        borderWidth: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        width: 1,
        borderColor: Colors.blueGrey.shade900,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.threeMonthsAfterFirstRateCut),
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return Text(
              '${data.threeMonthsAfterFirstRateCut.toString()}%',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white,
                  fontFamily: 'Roboto'),
            );
          },
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
        name: '3 Months After First Rate Cut',
      ),
      StackedColumn100Series<_SP500ReturnData, DateTime>(
        dataSource: _heatMapData!,
        xValueMapper: (_SP500ReturnData data, int index) => data.year,
        yValueMapper: (_SP500ReturnData data, int index) =>
            data.returnValueIndicator,
        borderWidth: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        width: 1,
        borderColor: Colors.blueGrey.shade900,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.sixMonthsAfterFirstRateCut),
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return Text(
              '${data.sixMonthsAfterFirstRateCut.toString()}%',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white,
                  fontFamily: 'Roboto'),
            );
          },
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
        name: '6 Months After First Rate Cut',
      ),
      StackedColumn100Series<_SP500ReturnData, DateTime>(
        dataSource: _heatMapData!,
        xValueMapper: (_SP500ReturnData data, int index) => data.year,
        yValueMapper: (_SP500ReturnData data, int index) =>
            data.returnValueIndicator,
        borderWidth: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        width: 1,
        borderColor: Colors.blueGrey.shade900,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.oneYearAfterFirstRateCut),
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return Text(
              '${data.oneYearAfterFirstRateCut.toString()}%',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white,
                  fontFamily: 'Roboto'),
            );
          },
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
        name: '1 Year After First Rate Cut',
      ),
    ];
  }

  @override
  void dispose() {
    _heatMapData!.clear();
    super.dispose();
  }
}

class _SP500ReturnData {
  _SP500ReturnData(
    this.year,
    this.returnValueIndicator,
    this.threeMonthsAfterFirstRateCut,
    this.sixMonthsAfterFirstRateCut,
    this.oneYearAfterFirstRateCut,
  );

  final DateTime year;
  final num returnValueIndicator;
  final num threeMonthsAfterFirstRateCut;
  final num sixMonthsAfterFirstRateCut;
  final num oneYearAfterFirstRateCut;
}
