
import 'package:flutter/cupertino.dart';

/// Implements an immutable matrix class
///
/// This class implements a matrix of [rows] by [cols]
/// with all the matrix operation this package require.
/// This class is an immutable matrix, meaning the data
/// inside it cannot change during time, the only way of
/// changing the data is to create a copy of the matrix;
/// this follows the concepts of functional programming.
 class Matrix {
  final int rows;
  final int cols;
  final List<double> _matrixDataList;

  /// Creates a [Matrix] of [rows] by [cols] where
  /// each element is defined in [_matrixDataList].
  ///
  /// The Matrix cannot be empty (with [size] == 0) and
  /// [_matrixDataList] must have length equal to [size]
  Matrix(
    this.rows,
    this.cols,
    this._matrixDataList
  ): assert(rows > 0 && cols > 0, "Matrix cannot be empty!"),
    assert(rows * cols == _matrixDataList.length,
    "Wrong number of elements in matrix! "
      "Expecting: ${rows*cols}, Actual: ${_matrixDataList.length}");

  /// Creates an identity [Matrix] of [size]x[size]
  factory Matrix.identity(int size) => Matrix.generate(size, size, (r, c) => r == c? 1.0: 0.0);

  /// Generates a new [Matrix] of [rows]x[cols] where each element
  /// is given by [generator] function.
  factory Matrix.generate(int rows, int cols, double generator(int row, int col)) {
    final matrixData = List<double>(rows * cols);
    for(var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        matrixData[(row * cols) + col] = generator(row, col);
      }
    }
    return Matrix(
      rows,
      cols,
      matrixData
    );
  }

  /// Return the size of the [Matrix]
  int get size => rows * cols;

  /// Return the element in position [row], [col]
  double get(int row, int col) => _matrixDataList[(row * cols) + col];

  /// Sum two matrices
  ///
  /// Given two matrices NxM return a new matrix NxM where
  /// every element c(ij) is a(ij) + b(ij).
  Matrix operator +(Matrix other) {
    assert(this.rows == other.rows && this.cols == other.cols,
      "Two matrices must have same row and column size!");
    return this.mapIndexed((x, y, val) => val + other.get(x, y));
  }

  /// Multiply a scalar from a matrix
  ///
  /// Given a matrix NxM and a scalar n return a new matrix NxM where
  /// every element b(ij) is a(ij) * n
  Matrix operator *(double other) => this.map((value) => value * other);

  /// Multiply two matrices
  ///
  /// Given a matrix NxM and a matrix MxN return the matrix product
  /// of the two.
  Matrix times(Matrix other) {
    assert(this.cols == other.rows, "The row size of first matrix must equal the columns size of the second matrix!");
    return Matrix.generate(rows, other.cols, (row, col) {
      var value = 0.0;
      for (var i = 0; i < this.cols; i++)
        value += this.get(row, i) * other.get(i, col);
      return value;
    });
}

  /// Divide a scalar from a matrix
  ///
  /// Given a matrix NxM and a scalar n return a new matrix NxM where
  /// every element b(ij) is a(ij) / n
  Matrix operator /(double other) {
    assert(other != 0, "Divisor must not be 0!");
    return this.map((value) => value / other.toDouble());
  }

  /// Loops every elements in the matrix with his index
  void forEachIndexed(action(int row, int col, double value)) {
    for (var row = 0; row < this.rows; row++) {
      for (var col = 0; col < this.cols; col++) {
        action(row, col, this.get(row, col));
      }
    }
  }

  /// Loops every elements in the matrix
  void forEach(action(double value)) {
    for (var row = 0; row < this.rows; row++) {
      for (var col = 0; col < this.cols; col++) {
        action(this.get(row, col));
      }
    }
  }

  /// Loops over the columns of the matrix
  void forEachColumn(action(int col, List<double> rowValues)) {
    List<double> rowsList;
    for (var col = 0; col < this.cols; col++) {
      rowsList = List(this.rows);
      for(var row = 0; row < this.rows; row++) {
        rowsList[row] = this.get(row, col);
      }
      action(col, rowsList);
    }
  }

  /// Creates a new matrix of same size where his elements are
  /// transformed by the lambda function
  Matrix mapIndexed(double transform(int row, int col, double value)) =>
    Matrix.generate(this.rows, this.cols, (r, c) => transform(r, c, this.get(r, c)));

  /// Creates a new matrix of same size where his elements are
  /// transformed by the lambda function
  Matrix map(double transform(double value)) =>
    Matrix.generate(this.rows, this.cols, (r, c) => transform(this.get(r, c)));

  /// Extract the values in the matrix as list of rows
  List<List<double>> extractRows() {
    var len = this._matrixDataList.length;
    var size = this.cols;
    List<List<double>> chunks = [];
    for(var i = 0; i< len; i+= size) {
      var end = (i + size < len)? i + size: len;
      chunks.add(this._matrixDataList.sublist(i,end));
    }
    return chunks;
  }

  /// Return the transpose of the matrix
  ///
  /// Given a [Matrix] it returns a new matrix
  /// that is the transpose of the original.
  @visibleForTesting
  Matrix transpose() => Matrix.generate(this.cols, this.rows, (row, col) => this.get(col, row));

  /// Returns the [Matrix] as a [List]
  List<double> toList() => _matrixDataList;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write("rows: ");
    buffer.write(this.rows);
    buffer.write("\n");
    buffer.write("cols: ");
    buffer.write(this.cols);
    buffer.write("\n");
    buffer.write("[");
    this.forEachIndexed((r, c, val) {
      if (c == 0)
        buffer.write("[");
      buffer.write(val.toString());
      if (c == this.cols - 1) {
        buffer.write("]");
        if (r < this.rows - 1)
          buffer.write(", ");
      } else
        buffer.write(", ");
    });
    buffer.write("]");
    return buffer.toString();
  }

  @override
  int get hashCode {
    int h = 17;
    h = h * 39 + this.cols;
    h = h * 39 + this.rows;
    this.forEach((value) => h = h* 37 + value.hashCode);
    return h;
  }

  @override
  bool operator ==(other) {
    if (other is! Matrix) return false;
    if (rows != other.rows || cols != other.cols) return false;

    bool eq = true;
    this.forEachIndexed((x, y, value) {
      if (value != other.get(x, y)) {
        eq = false;
        return;
      }
    });
    return eq;
  }
}

