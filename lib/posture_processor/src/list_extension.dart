
import 'dart:math';

/// Statistics extension method on the [List] of [num]
///
/// This class extends a list of numbers with methods
/// to compute statistical functions like: average,
/// standard deviation, etc...
extension ListExtension on List<num> {
  /// Compute the average of a [List] of numbers.
  ///
  /// avg(x) = 1/N SUM_i (x(i))
  /// If the list is empty it return [double.nan]
  double average() {
    if (this.isEmpty)
      return double.nan;
    return this.fold(0.0, (prev, e) => prev + e.toDouble()) / this.length;
  }

  /// Compute the standard deviation of a [List] of numbers.
  ///
  /// std (x) = sqrt (1/(N-1) SUM_i ((x(i) - mean(x))^2))
  /// If the list is empty it return [double.nan]
  /// The standard deviation of a one-element list is 0.0
  ///
  /// Reference:
  /// * https://www.analystforum.com/t/quick-question-standard-deviation/3251/6
  double std() {
    if (this.isEmpty)
      return double.nan;
    if (this.length == 1)
      return 0.0;
    double mean = this.average();
    return sqrt(this.fold(0.0, (prev, e) => prev + pow(e - mean, 2)) / (this.length - 1));
  }

  /// Compute the variance of a [List] of numbers.
  ///
  /// var (x) = (1/(N-1) SUM_i ((x(i) - mean(x))^2)
  /// If the list is empty it return [double.nan]
  /// The variance of a one-element list is 0.0
  double variance() {
    if (this.isEmpty)
      return double.nan;
    if (this.length == 1)
      return 0.0;
    double mean = this.average();
    return (this.fold(0.0, (prev, e) => prev + (pow(e - mean, 2)))) / (this.length - 1);
  }

  /// Compute the kurtosis index of a [List] of numbers.
  ///
  /// Reference:
  /// https://it.mathworks.com/help/stats/kurtosis.html
  double kurtosis() {
    if (this.isEmpty)
      return double.nan;
    double mean = this.average();

    double dividend = this.fold(0.0, (prev, e) => prev + pow(e - mean, 4)) / length;
    double divisor = pow((this.fold(0.0, (prev, e) => prev + pow(e - mean, 2)) / length), 2);

    return dividend / divisor;
  }

  /// Compute the skewness index of a [List] of numbers.isEmpty
  ///
  /// Reference:
  /// https://it.mathworks.com/help/stats/skewness.html
  double skewness() {
    if (this.isEmpty)
      return double.nan;
    double mean = this.average();

    double dividend = this.fold(0.0, (prev, e) => prev + pow(e - mean, 3)) / length;
    double divisor = pow(sqrt(this.fold(0.0, (prev, e) => prev + pow(e - mean, 2)) / length), 3);

    return dividend / divisor;
  }
}