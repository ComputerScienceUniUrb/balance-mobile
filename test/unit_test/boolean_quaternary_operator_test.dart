
import 'package:balance/utils/boolean_quaternary_operator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("return first", () {
    final res = bqtop(true, "first", "second");

    expect(res, equals("first"));
  });

  test("return second", () {
    final res = bqtop(false, "first", "second");

    expect(res, equals("second"));
  });

  test("return default", () {
    final res = bqtop(null, "first", "second", "default");

    expect(res, equals("default"));
  });

  test("return first with null default", () {
    final res = bqtop(null, "first", "second");

    expect(res, equals("first"));
  });
}