/// Creates a [Matrix] of size 3 by 3
Matrix matrix3x3Of(List<double> values) {
   assert(values.length == 9,
    "Must pass 9 values for a 3 by 3 matrix!");
  return Matrix(3, 3, values);
}

/// Creates a [Matrix] of size 3 by M
Matrix matrix3xMOf(List<double> row1, List<double> row2, List<double> row3) {
  assert(row1.length == row2.length && row1.length == row3.length,
    "The three lists must have all the same size!");
  return Matrix(3, row1.length, [...row1, ...row2, ...row3]);
}

/// Creates a [Matrix] of size 2 by M
Matrix matrix2xMOf(List<double> row1, List<double> row2) {
  assert(row1.length == row2.length,
    "Given lists must have same size!");
  return Matrix(2, row1.length, [...row1, ...row2]);
}

/// Compute the power by two of a 3x3 matrix
///
/// Squaring a matrix is like multiplying the matrix by
/// herself so this method could not fit inside the general
/// matrix codebase without the need of a transposed matrix
/// logic, since this method is used only with 3x3 matrices
/// is more logical to create a function that accept only
/// this type of matrix.
Matrix matrix3x3pow2(Matrix target) {
  assert(target.rows == 3 && target.cols == 3, "You must pass a matrix 3 by 3!");
  return target.times(target);
}