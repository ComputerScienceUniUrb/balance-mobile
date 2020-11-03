
import 'package:flutter_test/flutter_test.dart';
import 'package:balance_app/posture_processor/src/math/vactor3.dart';

void main() {
  final firstVector = Vector3([1.0, 2.0, 3.0]);
  final secondVector = Vector3([4.0, 5.0, 6.0]);

  test(" create vector", () {
    expect(Vector3.of(1.0, 2.0, 3.0), equals(firstVector));
  });

  test("norm", () {
    // Norm is done correctly?
    expect(firstVector.norm().toStringAsFixed(4), equals("3.7417"));
  });

  test("dot", () {
    // Dot product is done correctly?
    expect(firstVector.dot(secondVector), equals(32));
  });

  test("cross", () {
    // Cross product is done correctly?
    final resV = Vector3.of(-3.0, 6.0, -3.0);
    expect(firstVector.cross(secondVector), equals(resV));
  });

  test("all", () {
    // A vector with all 0 values..
    final allZeroV = Vector3.of(0.0, 0.0, 0.0);
    // ... pass all equals 0 test?
    expect(allZeroV.all((double) => double == 0.0), isTrue);
    // ... fail all not equal 0 test?
    expect(allZeroV.all((double) => double != 0.0), isFalse);

    // A vector with no 0 value...
    // ... fail all equals 0 test?
    expect(firstVector.all((double) => double == 0.0), isFalse);
    // ... pass between 0 and 4 test?
    expect(firstVector.all((double) => double < 4.0 && double > 0.0), isTrue);
  });
}