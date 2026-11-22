class City {
  final String id;
  final String name;
  final String state;
  final double latitude;
  final double longitude;

  const City({
    required this.id,
    required this.name,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  static const List<City> defaultCities = [
    City(
      id: 'indore',
      name: 'Indore',
      state: 'Madhya Pradesh',
      latitude: 22.7196,
      longitude: 75.8577,
    ),
    City(
      id: 'mumbai',
      name: 'Mumbai',
      state: 'Maharashtra',
      latitude: 19.0760,
      longitude: 72.8777,
    ),
    City(
      id: 'delhi',
      name: 'New Delhi',
      state: 'Delhi',
      latitude: 28.6139,
      longitude: 77.2090,
    ),
    City(
      id: 'bengaluru',
      name: 'Bengaluru',
      state: 'Karnataka',
      latitude: 12.9716,
      longitude: 77.5946,
    ),
    City(
      id: 'pune',
      name: 'Pune',
      state: 'Maharashtra',
      latitude: 18.5204,
      longitude: 73.8567,
    ),
  ];
}
