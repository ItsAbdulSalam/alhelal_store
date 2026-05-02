class AddressModel {
  final String? id;
  final String title;
  final String desc;
  final double lat;
  final double lng;
  final bool isDefault;

  AddressModel({
    this.id,
    required this.title,
    required this.desc,
    required this.lat,
    required this.lng,
    this.isDefault = false,
  });

  // تحويل الكائن إلى Map لحفظه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': desc,
      'lat': lat,
      'lng': lng,
      'isDefault': isDefault,
      'createdAt': DateTime.now(),
    };
  }
}