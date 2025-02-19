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
  List<_HeatMapData>? _heatMapData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _heatMapData = <_HeatMapData>[
      _HeatMapData(DateTime(1973), -10.2, -6.2, -36.0),
      _HeatMapData(DateTime(1974), -14.7, -15.3, 7.5),
      _HeatMapData(DateTime(1980), 15.0, 28.9, 30.3),
      _HeatMapData(DateTime(1981), -11.0, -7.9, -17.8),
      _HeatMapData(DateTime(1982), -4.8, 17.4, 36.5),
      _HeatMapData(DateTime(1987), 0.1, 1.7, 7.5),
      _HeatMapData(DateTime(1989), 7.4, 7.5, 11.9),
      _HeatMapData(DateTime(1995), 10, 5.1, 13.4),
      _HeatMapData(DateTime(1998), 17.2, 26.5, 27.3),
      _HeatMapData(DateTime(2001), -16.3, -12.4, -14.9),
      _HeatMapData(DateTime(2007), -4.4, -11.8, -27.2),
      _HeatMapData(DateTime(2019), 3.8, 13.3, 14.5),
    ];
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      animationDuration: 0,
      format: 'point.x : point.y%',
      tooltipPosition: TooltipPosition.pointer,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHeatmapChart(),
    );
  }

  SfCartesianChart _buildHeatmapChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: const ChartTitle(
        text: 'Visualizing S&P 500 Returns After Interest Rate Cuts',
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          fontFamily: "Roboto",
        ),
      ),
      primaryXAxis: DateTimeCategoryAxis(
        isInversed: true,
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        dateFormat: DateFormat.y(), // Format to display only the year.
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        title: const AxisTitle(
          text: 'Year of First Rate Cut',
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
      primaryYAxis: NumericAxis(
        opposedPosition: true,
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        minorTickLines: const MinorTickLines(size: 0),
        labelStyle: const TextStyle(fontSize: 0),
        multiLevelLabelStyle: const MultiLevelLabelStyle(
          borderWidth: 0,
          borderColor: Colors.transparent,
        ),
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
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          );
        },
      ),
      tooltipBehavior: _tooltipBehavior,
      series: _buildHeatmapSeries(),
    );
  }

  List<CartesianSeries<_HeatMapData, DateTime>> _buildHeatmapSeries() {
    return <CartesianSeries<_HeatMapData, DateTime>>[
      for (int i = 0; i < 3; i++)
        StackedBar100Series<_HeatMapData, DateTime>(
          dataSource: _heatMapData!,
          xValueMapper: (_HeatMapData data, int index) => data.year,
          yValueMapper: (_HeatMapData data, int index) => _yValue(data, i),
          pointColorMapper: (_HeatMapData data, int index) =>
              _buildColor(_yValue(data, i)),
          width: 1,
          name: _seriesName(i),
          animationDuration: 0,
          borderColor: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.middle,
            textStyle: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onCreateRenderer: (ChartSeries<_HeatMapData, DateTime> series) {
            return _HeatmapSeriesRenderer();
          },
        ),
    ];
  }

  num _yValue(_HeatMapData data, int seriesIndex) {
    switch (seriesIndex) {
      case 0:
        return data.threeMonths;
      case 1:
        return data.sixMonths;
      case 2:
        return data.oneYear;
      default:
        return 0;
    }
  }

  String _seriesName(int seriesIndex) {
    switch (seriesIndex) {
      case 0:
        return '3 Months After First Rate Cut';
      case 1:
        return '6 Months After First Rate Cut';
      case 2:
        return '1 Year After First Rate Cut';
      default:
        return '';
    }
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
  void dispose() {
    _heatMapData!.clear();
    _tooltipBehavior = null;
    super.dispose();
  }
}

class _HeatMapData {
  _HeatMapData(this.year, this.threeMonths, this.sixMonths, this.oneYear);

  dynamic year;
  late num threeMonths;
  late num sixMonths;
  late num oneYear;
}

class _HeatmapSeriesRenderer
    extends StackedBar100SeriesRenderer<_HeatMapData, DateTime> {
  _HeatmapSeriesRenderer();

  @override
  void populateDataSource(
      [List<ChartValueMapper<_HeatMapData, num>>? yPaths,
      List<List<num>>? chaoticYLists,
      List<List<num>>? yLists,
      List<ChartValueMapper<_HeatMapData, Object>>? fPaths,
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

        current.topValues.clear();
        current.bottomValues.clear();

        // Calculate the bottom (stack) value for the current series.
        num stackValue = yValue * i;

        // Loop through the data points in the current series.
        final int length = current.dataCount;
        for (int j = 0; j < length; j++) {
          final num actualYValue = current.yValues[j];
          if (actualYValue.isNaN) {}
          // Add the bottom value (stackValue) for the current data point.
          current.bottomValues.add(stackValue.toDouble());
          // Add the top value (stackValue + yValue) for the current data point.
          current.topValues.add((stackValue + yValue).toDouble());
        }
      }
    }
  }
}