class GetSpecialModel {
  final String id;
  final String itemName;
  final String description;
  final String image;
  final String price;
  final String tagLabel;
  final String startDate;
  final String endDate;

  GetSpecialModel({
    required this.id,
    required this.itemName,
    required this.description,
    required this.image,
    required this.price,
    required this.tagLabel,
    required this.startDate,
    required this.endDate,
  });

  factory GetSpecialModel.fromJson(Map<String, dynamic> json) {
    return GetSpecialModel(
      id: json["id"] ?? "",
      itemName: json["item_name"] ?? "",
      description: json["description"] ?? "",
      image: json["image"] ?? "",
      price: json["price"] ?? "",
      tagLabel: json["tag_label"] ?? "",
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"] ?? "",
    );
  }
}