
import 'package:powerdart/powerdart.dart';

/// Function to compute the frequency domain features of COGvAP and COGvML
///
/// This function compute all the frequency features required for the
/// stabilometric analysis; such as frequency mean, frequency peak and
/// where lies the 80% of the power
///
/// Here's the algorithm written in Octave:
/// ```
/// %%% Frequency Features on  COGvAP %%%%%%%%%%%%
/// nfft = round(length(statokinesigram.ap)/2);
/// [p,f] = pwelch(detrend(statokinesigram.ap),nfft, round(nfft/2), nfft, frequency);
/// [m,peak] = max(p);
/// area = cumtrapz(f,p);
/// AP_Area80 = find(area >= .80 * area(end));
/// AP_Fmean = trapz(f,f.*p)/trapz(f,p);
/// AP_Fpeak = f(peak);
/// AP_F80 = f(AP_Area80(1));
/// ```
///
/// Return:
/// a Map with: meanFrequencyAP, meanFrequencyML,
///   frequencyPeakAP, frequencyPeakML, f80AP, f80ML
Future<Map<String, double>> frequencyDomainFeatures(List<double> ap, List<double> ml, [double fs = 50]) async{
  assert(fs > 0.0, "fs must be gather than zero!");

  if (ap.isEmpty || ml.isEmpty)
    return {
      "meanFrequencyAP": double.nan,
      "meanFrequencyML": double.nan,
      "frequencyPeakAP": double.nan,
      "frequencyPeakML": double.nan,
      "f80AP": double.nan,
      "f80ML": double.nan,
    };

  // Compute the Frequency on AP
  final apPsd = psd(ap, fs);
  final apArea = cumtrapz(apPsd.pxx, apPsd.f);
  final Iterable<int> apArea80 = find(apArea, (e) => e >= 0.80 * apArea.last);
  final maxAp = maxIndexed(apPsd.pxx);

  final apFxPxx = List.generate(apPsd.f.length, (i) => apPsd.f[i] * apPsd.pxx[i]);
  final meanFrequencyAp = trapz(apPsd.f, apFxPxx) / trapz(apPsd.f, apPsd.pxx);
  final frequencyPeakAp = apPsd.f[maxAp.index];
  final f80Ap = apPsd.f[apArea80.first];

  // Compute the Frequency on ML
  final mlPsd = psd(ml, fs);
  final mlArea = cumtrapz(mlPsd.pxx, mlPsd.f);
  final Iterable<int> mlArea80 = find(mlArea, (e) => e >= 0.80 * mlArea.last);
  final maxMl = maxIndexed(mlPsd.pxx);

  final mlFxPxx = List.generate(mlPsd.f.length, (i) => mlPsd.f[i] * mlPsd.pxx[i]);
  final meanFrequencyMl = trapz(mlPsd.f, mlFxPxx) / trapz(mlPsd.f, mlPsd.pxx);
  final frequencyPeakMl = mlPsd.f[maxMl.index];
  final f80Ml = mlPsd.f[mlArea80.first];


  return {
    "meanFrequencyAP": meanFrequencyAp,
    "meanFrequencyML": meanFrequencyMl,
    "frequencyPeakAP": frequencyPeakAp,
    "frequencyPeakML": frequencyPeakMl,
    "f80AP": f80Ap,
    "f80ML": f80Ml,
  };
}