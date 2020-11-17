
import 'package:balance_app/model/statokinesigram.dart';
import 'package:floor/floor.dart';

/// Represent one single measurement in the database
@Entity(tableName: "measurements")
class Measurement {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo()
  final String token;
  // General info about the measurement
  @ColumnInfo(name: "creation_date", nullable: false)
  final int creationDate;
  @ColumnInfo(name: "eyes_open", nullable: false)
  final bool eyesOpen;

  @ColumnInfo(name: "has_features", nullable: false)
  final bool hasFeatures;
  // Computed features
  @ColumnInfo(name: "sway_path")
  final double swayPath;
  @ColumnInfo(name: "mean_displacement")
  final double meanDisplacement;
  @ColumnInfo(name: "std_displacement")
  final double stdDisplacement;
  @ColumnInfo(name: "range_min")
  final double minDist;
  @ColumnInfo(name: "range_max")
  final double maxDist;

  @ColumnInfo(name: "mean_frequency_ap")
  final double meanFrequencyAP;
  @ColumnInfo(name: "mean_frequency_ml")
  final double meanFrequencyML;
  @ColumnInfo(name: "frequency_peak_ap")
  final double frequencyPeakAP;
  @ColumnInfo(name: "frequency_peak_ml")
  final double frequencyPeakML;
  @ColumnInfo(name: "f80_ap")
  final double f80AP;
  @ColumnInfo(name: "f80_ml")
  final double f80ML;

  @ColumnInfo(name: "num_max")
  final double numMax;
  @ColumnInfo(name: "mean_time")
  final double meanTime;
  @ColumnInfo(name: "std_time")
  final double stdTime;
  @ColumnInfo(name: "mean_distance")
  final double meanDistance;
  @ColumnInfo(name: "std_distance")
  final double stdDistance;
  @ColumnInfo(name: "mean_peaks")
  final double meanPeaks;
  @ColumnInfo(name: "std_peaks")
  final double stdPeaks;

  @ColumnInfo(name: "gr_x") final double grX;
  @ColumnInfo(name: "gr_y") final double grY;
  @ColumnInfo(name: "gr_z") final double grZ;
  @ColumnInfo(name: "gm_x") final double gmX;
  @ColumnInfo(name: "gm_y") final double gmY;
  @ColumnInfo(name: "gm_z") final double gmZ;
  @ColumnInfo(name: "gv_x") final double gvX;
  @ColumnInfo(name: "gv_y") final double gvY;
  @ColumnInfo(name: "gv_z") final double gvZ;
  @ColumnInfo(name: "gk_x") final double gkX;
  @ColumnInfo(name: "gk_y") final double gkY;
  @ColumnInfo(name: "gk_z") final double gkZ;
  @ColumnInfo(name: "gs_x") final double gsX;
  @ColumnInfo(name: "gs_y") final double gsY;
  @ColumnInfo(name: "gs_z") final double gsZ;

  Measurement({
    this.id,
    this.token,
    this.creationDate,
    this.eyesOpen,
    this.hasFeatures = false,
    this.swayPath, this.meanDisplacement, this.stdDisplacement, this.minDist, this.maxDist,
    this.frequencyPeakAP, this.frequencyPeakML, this.meanFrequencyML, this.meanFrequencyAP,
    this.f80ML, this.f80AP, this.numMax, this.meanTime, this.stdTime, this.meanDistance, this.stdDistance,
    this.meanPeaks, this.stdPeaks, this.gsX, this.gsY, this.gsZ, this.gkX, this.gkY, this.gkZ,
    this.gmX, this.gmY, this.gmZ, this.gvX, this.gvY, this.gvZ, this.grX, this.grY, this.grZ
  });

  /// Creates a simple instance of [Measurement].
  ///
  /// This factory method return a new instance
  /// of [Measurement] with only [creationDate],
  /// [eyesOpen] and auto-incremented [id].
  /// The other parameters will be set to null.
  factory Measurement.simple({
    int creationDate,
    bool eyesOpen,
  }) => Measurement(creationDate: creationDate, eyesOpen: eyesOpen, hasFeatures: false);

