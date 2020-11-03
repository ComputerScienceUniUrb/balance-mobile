
import 'package:balance_app/model/measurement.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: "cogv_data",
  foreignKeys: [
    ForeignKey(
      entity: Measurement,
      parentColumns: ["id"],
      childColumns: ["measurement_id"],
      onUpdate: ForeignKeyAction.CASCADE,
      onDelete: ForeignKeyAction.CASCADE,
    )
  ]
)
class CogvData {
  @PrimaryKey(autoGenerate: true) final int id;
  @ColumnInfo(name: "measurement_id", nullable: false) final int measurementId;
  @ColumnInfo() final double ap;
  @ColumnInfo() final double ml;

  CogvData({
    this.id,
    this.measurementId,
    this.ap,
    this.ml,
  });

  /// Maps this object to json
  Map toJson() => {
      "id": this.id,
      "measurementId": this.measurementId,
      "ap": this.ap,
      "ml": this.ml,
    };

  @override
  bool operator ==(other) => other is CogvData &&
    this.id == other.id &&
    this.measurementId == other.measurementId &&
    this.ap == other.ap &&
    this.ml == other.ml;

  @override
  int get hashCode {
    final prime = 31;
    int result = 1;
    result = prime * result + id.hashCode;
    result = prime * result + measurementId.hashCode;
    result = prime * result + ap.hashCode;
    result = prime * result + ml.hashCode;
    return result;
  }

  @override
  String toString() => "CogvData("
    "id=$id, "
    "measurementId=$measurementId, "
    "ap=$ap, "
    "ml=$ml)";
}