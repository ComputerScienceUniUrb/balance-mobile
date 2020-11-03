
import 'dart:math';

/// Implements a vector of size 3
class Vector3 {
  final List<double> _vectorDataList;

  Vector3(this._vectorDataList);

  /// Creates a new [Vector3] from three separate elements
  factory Vector3.of(double first, double second, double third) => Vector3([first, second, third]);

  /// Return the element at position [index]
  double operator [](int index) => _vectorDataList[index];

  /// Return the cross product of two [Vector3]
  Vector3 cross(Vector3 other) => Vector3.of(
    this[1] * other[2] - this[2] * other[1],
    this[2] * other[0] - this[0] * other[2],
    this[0] * other[1] - this[1] * other[0]
  );

  /// Return the dot product of two [Vector3]
  ///
  /// The dot product is sum (ai*bi), i=1 to N
  double dot(Vector3 other) => (this[0] * other[0] + this[1] * other[1] + this[2] * other[2]);

  /// Return the norm of the vector
  double norm() => sqrt(pow(this[0], 2) + pow(this[1], 2) + pow(this[2], 2));

  /// Return true if all elements match the given [predicate].
  bool all(bool predicate(double)) {
    if (!predicate(this[0])) return false;
    if (!predicate(this[1])) return false;
    if (!predicate(this[2])) return false;
    return true;
  }

  @override
  String toString() => "Vector3$_vectorDataList";

  @override
  bool operator ==(other) {
    if (other is! Vector3) return false;
    if (this[0] != other[0] ||
      this[1] != other[1] ||
      this[2] != other[2])
      return false;
    return true;
  }

  @override
  int get hashCode {
    var h = 7;
    h = 31 * h + this[0].hashCode;
    h = 31 * h + this[1].hashCode;
    h = 31 * h + this[2].hashCode;
    return h;
  }
}