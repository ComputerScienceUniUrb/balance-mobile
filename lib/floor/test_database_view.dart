
import 'package:balance/model/measurement.dart';
import 'package:floor/floor.dart';

/// [DatabaseView] used to access part of [Measurement]
///
/// This class is a [DatabaseView] used to return only one
/// part of a Measurement: his [id], [creationDate] and
/// [eyesOpen].
/// A database view is a read-only mechanism, so instances of
/// this class can be obtained only one DAO. The constructor is
/// here for the DAO, to create or update the data consider using
/// the methods for Measurements.
///
/// See also:
///  * [Measurement]
@DatabaseView("SELECT id, creation_date, eyes_open, invalid, sent FROM measurements", viewName: "tests")
class Test {
  @ColumnInfo(name: "id")
  final int id;
  @ColumnInfo(name: "creation_date")
  final int creationDate;
  @ColumnInfo(name: "eyes_open")
  final bool eyesOpen;
  @ColumnInfo(name: "invalid")
  final bool invalid;
  @ColumnInfo(name: "sent")
  final bool sent;

  Test({this.id, this.creationDate, this.eyesOpen, this.invalid, this.sent});

  @override
  bool operator ==(other) => other is Test &&
    other.id == id &&
    other.creationDate == creationDate &&
    other.eyesOpen == eyesOpen &&
    other.invalid == invalid &&
    other.sent == sent;

  @override
  int get hashCode {
    final prime = 31;
    int result = 1;
    result = prime * result + id.hashCode;
    result = prime * result + creationDate.hashCode;
    result = prime * result + eyesOpen.hashCode;
    result = prime * result + invalid.hashCode;
    result = prime * result + sent.hashCode;
    return result;
  }

  @override
  String toString() => "Test(id=$id, creationDate=$creationDate, eyesOpen=$eyesOpen, invalid=$invalid, sent=$sent)";
}