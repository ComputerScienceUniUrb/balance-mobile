
/// Class containing a sensor bias
///
/// A sensor bias is a tuple of values (x,y,z)
/// used to calibrate the senors; each sensor
/// has a SensorBias.
/// Each value of the bias is given by:
///   b = (cv - e)
/// where:
///  * cv is the mean of the values obtained douring
///       the calibration process
///  * e is the expected value for the axis
///  * b is the bias
///
/// Examples:
///  * cv=2, e=0 -> b=2
///  * cv=-2, e=0 -> b=-2
///  * cv=10, e=9.8 -> b=0.8
///  * cv=8, e=9.8 -> b=-1.8
class SensorBias {
  final double x, y, z;

  const SensorBias(this.x, this.y, this.z);

  @override
  String toString() => "SensorBias(x: $x, y:$y, z:$z)";
}