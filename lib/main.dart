import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import Charts.
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RiskHeatMap(),
    );
  }
}

class RiskHeatMap extends StatefulWidget {
  const RiskHeatMap({super.key});

  @override
  RiskHeatMapState createState() => RiskHeatMapState();
}

class RiskHeatMapState extends State<RiskHeatMap> {
  List<_SP500ReturnData>? _heatMapData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _heatMapData = <_SP500ReturnData>[
      _SP500ReturnData(DateTime(1973), -10.2, -6.2, -36.0),
      _SP500ReturnData(DateTime(1974), -14.7, -15.3, 7.5),
      _SP500ReturnData(DateTime(1980), 15.0, 28.9, 30.3),
      _SP500ReturnData(DateTime(1981), -11.0, -7.9, -17.8),
      _SP500ReturnData(DateTime(1982), -4.8, 17.4, 36.5),
      _SP500ReturnData(DateTime(1987), 0.1, 1.7, 7.5),
      _SP500ReturnData(DateTime(1989), 7.4, 7.5, 11.9),
      _SP500ReturnData(DateTime(1995), 10, 5.1, 13.4),
      _SP500ReturnData(DateTime(1998), 17.2, 26.5, 27.3),
      _SP500ReturnData(DateTime(2001), -16.3, -12.4, -14.9),
      _SP500ReturnData(DateTime(2007), -4.4, -11.8, -27.2),
      _SP500ReturnData(DateTime(2019), 3.8, 13.3, 14.5),
    ];
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      animationDuration: 0,
      format: 'point.x : point.y%',
      tooltipPosition: TooltipPosition.pointer,
    );
    super.initState();
  }

  Color _buildColor(num value) {
    switch (value) {
      case var val when val >= 20.0:
        return Colors.green.shade900; // Darkest green.
      case var val when val >= 15.0:
        return Colors.green.shade700; // Dark green.
      case var val when val >= 10.0:
        return Colors.green.shade500; // Medium green.
      case var val when val >= 5.0:
        return Colors.green.shade300; // Light green.
      case var val when val > 0.0:
        return Colors.orange.shade400; // Lighter orange.
      case var val when val >= -2.5:
        return Colors.orange.shade600; // Medium orange.
      case var val when val >= -5.0:
        return Colors.orange.shade800; // Darker orange.
      case var val when val >= -10.0:
        return Colors.red.shade200; // Light red.
      case var val when val >= -15.0:
        return Colors.red.shade400; // Medium red.
      case var val when val >= -20.0:
        return Colors.red.shade600; // Dark red.
      default:
        return Colors.red.shade800; // Darkest red.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHeatmapChart(),
    );
  }

  SfCartesianChart _buildHeatmapChart() {
    return SfCartesianChart(
      backgroundColor: Colors.blueGrey.shade900,
      plotAreaBorderWidth: 0,
      title: const ChartTitle(
        text: 'S&P 500 Returns After Rate Cuts',
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
          fontFamily: "Roboto",
        ),
      ),
      primaryXAxis: DateTimeCategoryAxis(
        dateFormat: DateFormat.y(), // Format to display only the year.
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        title: const AxisTitle(
          text: 'Year of First Rate Cut',
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
      primaryYAxis: NumericAxis(
        opposedPosition: true,
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        labelStyle: const TextStyle(
          color: Colors.transparent, // Hide default labels.
          fontSize: 0,
        ),
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        multiLevelLabelStyle: const MultiLevelLabelStyle(
            borderWidth: 0, borderColor: Colors.transparent),
        multiLevelLabels: const <NumericMultiLevelLabel>[
          NumericMultiLevelLabel(
            start: 0,
            end: 33.33,
            text: 'Three months\nafter first rate cut',
          ),
          NumericMultiLevelLabel(
            start: 33.34,
            end: 66.66,
            text: 'Six months\nafter first rate cut',
          ),
          NumericMultiLevelLabel(
            start: 66.67,
            end: 100,
            text: 'One year\nafter first rate cut',
          ),
        ],
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
      ),
      series: _buildHeatmapSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<CartesianSeries<_SP500ReturnData, DateTime>> _buildHeatmapSeries() {
    return <CartesianSeries<_SP500ReturnData, DateTime>>[
      StackedBar100Series<_SP500ReturnData, DateTime>(
        dataSource: _heatMapData!,
        xValueMapper: (_SP500ReturnData data, int index) => data.year,
        yValueMapper: (_SP500ReturnData data, int index) => data.threeMonths,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.threeMonths),
        animationDuration: 0,
        width: 1,
        borderWidth: 5.0,
        borderColor: Colors.blueGrey.shade900,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        name: '3 Months After First Rate Cut',
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
          textStyle: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onCreateRenderer: (ChartSeries<_SP500ReturnData, DateTime> series) {
          return _HeatmapSeriesRenderer();
        },
      ),
      StackedBar100Series<_SP500ReturnData, DateTime>(
        dataSource: _heatMapData!,
        xValueMapper: (_SP500ReturnData data, int index) => data.year,
        yValueMapper: (_SP500ReturnData data, int index) => data.sixMonths,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.sixMonths),
        animationDuration: 0,
        width: 1,
        borderWidth: 5.0,
        borderColor: Colors.blueGrey.shade900,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        name: '6 Months After First Rate Cut',
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
          textStyle: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onCreateRenderer: (ChartSeries<_SP500ReturnData, DateTime> series) {
          return _HeatmapSeriesRenderer();
        },
      ),
      StackedBar100Series<_SP500ReturnData, DateTime>(
        dataSource: _heatMapData!,
        xValueMapper: (_SP500ReturnData data, int index) => data.year,
        yValueMapper: (_SP500ReturnData data, int index) => data.oneYear,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.oneYear),
        animationDuration: 0,
        width: 1,
        borderWidth: 5.0,
        borderColor: Colors.blueGrey.shade900,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        name: '1 Year After First Rate Cut',
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
          textStyle: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onCreateRenderer: (ChartSeries<_SP500ReturnData, DateTime> series) {
          return _HeatmapSeriesRenderer();
        },
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
    this.threeMonths,
    this.sixMonths,
    this.oneYear,
  );

  final DateTime year;
  final num threeMonths;
  final num sixMonths;
  final num oneYear;
}

class _HeatmapSeriesRenderer
    extends StackedBar100SeriesRenderer<_SP500ReturnData, DateTime> {
  _HeatmapSeriesRenderer();

  @override
  void populateDataSource(
      [List<ChartValueMapper<_SP500ReturnData, num>>? yPaths,
      List<List<num>>? chaoticYLists,
      List<List<num>>? yLists,
      List<ChartValueMapper<_SP500ReturnData, Object>>? fPaths,
      List<List<Object?>>? chaoticFLists,
      List<List<Object?>>? fLists]) {
    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);

    // Always keep positive 0 to 100 range even set negative value.
    yMin = 0;
    yMax = 100;

    // Calculate heatmap segment top and bottom values.
    _computeHeatMapValues();
  }

  void _computeHeatMapValues() {
    if (xAxis == null || yAxis == null) {
      return;
    }

    if (yAxis!.dependents.isEmpty) {
      return;
    }

    // Get the number of series dependent on the yAxis.
    final int seriesLength = yAxis!.dependents.length;
    // Calculate the proportional height for each series
    // (as a percentage of the total height).
    final num yValue = 100 / seriesLength;
    // Loop through each dependent series to calculate top and bottom values for
    // the heatmap.
    for (int i = 0; i < seriesLength; i++) {
      // Check if the current series is a '_HeatmapSeriesRenderer'.
      if (yAxis!.dependents[i] is _HeatmapSeriesRenderer) {
        final _HeatmapSeriesRenderer current =
            yAxis!.dependents[i] as _HeatmapSeriesRenderer;

        // Skip processing if the series is not visible or has no data.
        if (!current.controller.isVisible || current.dataCount == 0) {
          continue;
        }

        // Calculate the bottom (stack) value for the current series.
        num stackValue = 0;
        stackValue = yValue * i;

        current.topValues.clear();
        current.bottomValues.clear();

        // Loop through the data points in the current series.
        final int length = current.dataCount;
        for (int j = 0; j < length; j++) {
          // Add the bottom value (stackValue) for the current data point.
          current.bottomValues.add(stackValue.toDouble());
          // Add the top value (stackValue + yValue) for the current data point.
          current.topValues.add((stackValue + yValue).toDouble());
        }
      }
    }
  }
}
