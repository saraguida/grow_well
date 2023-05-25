//This is the data model of data. 
class Data{

  //Height (cm)
  double height;
  //Weight (kg)
  double weight;
  //Hearth rate (bpm)
  double hearthRate;
  //When the meal occured
  DateTime dateTime;

  //Constructor
  Data({required this.height,required this.weight,required this.hearthRate, required this.dateTime});

}