  /// Factory method to create a [Measurement] from a 
  /// [Statokinesigram] and a [Measurement].
  /// 
  /// This method will create a new [Measurement] form an existing one and
  /// a [Statokinesigram].
  /// The new [Measurement] will retain the id of the given one.
  factory Measurement.from(Measurement m, String token, Statokinesigram s) =>
    Measurement(
      id: m.id,
      token: token,
      creationDate: m.creationDate,
      eyesOpen: m.eyesOpen,
      hasFeatures: true,
      swayPath: s.swayPath,
      meanDisplacement: s.meanDisplacement,
      stdDisplacement: s.stdDisplacement,
      minDist: s.minDist,
      maxDist: s.maxDist,
      frequencyPeakAP: s.frequencyPeakAP,
      frequencyPeakML: s.frequencyPeakML,
      meanFrequencyML: s.meanFrequencyML,
      meanFrequencyAP: s.meanFrequencyAP,
      f80ML: s.f80ML,
      f80AP: s.f80AP,
      numMax: s.numMax,
      meanTime: s.meanTime,
      stdTime: s.stdTime,
      meanDistance: s.meanDistance,
      stdDistance: s.stdDistance,
      meanPeaks: s.meanPeaks,
      stdPeaks: s.stdPeaks,
      gsX: s.gsX,
      gsY: s.gsY,
      gsZ: s.gsZ,
      gkX: s.gkX,
      gkY: s.gkY,
      gkZ: s.gkZ,
      gmX: s.gmX,
      gmY: s.gmY,
      gmZ: s.gmZ,
      gvX: s.gvX,
      gvY: s.gvY,
      gvZ: s.gvZ,
      grX: s.grX,
      grY: s.grY,
      grZ: s.grZ,
    );

  /// Maps this object to json
  Map<String, dynamic> toJson() => {
      'id': this.id,
      'token': this.token,
      'creationDate': this.creationDate,
      'eyesOpen': this.eyesOpen,
      'hasFeatures': this.hasFeatures,
      'swayPath': this.swayPath,
      'meanDisplacement': this.meanDisplacement,
      'stdDisplacement': this.stdDisplacement,
      'minDist': this.minDist,
      'maxDist': this.maxDist,
      'frequencyPeakAP': this.frequencyPeakAP,
      'frequencyPeakML': this.frequencyPeakML,
      'meanFrequencyML': (this.meanFrequencyML.isNaN) ? 0.0 : this.meanFrequencyML,
      'meanFrequencyAP': (this.meanFrequencyAP.isNaN) ? 0.0 : this.meanFrequencyAP,
      'f80ML': this.f80ML,
      'f80AP': this.f80AP,
      'np': this.numMax, 'meanTime': this.meanTime,
      'stdTime': this.stdTime, 'meanDistance': this.meanDistance,
      'stdDistance': this.stdDistance, 'meanPeaks': this.meanPeaks,
      'stdPeaks': this.stdPeaks,
      'gsX': (this.gsX.isNaN) ? 0.0 : this.gsX,
      'gsY': (this.gsY.isNaN) ? 0.0 : this.gsY,
      'gsZ': (this.gsZ.isNaN) ? 0.0 : this.gsZ,
      'gkX': (this.gkX.isNaN) ? 0.0 : this.gkX,
      'gkY': (this.gkY.isNaN) ? 0.0 : this.gkY,
      'gkZ': (this.gkZ.isNaN) ? 0.0 : this.gkZ,
      'gmX': this.gmX, 'gmY': this.gmY, 'gmZ': this.gmZ,
      'gvX': this.gvX, 'gvY': this.gvY, 'gvZ': this.gvZ,
      'grX': this.grX, 'grY': this.grY, 'grZ': this.grZ,
    };


  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is Measurement &&
        runtimeType == other.runtimeType &&
        id == other.id &&
        creationDate == other.creationDate &&
        eyesOpen == other.eyesOpen &&
        hasFeatures == other.hasFeatures &&
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
    id.hashCode ^
    creationDate.hashCode ^
    eyesOpen.hashCode ^
    hasFeatures.hashCode ^
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

  @override
  String toString() {
    return 'Measurement('
      'id: $id, creationDate: $creationDate, eyesOpen: $eyesOpen, hasFeatures: $hasFeatures, '
      'swayPath: $swayPath, meanDisplacement: $meanDisplacement, '
      'stdDisplacement: $stdDisplacement, minDist: $minDist, maxDist: $maxDist, '
      'meanFrequencyAP: $meanFrequencyAP, meanFrequencyML: $meanFrequencyML, '
      'frequencyPeakAP: $frequencyPeakAP, frequencyPeakML: $frequencyPeakML, f80AP: $f80AP, f80ML: $f80ML, '
      'np: $numMax, meanTime: $meanTime, stdTime: $stdTime, meanDistance: $meanDistance, '
      'stdDistance: $stdDistance, meanPeaks: $meanPeaks, stdPeaks: $stdPeaks, '
      'grX: $grX, grY: $grY, grZ: $grZ, gmX: $gmX, gmY: $gmY, gmZ: $gmZ, gvX: $gvX, '
      'gvY: $gvY, gvZ: $gvZ, gkX: $gkX, gkY: $gkY, gkZ: $gkZ, gsX: $gsX, gsY: $gsY, gsZ: $gsZ}';
  }


}