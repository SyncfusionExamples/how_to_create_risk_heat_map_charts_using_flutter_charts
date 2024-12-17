import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HeatMapChart(),
    );
  }
}

class HeatMapChart extends StatefulWidget {
  const HeatMapChart({super.key});

  @override
  HeatMapChartState createState() => HeatMapChartState();
}

class HeatMapChartState extends State<HeatMapChart> {
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
            label = 'Year: ${data.year}, 3M: ${data.return3Months}%';
            break;
          case 1:
            label = 'Year: ${data.year}, 6M: ${data.return6Months}%';
            break;
          case 2:
            label = 'Year: ${data.year}, 1Y: ${data.return1Year}%';
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
      _SP500ReturnData(1987, 10, 0.1, 1.7, 7.5),
      _SP500ReturnData(1989, 10, 7.4, 7.5, 11.9),
      _SP500ReturnData(1995, 10, 10, 5.1, 13.4),
      _SP500ReturnData(1998, 10, 17.2, 26.5, 27.3),
      _SP500ReturnData(2001, 10, -16.3, -12.4, -14.9),
      _SP500ReturnData(2007, 10, -4.4, -11.8, -27.2),
      _SP500ReturnData(2019, 10, 3.8, 13.3, 14.5),
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
      case var val when val >= 2.5:
        return Colors.orange.shade200; // Lightest orange
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
        ),
      ),
      primaryXAxis: const CategoryAxis(
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          color: Colors.white,
        ),
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(width: 0),
        isInversed: true,
        title: AxisTitle(
          text: 'Year of First Rate Cut',
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        majorGridLines: MajorGridLines(width: 0),
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
                start: 5, end: 30, text: '3 months after \n rate cut'),
            NumericMultiLevelLabel(
                start: 40, end: 60, text: '6 months after \n rate cut'),
            NumericMultiLevelLabel(
              start: 70,
              end: 95,
              text: '1 year after \n rate cut',
            ),
          ]),
      series: _getStackedColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<CartesianSeries<_SP500ReturnData, String>> _getStackedColumnSeries() {
    return <CartesianSeries<_SP500ReturnData, String>>[
      StackedColumn100Series<_SP500ReturnData, String>(
        dataSource: _heatMapData!,
        borderWidth: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        width: 1,
        borderColor: Colors.blueGrey.shade900,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.return3Months),
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return Text(
              '${data.return3Months.toString()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.white,
              ),
            );
          },
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
        xValueMapper: (_SP500ReturnData sales, int index) =>
            sales.year.toString(),
        yValueMapper: (_SP500ReturnData sales, int index) =>
            sales.returnValueIndicator,
        name: '3 Months After',
      ),
      StackedColumn100Series<_SP500ReturnData, String>(
        dataSource: _heatMapData!,
        borderWidth: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        width: 1,
        borderColor: Colors.blueGrey.shade900,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.return6Months),
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return Text(
              '${data.return6Months.toString()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.white,
              ),
            );
          },
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
        xValueMapper: (_SP500ReturnData sales, int index) =>
            sales.year.toString(),
        yValueMapper: (_SP500ReturnData sales, int index) =>
            sales.returnValueIndicator,
        name: '6 Months After',
      ),
      StackedColumn100Series<_SP500ReturnData, String>(
        dataSource: _heatMapData!,
        borderWidth: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        width: 1,
        borderColor: Colors.blueGrey.shade900,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.return1Year),
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return Text(
              '${data.return1Year.toString()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.white,
              ),
            );
          },
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
        xValueMapper: (_SP500ReturnData sales, int index) =>
            sales.year.toString(),
        yValueMapper: (_SP500ReturnData sales, int index) =>
            sales.returnValueIndicator,
        name: '1 Year After',
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
    this.return3Months,
    this.return6Months,
    this.return1Year,
  );

  final int year;
  final num returnValueIndicator;
  final num return3Months;
  final num return6Months;
  final num return1Year;
}
