class DataModel {
  final String title;
  final String imageName;
  final double price;
  DataModel(
    this.title,
    this.imageName,
    this.price,
  );
}

List<DataModel> dataList = [
  DataModel("Movie 1", "assets/images/imaage.jpg", 300.8),
  DataModel("Movie 2", "assets/images/image.jpg", 245.2),
  DataModel("Movie 3", "assets/images/imaage.jpg", 168.2),
  DataModel("Movie 4", "assets/images/image.jpg", 136.7),
];
