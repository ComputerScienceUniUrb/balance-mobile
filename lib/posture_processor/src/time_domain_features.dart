
import 'dart:math' as math;

import 'package:balance_app/posture_processor/src/list_extension.dart';

/// Function to compute the time features of COGvML and COGvAP
///
/// This function compute all the time features required for the
/// stabilometric analysis; such as sway path, mean distance, standard
/// deviation and range.
///
/// Here's the algorithm written in Octave:
/// ```
///     %%%%%   sway path  %%%%%%
///     sway_path = 0;
///     displacement = zeros(size(ap)-1);
///     for i = 1:size(ap)-1
///     sway_path = sway_path + sqrt((ml(i+1)- ml(i))^2+(ap(i+1)- ap(i))^2);
///     displacement(i) = sqrt(ml(i)^2+ap(i)^2);
///     end
///     sway_path = sway_path/duration;
///
///     %%%%% mean COP distance  %%%%%%%
///     mean_displacement = mean(displacement);
///
///     %%%%% standard deviation of COP %%%%%%
///     displacement_standard_deviation = std(displacement);
///
///     %%%%% Range of COP displacement %%%%%%%%%
///     range = [min(displacement), max(displacement)];
/// ```
///
/// Return:
/// a Map with: swayPath, meanDisplacement, stdDisplacement, minDist, maxDist, outOfRange
Future<Map<String, double>> timeDomainFeatures(List<double> ap, List<double> ml) async{
  assert(ml.isEmpty || ap.isEmpty || ml.length == ap.length, "ml and ap lists must have same size!");

  // If some list is empty return double.nan
  if (ml.isEmpty || ap.isEmpty)
    return {
      "swayPath": double.nan,
      "meanDisplacement": double.nan,
      "stdDisplacement": double.nan,
      "minDist": double.nan,
      "maxDist": double.nan,
      "outOfRange": double.nan,
    };

  // Compute the Sway Path
  double swayPath = 0.0;
  for (var i = 0; i < ml.length - 1; i++) {
    swayPath += math.sqrt(math.pow(ml[i + 1] - ml[i], 2) + math.pow(ap[i + 1] - ap[i], 2));
  }
  swayPath /= 32;

  // Compute the Displacement where each element is sqrt(ml^2 + ap^2)
  List<double> displacement = [];
  for (var i = 0; i < ml.length; i++) {
    displacement.add(math.sqrt(math.pow(ml[i], 2) + math.pow(ap[i], 2)));
  }

  // Compute the Mean Displacement
  double meanDisplacement = displacement.average();

  // Compute the Standard Deviation
  var stdDisplacement = displacement.std();

  // Compute the Range
  double minDisplacement = displacement.reduce(math.min);
  double maxDisplacement = displacement.reduce(math.max);

  return {
    "swayPath": swayPath,
    "meanDisplacement": meanDisplacement,
    "stdDisplacement": stdDisplacement,
    "minDist": minDisplacement,
    "maxDist": maxDisplacement,
    "outOfRange": (maxDisplacement - minDisplacement > 100) ? 1.0 : 0.0,
  };
}