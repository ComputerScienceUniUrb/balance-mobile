
import 'package:balance_app/model/cogv_data.dart';
import 'package:balance_app/model/measurement.dart';

/// Class representing a statokinesigram
///
/// This model class contains all the computed
/// features values for a statokinesigram: time
/// domain features, frequency domain features,
/// structural features and gyroscopic features.p
class Statokinesigram {
  final List<CogvData> cogv;

  final double swayPath;
  final double meanDisplacement;
  final double stdDisplacement;
  final double minDist;
  final double maxDist;

  final double meanFrequencyAP;
  final double meanFrequencyML;
  final double frequencyPeakAP;
  final double frequencyPeakML;
  final double f80AP;
  final double f80ML;

  final double numMax;
  final double meanTime;
  final double stdTime;
  final double meanDistance;
  final double stdDistance;
  final double meanPeaks;
  final double stdPeaks;

  final double grX;
  final double grY;
  final double grZ;
  final double gmX;
  final double gmY;
  final double gmZ;
  final double gvX;
  final double gvY;
  final double gvZ;
  final double gkX;
  final double gkY;
  final double gkZ;
  final double gsX;
  final double gsY;
  final double gsZ;

  const Statokinesigram({
    this.cogv, this.swayPath, this.meanDisplacement,
    this.stdDisplacement, this.minDist, this.maxDist, this.meanFrequencyAP, this.meanFrequencyML,
    this.frequencyPeakAP, this.frequencyPeakML, this.f80AP, this.f80ML, this.numMax, this.meanTime,
    this.stdTime, this.meanDistance, this.stdDistance, this.meanPeaks, this.stdPeaks, this.grX,
    this.grY, this.grZ, this.gmX, this.gmY, this.gmZ, this.gvX, this.gvY, this.gvZ, this.gkX,
    this.gkY, this.gkZ, this.gsX, this.gsY, this.gsZ
  });

  /// Factory method to create Statokinesigram from [measurement] and [cogvData]
  /// [measurement]: Instance of [Measurement]
  /// [cogvData]: list of [CogvData]
  factory Statokinesigram.from(Measurement measurement, List<CogvData> cogvData) =>
    Statokinesigram(
      cogv: cogvData,
      swayPath: measurement.swayPath,
      meanDisplacement: measurement.meanDisplacement,
      stdDisplacement: measurement.stdDisplacement,
      minDist: measurement.minDist,
      maxDist: measurement.maxDist,
      meanFrequencyAP: measurement.meanFrequencyAP,
      meanFrequencyML: measurement.meanFrequencyML,
      frequencyPeakAP: measurement.frequencyPeakAP,
      frequencyPeakML: measurement.frequencyPeakML,
      f80AP: measurement.f80AP,
      f80ML: measurement.f80ML,
      numMax: measurement.numMax,
      meanTime: measurement.stdTime,
      stdTime: measurement.stdTime,
      meanDistance: measurement.meanDistance,
      stdDistance: measurement.stdDistance,
      meanPeaks: measurement.meanPeaks,
      stdPeaks: measurement.stdPeaks,
      grX: measurement.grX,
      grY: measurement.grY,
      grZ: measurement.grZ,
      gmX: measurement.gmX,
      gmY: measurement.gmY,
      gmZ: measurement.gmZ,
      gvX: measurement.gvX,
      gvY: measurement.gvY,
      gvZ: measurement.gvZ,
      gsX: measurement.gsX,
      gsY: measurement.gsY,
      gsZ: measurement.gsZ,
      gkX: measurement.gkX,
      gkY: measurement.gkY,
      gkZ: measurement.gkZ,
    );

  @override
  String toString() => 'Statokinesigram(cogv: $cogv, '
      'swayPath: $swayPath, meanDisplacement: $meanDisplacement, '
      'stdDisplacement: $stdDisplacement, minDist: $minDist, maxDist: $maxDist, '
      'meanFrequencyAP: $meanFrequencyAP, meanFrequencyML: $meanFrequencyML, '
      'frequencyPeakAP: $frequencyPeakAP, frequencyPeakML: $frequencyPeakML, '
      'f80AP: $f80AP, f80ML: $f80ML, '
      'np: $numMax, meanTime: $meanTime, stdTime: $stdTime, meanDistance: $meanDistance, '
      'stdDistance: $stdDistance, meanPeaks: $meanPeaks, stdPeaks: $stdPeaks, '
      'grX: $grX, grY: $grY, grZ: $grZ, gmX: $gmX, gmY: $gmY, gmZ: $gmZ, '
      'gvX: $gvX, gvY: $gvY, gvZ: $gvZ, gkX: $gkX, gkY: $gkY, gkZ: $gkZ, '
      'gsX: $gsX, gsY: $gsY, gsZ: $gsZ}';

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is Statokinesigram &&
        runtimeType == other.runtimeType &&
        cogv == other.cogv &&
        swayPath == other.swayPath &&
        meanDisplacement == other.meanDisplacement &&
        stdDisplacement == other.stdDisplacement &&
        minDist == other.minDist &&
        maxDist == other.maxDist &&
        meanFrequencyAP == other.meanFrequencyAP &&
        meanFrequencyML == other.meanFrequencyML &&
        frequencyPeakAP == other.frequencyPeakAP &&
        frequencyPeakML == other.frequencyPeakML &&
        f80AP == other.f80AP &&
        f80ML == other.f80ML &&
        numMax == other.numMax &&
        meanTime == other.meanTime &&
        stdTime == other.stdTime &&
        meanDistance == other.meanDistance &&
        stdDistance == other.stdDistance &&
        meanPeaks == other.meanPeaks &&
        stdPeaks == other.stdPeaks &&
        grX == other.grX &&
        grY == other.grY &&
        grZ == other.grZ &&
        gmX == other.gmX &&
        gmY == other.gmY &&
        gmZ == other.gmZ &&
        gvX == other.gvX &&
        gvY == other.gvY &&
        gvZ == other.gvZ &&
        gkX == other.gkX &&
        gkY == other.gkY &&
        gkZ == other.gkZ &&
        gsX == other.gsX &&
        gsY == other.gsY &&
        gsZ == other.gsZ;

  @override
  int get hashCode =>
    cogv.hashCode ^
    swayPath.hashCode ^
    meanDisplacement.hashCode ^
    stdDisplacement.hashCode ^
    minDist.hashCode ^
    maxDist.hashCode ^
    meanFrequencyAP.hashCode ^
    meanFrequencyML.hashCode ^
    frequencyPeakAP.hashCode ^
    frequencyPeakML.hashCode ^
    f80AP.hashCode ^
    f80ML.hashCode ^
    numMax.hashCode ^
    meanTime.hashCode ^
    stdTime.hashCode ^
    meanDistance.hashCode ^
    stdDistance.hashCode ^
    meanPeaks.hashCode ^
    stdPeaks.hashCode ^
    grX.hashCode ^
    grY.hashCode ^
    grZ.hashCode ^
    gmX.hashCode ^
    gmY.hashCode ^
    gmZ.hashCode ^
    gvX.hashCode ^
    gvY.hashCode ^
    gvZ.hashCode ^
    gkX.hashCode ^
    gkY.hashCode ^
    gkZ.hashCode ^
    gsX.hashCode ^
    gsY.hashCode ^
    gsZ.hashCode;
}