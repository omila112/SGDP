class chemicals {
  String name;
  String price;
  String imagepath;
  String Rating;

  chemicals(
      {required this.name,
      required this.price,
      required this.imagepath,
      required this.Rating});

  String get _name => name;
  String get _price => price;
  String get _imagepath => imagepath;
  String get _Rating => Rating;
}
