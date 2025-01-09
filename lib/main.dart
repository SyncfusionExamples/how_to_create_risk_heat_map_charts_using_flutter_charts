import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

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
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      tooltipPosition: TooltipPosition.pointer,
      format: 'point.x : point.y%',
    );
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
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        body: Padding(
            padding: const EdgeInsets.all(20), child: _buildSP500Chart()));
  }

  SfCartesianChart _buildSP500Chart() {
    return SfCartesianChart(
      backgroundColor: Colors.blueGrey.shade900,
      plotAreaBorderWidth: 0,
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
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          color: Colors.white,
        ),
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
      ),
      primaryYAxis: NumericAxis(
        opposedPosition: true,
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        labelStyle: const TextStyle(
          color: Colors.transparent, // Hide default labels
        ),
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        multiLevelLabelStyle: const MultiLevelLabelStyle(
            borderWidth: 0, borderColor: Colors.transparent),
        multiLevelLabels: const <NumericMultiLevelLabel>[
          NumericMultiLevelLabel(
              start: -90,
              end: -40,
              text: 'Three months after \n first rate cut'),
          NumericMultiLevelLabel(
              start: -20, end: 20, text: 'Six months after \n first rate cut'),
          NumericMultiLevelLabel(
            start: 40,
            end: 90,
            text: 'One year after \n first rate cut',
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
      series: _getStackedColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<CartesianSeries<_SP500ReturnData, DateTime>> _getStackedColumnSeries() {
    return <CartesianSeries<_SP500ReturnData, DateTime>>[
      StackedBar100Series<_SP500ReturnData, DateTime>(
        dataSource: _heatMapData!,
        xValueMapper: (_SP500ReturnData data, int index) => data.year,
        yValueMapper: (_SP500ReturnData data, int index) =>
            data.threeMonthsAfterFirstRateCut,
        borderWidth: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        width: 1,
        borderColor: Colors.blueGrey.shade900,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.threeMonthsAfterFirstRateCut),
        onCreateRenderer: (series) {
          return _CustomHeatmapStackedBar100SeriesRenderer();
        },
        name: '3 Months After First Rate Cut',
      ),
      StackedBar100Series<_SP500ReturnData, DateTime>(
        dataSource: _heatMapData!,
        xValueMapper: (_SP500ReturnData data, int index) => data.year,
        yValueMapper: (_SP500ReturnData data, int index) =>
            data.sixMonthsAfterFirstRateCut,
        borderWidth: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        width: 1,
        borderColor: Colors.blueGrey.shade900,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.sixMonthsAfterFirstRateCut),
        onCreateRenderer: (series) {
          return _CustomHeatmapStackedBar100SeriesRenderer();
        },
        name: '6 Months After First Rate Cut',
      ),
      StackedBar100Series<_SP500ReturnData, DateTime>(
        dataSource: _heatMapData!,
        xValueMapper: (_SP500ReturnData data, int index) => data.year,
        yValueMapper: (_SP500ReturnData data, int index) =>
            data.oneYearAfterFirstRateCut,
        borderWidth: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        width: 1,
        borderColor: Colors.blueGrey.shade900,
        pointColorMapper: (_SP500ReturnData data, int index) =>
            _buildColor(data.oneYearAfterFirstRateCut),
        onCreateRenderer: (series) {
          return _CustomHeatmapStackedBar100SeriesRenderer();
        },
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
    this.threeMonthsAfterFirstRateCut,
    this.sixMonthsAfterFirstRateCut,
    this.oneYearAfterFirstRateCut,
  );

  final DateTime year;
  final num threeMonthsAfterFirstRateCut;
  final num sixMonthsAfterFirstRateCut;
  final num oneYearAfterFirstRateCut;
}

class _CustomHeatmapStackedBar100SeriesRenderer
    extends StackedBar100SeriesRenderer<_SP500ReturnData, DateTime> {
  _CustomHeatmapStackedBar100SeriesRenderer();

  @override
  StackedBar100Segment<_SP500ReturnData, DateTime> createSegment() {
    return _CustomHeatmapStackedBar100Segment();
  }
}

class _CustomHeatmapStackedBar100Segment
    extends StackedBar100Segment<_SP500ReturnData, DateTime> {
  _CustomHeatmapStackedBar100Segment();

  @override
  void transformValues() {
    /// Given fixed y value and bottom value based on the y axis range.
    if (series.index == 0) {
      top = -33.33;
      bottom = -100;
    } else if (series.index == 1) {
      top = 33.33;
      bottom = -33.33;
    } else {
      top = 100;
      bottom = 33.33;
    }

    super.transformValues();
  }

  @override
  void onPaint(Canvas canvas) {
    super.onPaint(canvas);

    if (segmentRect == null) {
      return;
    }

    final segment = series.dataSource![currentSegmentIndex];
    num? yValue;
    if (series.index == 0) {
      yValue = segment.threeMonthsAfterFirstRateCut;
    } else if (series.index == 1) {
      yValue = segment.sixMonthsAfterFirstRateCut;
    } else {
      yValue = segment.oneYearAfterFirstRateCut;
    }

    final TextSpan textSpan = TextSpan(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      text: '${yValue.toString()}%',
    );
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    double textX = segmentRect!.center.dx - (textPainter.width / 2);
    double textY = segmentRect!.center.dy - (textPainter.height / 2);
    textPainter.paint(canvas, Offset(textX, textY));
  }
}
