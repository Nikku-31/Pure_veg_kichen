class AddressModel {
  final String type;
  final String address;
  final String addressDetails;
  final String receiverName;
  final String receiverPhone;
  final double latitude;
  final double longitude;
  final String addressName;
  final String landmark;
  final String instruction;

  AddressModel({
    required this.type,
    required this.address,
    required this.addressDetails,
    required this.receiverName,
    required this.receiverPhone,
    required this.latitude,
    required this.longitude,
    required this.addressName,
    required this.landmark,
    required this.instruction,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "address": address,
      "addressDetails": addressDetails,
      "receiverName": receiverName,
      "receiverPhone": receiverPhone,
      "latitude": latitude,
      "longitude": longitude,
      "addressName": addressName,
      "landmark": landmark,
      "instruction": instruction,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      type: json["type"] ?? "",
      address: json["address"] ?? "",
      addressDetails: json["addressDetails"] ?? "",
      receiverName: json["receiverName"] ?? "",
      receiverPhone: json["receiverPhone"] ?? "",
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
      addressName: json["addressName"] ?? "",
      landmark: json["landmark"] ?? "",
      instruction: json["instruction"] ?? "",
    );
  }

  AddressModel copyWith({
    String? type,
    String? address,
    String? addressDetails,
    String? receiverName,
    String? receiverPhone,
    double? latitude,
    double? longitude,
    String? addressName,
    String? landmark,
    String? instruction,
  }) {
    return AddressModel(
      type: type ?? this.type,
      address: address ?? this.address,
      addressDetails: addressDetails ?? this.addressDetails,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      addressName: addressName ?? this.addressName,
      landmark: landmark ?? this.landmark,
      instruction: instruction ?? this.instruction,
    );
  }
}