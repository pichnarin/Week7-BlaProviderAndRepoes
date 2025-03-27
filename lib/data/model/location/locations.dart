///
/// Enumation of available BlaBlaCar countries
///
enum Country {
  france('France'),
  uk('United Kingdom'),
  cambodia('Cambodia'),
  spain('Spain');

  final String name;

  const Country(this.name);
}

///
/// This model describes a location (city, street).
///
class Location {
  final String name;
  final Country country;

  const Location({required this.name, required this.country});

  // Copy constructor
  Location.copy(Location other)
      : name = other.name,
        country = other.country;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location && other.name == name && other.country == country;
  }

  @override
  int get hashCode => name.hashCode ^ country.hashCode;

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'country': country.name,

  };

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    name: json['name'],
    country: json['country'] == 'france'
        ? Country.france
        : json['country'] == 'uk'
        ? Country.uk
        : json['country'] == 'cambodia'
        ? Country.cambodia
        : json['country'] == 'spain'
        ? Country.spain
        : throw Exception("Unknown country ${json['country']}"),
  );
}
