import 'package:floor/floor.dart';

@entity
class Data {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  //Height (cm)
  final double height;

  //Weight (kg)
  final double weight;

  //Hearth rate (bpm)
  final double hearthRate;

  //When the data is entered
  final DateTime dateTime;

  //HFA reference value
  final double? ReferenceValueHFA;

  //WFH reference value
  final double? ReferenceValueWFH;

  //Default constructor
  Data(this.id, this.height, this.weight, this.hearthRate, this.dateTime,
      this.ReferenceValueHFA, this.ReferenceValueWFH);
}//Data
