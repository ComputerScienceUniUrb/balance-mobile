
import 'package:flutter_test/flutter_test.dart';
import 'package:balance/posture_processor/src/math/matrix.dart';

void main() {
  final List<double> list2x3 = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
  final matrix2x3 = Matrix(2, 3, list2x3);

  test("get each values", () {
    // Test if get operator returns the correct value
    expect(matrix2x3.get(0, 0), equals(1.0));
    expect(matrix2x3.get(0, 1), equals(2.0));
    expect(matrix2x3.get(0, 2), equals(3.0));
    expect(matrix2x3.get(1, 0), equals(4.0));
    expect(matrix2x3.get(1, 1), equals(5.0));
    expect(matrix2x3.get(1, 2), equals(6.0));
  });

  test("matrix with wrong number of element throws an error", () {
    // Test if creating a matrix with wrong elements return an exception
    try {
      Matrix(2, 3, [0.0, 2.0]);
    } catch(e) {
      expect(e.toString(), contains("Wrong number of elements in matrix!"));
    }
  });

  test("0 size matrix throws an error", () {
    expect(() => Matrix(0, 0, []), throwsAssertionError);
  });

  test("to list", () {
    // Test if toList returns the values as list in correct order
    expect(matrix2x3.toList(), equals(list2x3));
  });

  group("Factories", () {
    test("generate a matrix", () {
      final m1x1 = Matrix.generate(1, 1, (r, c) => 0.0);
      expect(m1x1.size, equals(1));
      expect(m1x1.toList(), equals([0.0]));

      final m3x4 = Matrix.generate(3, 4, (r, c) {
        if (r == 0) return 0.0;
        if (r == 1) return 1.0;
        return 2.0;
      });
      expect(m3x4.size, equals(12));
      expect(m3x4.toList(), equals([0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 2.0, 2.0]));
    });

    test("identity", () {
      // We obtain an identity matrix of correct size?
      expect(Matrix.identity(1), equals(Matrix(1, 1, [1.0])));
      expect(Matrix.identity(2), equals(Matrix(2, 2, [1.0, 0.0, 0.0, 1.0])));
      expect(
        Matrix.identity(3), equals(Matrix(3, 3, [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0])));
    });
  });

  group("Operators", () {
    test("matrix plus matrix", () {
      // The sum of two matrices is correct?
      final m2 = Matrix(2, 3, [3.0, 6.0, 9.0, 12.0, 15.0, 18.0]);
      final resM = Matrix(2, 3, [4.0, 8.0, 12.0, 16.0, 20.0, 24.0]);
      expect(matrix2x3 + m2, equals(resM));

      // If we sum matrices with different sizes we get an error?
      final wrongM = Matrix(3, 2, [4.0, 8.0, 12.0, 16.0, 20.0, 24.0]);
      expect(() => matrix2x3 + wrongM, throwsAssertionError);
    });

    test("matrix times number", ()
    {
      // The product of a matrix with a number is correct?
      final resM = Matrix(2, 3, [3.0, 6.0, 9.0, 12.0, 15.0, 18.0]);
      expect(matrix2x3 * 3, equals(resM));
    });

    test("matrix times matrix", () {
      // The product two matrices is correct?
      final base3x4 = Matrix(3, 4, [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0]);
      final resM = Matrix(2, 4, [38.0,44.0,50.0,56.0,83.0,98.0,113.0,128.0]);
      // a * b is correct?
      expect(matrix2x3.times(base3x4), equals(resM));
      // b * a throws error?
      expect(() => base3x4.times(matrix2x3), throwsAssertionError);
    });

    test("matrix divide number", () {
      final resM = Matrix(2, 3, [0.25, 0.5, 0.75, 1.0, 1.25, 1.5]);
      expect(matrix2x3 / 4, equals(resM));
      // Dividing by 0 throws an exception?
      expect(() => matrix2x3 / 0, throwsAssertionError);
    });

    test("transpose", (){
      final t = matrix2x3.transpose();

      expect(t.rows, equals(matrix2x3.cols));
      expect(t.cols, equals(matrix2x3.rows));
      expect(t.size, equals(matrix2x3.size));

      final testTransposeM = Matrix(3, 2, [1.0, 4.0, 2.0, 5.0, 3.0, 6.0]);
      expect(t, equals(testTransposeM));
    });

    test("operation combination", ()
    {
      // Test if combining operations gives the result wanted
      final m1 = Matrix(3, 3, [4.0,5.0,3.0,2.0,0.0,1.0,-1.0,-2.0,-3.0]);
      final mId = Matrix.identity(3);

      final opM = (mId + m1 + (m1.times(m1)) * (4.0 / 2.0)) / 4;
      final resM = Matrix(3, 3, [12.75,8.25,4.75,4.0,4.25,1.75, -2.75, 0.0, 1.5]);

      expect(opM, equals(resM));
    });
  });

  group("Range operatoors", () {
    test("foreach indexed", () {
      int index = 0;
      final list = [];
      matrix2x3.forEachIndexed((row, col, value) {
        expect(row, lessThanOrEqualTo(matrix2x3.rows));
        expect(col, lessThanOrEqualTo(matrix2x3.cols));
        index++;
        list.add(value);
      });
      expect(index, equals(matrix2x3.size));
      expect(list, equals(matrix2x3.toList()));
    });

    test("foreach", () {
      final list = [];
      matrix2x3.forEach((value) {
        list.add(value);
      });
      expect(list, equals(matrix2x3.toList()));
    });

    test("foreach column", () {
      matrix2x3.forEachColumn((col, rowValues) {
        expect(matrix2x3.get(0, col), rowValues[0]);
        expect(matrix2x3.get(1, col), rowValues[1]);
      });
    });

    test("extract rows", () {
      List<List<double>> rowList = matrix2x3.extractRows();
      expect(rowList, hasLength(matrix2x3.rows));
      for(var col in rowList) {
        expect(col, hasLength(matrix2x3.cols));
      }
    });
  });
  
  group("Fixed-sized matrices", () {
    test("matrix 3x3", () {
      expect(matrix3x3Of([0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]).size, equals(9));
      expect(() => matrix3x3Of([0.0, 1.0]), throwsAssertionError);
    });

    test("matrix 2xM", () {
      final matrix = matrix2xMOf([0.0, 1.0, 2.0], [0.0, 1.0, 2.0]);
      expect(matrix.size, equals(6));
      expect(() => matrix2xMOf([0.0, 1.0], [0.0]), throwsAssertionError);
    });

    test("matrix 3xM", () {
      final matrix = matrix3xMOf([0.0, 1.0, 2.0, 3.0], [0.0, 1.0, 2.0, 3.0], [0.0, 1.0, 2.0, 3.0]);
      expect(matrix.size, equals(12));
      expect(() => matrix3xMOf([0.0, 1.0], [0.0], []), throwsAssertionError);
    });

    test("square a matrix 3x3", () {
      final matrix = matrix3x3Of([0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]);
      final resM = matrix3x3Of([15.0, 18.0, 21.0, 42.0, 54.0, 66.0, 69.0, 90.0, 111.0]);
      expect(matrix3x3pow2(matrix), equals(resM));
    });
  });
}