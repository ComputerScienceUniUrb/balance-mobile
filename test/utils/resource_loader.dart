
import 'dart:io';

import 'package:balance/posture_processor/src/math/matrix.dart';

/// Load a [Matrix] from the [test_resources] directory.
///
/// [fileName]: a [String] file path to write relative to
///   [test_resources] without initial /
Matrix loadMatrixFromResource(String fileName) {
  File file = Directory.current.path.endsWith("test")
    ? File("test_resources/"+fileName)
    : File("test/test_resources/"+fileName);

  final List<double> result = [];
  final testDataLines = file.readAsLinesSync();
  if (testDataLines == null || testDataLines.isEmpty)
    return null;

  final colNum = testDataLines[0].split(" ").length;
  for(var line in testDataLines) {
    if (line.isEmpty)
      continue;
    final splitted = line.split(" ");
    for (var i = 0; i < colNum; i++) {
      result.add(double.parse(splitted[i]));
    }
  }
  return Matrix(testDataLines.length, colNum, result);
}

/// Writes a [Matrix] to a file in [test_results] directory.
///
/// [matrix]: the [Matrix] data to write
/// [fileName]: a [String] file path to write relative to
///   [test_results] without initial /
void writeMatrixToFile(Matrix matrix, String fileName) async{
  File file = Directory.current.path.endsWith("test")
    ? File("test_results/"+fileName)
    : File("test/test_results/"+fileName);
  await file.create(recursive: true);

  final rows = matrix.extractRows();
  String dataString = '';
  for(var row in rows) {
    dataString += "${row.join(" ")}\n";
  }
  file.writeAsString(dataString.toString());
}