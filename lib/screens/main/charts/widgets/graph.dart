import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:quiver/iterables.dart';
import '../chart_screen.dart';

class PlotData {
  List<DateTime> dates;
  List<double> values;
  double maxY;
  double minY;
  DateTime minX;
  DateTime maxX;

  PlotData(List<SeriesElem> result) {
    this.values = result.map((e) => double.parse(e.value.toStringAsFixed(2))).toList();
    this.dates = result.map((e) => e.time).toList();
    this.maxY = this.values.reduce(math.max);
    this.minY = this.values.reduce(math.min);
    this.maxX = dates.reduce((max, e) => e.isAfter(max)? e : min);
    this.minX = dates.reduce((min, e) => e.isBefore(min)? e : min);
  }

  List joinedData() {
    return [for(var pair in zip([this.dates, this.values])) [pair[0], pair[1], this.minX]];
  }
}

class LinePlot extends StatefulWidget {
  final PlotData plotData;
  final double lowBound;
  final double highBound;

  const LinePlot({
    Key key, this.plotData, this.lowBound, this.highBound
  }) : super(key: key);

  @override
  _LinePlotState createState() => _LinePlotState();
}

class _LinePlotState extends State<LinePlot> {
  double minX;
  double maxX;
  double minY;
  double maxY;

  @override
  void initState() {
    super.initState();
    minY = widget.plotData.minY - widget.plotData.minY*0.1;
    maxY = widget.plotData.maxY + widget.plotData.maxY*0.1;
    maxX = (widget.plotData.maxX.millisecondsSinceEpoch.toDouble()-widget.plotData.minX.millisecondsSinceEpoch.toDouble())/86400000.0;
    minX = maxX <= 10? 0 : maxX-10;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Listener(
          onPointerSignal: (signal) {
            if (signal is PointerScrollEvent) {
              print(signal);
              setState(() {
                if (signal.scrollDelta.dy.isNegative) {
                  minX += maxX * 0.05;
                  maxX -= maxX * 0.05;
                } else {
                  minX -= maxX * 0.05;
                  maxX += maxX * 0.05;
                }
              });
            }
          },
          child: GestureDetector(
            onHorizontalDragUpdate: (dragUpdDet) {
              setState((){
                double primDelta = dragUpdDet.primaryDelta ?? 0.0;
                if (primDelta < 0 && maxX < ((widget.plotData.maxX.millisecondsSinceEpoch.toDouble()-widget.plotData.minX.millisecondsSinceEpoch.toDouble())/86400000.0)) {
                  maxX += maxX * 0.001;
                  minX += maxX * 0.001;
                } else if (primDelta > 0 && minX > 0) {
                  maxX -= maxX * 0.001;
                  minX -= maxX * 0.001;
                }
              });
            },
            onVerticalDragUpdate: (dragUpdDet) {
              setState(() {
                double primDelta = dragUpdDet.primaryDelta ?? 0.0;
                if (primDelta != 0) {
                  if (primDelta < 0 && ((widget.plotData.values).reduce(math.min) <= (minY + ((maxY-minY)/2)))) {
                    maxY -= maxY * 0.02;
                  }

                  if (primDelta > 0 && ((widget.plotData.values).reduce(math.max) >= (maxY - (maxY-minY)/2))) {
                    maxY += maxY * 0.01;
                  }
                }
              });
            },
            child: LineChart(
              LineChartData(
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY,
                clipData: FlClipData.all(),
                lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (value) {
                        return value.map((e) => LineTooltipItem(
                          "${e.y.toStringAsFixed(2)}\n${DateTime.fromMillisecondsSinceEpoch((e.x * 86400000.0 + widget.plotData.minX.millisecondsSinceEpoch).toInt()).toString().substring(0,16)}",
                          TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                          ),
                        )).toList();
                      },
                      tooltipBgColor: Colors.blueGrey,
                    )
                ),
                rangeAnnotations: RangeAnnotations(
                  horizontalRangeAnnotations: [
                    HorizontalRangeAnnotation(
                      y1: widget.lowBound,
                      y2: widget.highBound,
                      color: Color(0x5C9C54C7),
                    ),
                  ],
                ),
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                    margin: 20,
                    rotateAngle: 90.0,
                    getTextStyles: (value) => const TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                      fontSize: 10
                    ),
                    reservedSize: 64,
                    getTitles: (value) {
                      var dateString = '';
                      var start = widget.plotData.minX;
                      var format = new DateFormat("d-M-y");

                      switch(value.toInt()) {
                        case 0:
                          dateString = format.format(start);
                          break;

                        default:
                          DateTime date = start.add(Duration(days: value.toInt()));
                          dateString = format.format(date);
                          break;
                      }

                      return dateString;
                    },
                    showTitles: true,
                    interval: (maxX-minX) / ((maxX-minX).toInt() >= 10? 10:(maxX-minX).toInt()),
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    margin: 10,
                    reservedSize:32,
                    getTextStyles: (value) => const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w700,
                        fontSize: 10
                    ),
                    getTitles: (value) {
                      return value.toStringAsFixed(2);
                    },
                    interval: (maxY - minY) / 10,
                  ),
                  rightTitles: SideTitles(showTitles: false),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  horizontalInterval: (maxY - minY) / 10,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: Color(0xff4e4965), width: 3),
                    left: BorderSide(color: Colors.white),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    barWidth: 2,
                    colors: [Colors.blue],
                    isCurved: false,
                    dotData: FlDotData(
                      show: false,
                    ),
                    spots: widget.plotData.joinedData().asMap().entries
                        .map((entry) => FlSpot((entry.value[0].millisecondsSinceEpoch.toDouble()-entry.value[2].millisecondsSinceEpoch.toDouble())/86400000.0, entry.value[1])).toList()
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("Zoom +", style: TextStyle(fontSize: 16),),
                onPressed: () => {
                  setState((){
                    if ((maxX - maxX * 0.05) > (minX + ((maxX - maxX * 0.05) * 0.05))) {
                      maxX -= maxX * 0.05;
                      minX += maxX * 0.05;
                    }
                  })
                },
                color: Colors.indigoAccent,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.grey,
              ),
              SizedBox(width: 16),
              RaisedButton(
                child: Text("Zoom -", style: TextStyle(fontSize: 16),),
                onPressed: () => {
                  setState((){
                    if (maxX <= (widget.plotData.maxX.millisecondsSinceEpoch.toDouble()-widget.plotData.minX.millisecondsSinceEpoch.toDouble())/86400000.0)
                      maxX += maxX * 0.1;
                    if (minX >= 0)
                    minX -= maxX * 0.1;
                  })
                },
                color: Colors.indigoAccent,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.grey,
              ),
            ]
          )
        )
      ],
    );

  }
}
