class MagnetoData {
  final DateTime date;
  final List<double> value;

  MagnetoData(this.date, this.value);

  DateTime get getDate => date;
  List<double> get getValue => value;
}