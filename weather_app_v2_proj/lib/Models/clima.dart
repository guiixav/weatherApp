class LocationInfo {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? region;

  const LocationInfo(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      this.country,
      this.region});

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
        id: json['id'],
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        country: json['country'],
        region: json['admin1']);
  }
}
