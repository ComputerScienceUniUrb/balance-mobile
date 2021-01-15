
import 'package:balance_app/manager/preference_manager.dart';
import 'package:balance_app/model/cogv_data.dart';

import 'package:balance_app/model/raw_measurement_data.dart';
import 'package:balance_app/model/statokinesigram.dart';

import 'package:balance_app/posture_processor/src/math/matrix.dart';
import 'package:balance_app/posture_processor/src/cogv_processor.dart';
import 'package:balance_app/posture_processor/src/frequency_domain_features.dart';
import 'package:balance_app/posture_processor/src/gyroscopic_features.dart';
import 'package:balance_app/posture_processor/src/sway_density_analysis.dart';
import 'package:balance_app/posture_processor/src/time_domain_features.dart';
import 'package:flutter/foundation.dart';

class PostureProcessor {
  static const double _defaultHeight = 165.0;

  /// Compute the [Statokinesigram] form list of [RawMeasurementData].
  ///
  /// This method will do the computation in a Flutter Isolate
  /// to reduce the amount of work done in the main "thread".
  /// Param:
  /// * measurementId - id of the measurement to compute
  /// * data - list of [RawMeasurementData] to compute
  static Future<Statokinesigram> computeFromData(int measurementId, List<RawMeasurementData> data) async{
    double userHeight = (await PreferenceManager.userInfo).height.toDouble();
    return compute(
      _computeFromDataImpl,
      {
        "data": data,
        "id": measurementId,
        "height": userHeight
      }
    );
  }

  /// Method that implements the Statokinesigram computation.
  ///
  /// This method is executed inside the new isolate and it's
  /// the main starting point for the features computation.
  /// Param:
  /// * args - a Map with those values: data, id, height
  static Future<Statokinesigram> _computeFromDataImpl(Map<String, Object> args) async{
    final List<RawMeasurementData> data = args["data"];

    Matrix cogvMatrix = await computeCogv(data, ((args["height"] ?? _defaultHeight) as double));
    // Convert the result from matrix to lists

    final droppedDataList = cogvMatrix?.extractRows();
    final List<double> cogvAp = droppedDataList != null? droppedDataList[0]: [];
    final List<double> cogvMl = droppedDataList != null? droppedDataList[1]: [];

    // Compute the time domain features
    final timeFeat = await timeDomainFeatures(cogvAp, cogvMl);
    // Compute the frequency domain features
    final freqFeat = await frequencyDomainFeatures(cogvAp, cogvMl);
    // Compute the structural features
    final structFeat = await swayDensityAnalysis(cogvAp, cogvMl, 0.02);
    // Compute the gyroscopic features
    final gyroFeat = await gyroscopicFeatures(data);

    // Generate the CogvData from cogvAp and cogvMl
    final List<CogvData> cogv = [];
    for (var i = 0; i < cogvAp.length; i++) {
      cogv.add(CogvData(
        measurementId: args["id"],
        ap: cogvAp[i],
        ml: cogvMl[i],
      ));
    }

    return Statokinesigram(
      cogv: cogv,
      swayPath: timeFeat["swayPath"],
      meanDisplacement: timeFeat["meanDisplacement"],
      stdDisplacement: timeFeat["stdDisplacement"],
      minDist: timeFeat["minDist"],
      maxDist: timeFeat["maxDist"],
      meanFrequencyAP: freqFeat["meanFrequencyAP"],
      meanFrequencyML: freqFeat["meanFrequencyML"],
      frequencyPeakAP: freqFeat["frequencyPeakAP"],
      frequencyPeakML: freqFeat["frequencyPeakML"],
      f80AP: freqFeat["f80AP"],
      f80ML: freqFeat["f80ML"],
      numMax: structFeat["numMax"],
      meanTime: structFeat["meanTime"],
      stdTime: structFeat["stdTime"],
      meanDistance: structFeat["meanDistance"],
      stdDistance: structFeat["stdDistance"],
      meanPeaks: structFeat["meanPeaks"],
      stdPeaks: structFeat["stdPeaks"],
      grX: gyroFeat["grX"],
      grY: gyroFeat["grY"],
      grZ: gyroFeat["grZ"],
      gmX: gyroFeat["gmX"],
      gmY: gyroFeat["gmY"],
      gmZ: gyroFeat["gmZ"],
      gvX: gyroFeat["gvX"],
      gvY: gyroFeat["gvY"],
      gvZ: gyroFeat["gvZ"],
      gsX: gyroFeat["gsX"],
      gsY: gyroFeat["gsY"],
      gsZ: gyroFeat["gsZ"],
      gkX: gyroFeat["gkX"],
      gkY: gyroFeat["gkY"],
      gkZ: gyroFeat["gkZ"],
    );
  }
}