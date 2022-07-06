
/// Base event of the result page
abstract class ResultEvents {
  const ResultEvents();
}

/// Event for fetch the result
class FetchResult extends ResultEvents {
  final int measurementId;
  const FetchResult(this.measurementId);
}

/// Event for export a measurement with id [measurementId]
class ExportResult extends ResultEvents {
  final int measurementId;
  const ExportResult(this.measurementId);
}

/// Event for saving a screenshot of a measurement with id [measurementId]
class SaveScreenshot extends ResultEvents {
  final int measurementId;
  final List<int> image;
  const SaveScreenshot(this.measurementId, this.image);
}