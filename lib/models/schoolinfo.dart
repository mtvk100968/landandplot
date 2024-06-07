class SchoolInfo {
  final String propertyId;
  final String name;
  final String type;
  final String grades;
  final double distance;
  final int rating;

  SchoolInfo({
    required this.propertyId,
    required this.name,
    required this.type,
    required this.grades,
    required this.distance,
    required this.rating,
  });

  // Static method to fetch school details
  static Map<String, SchoolInfo> fetchSchoolDetailsMap() {
    // Your implementation here
    return {
      '1': SchoolInfo(
        propertyId: '1',
        name: 'Washington B T High School',
        type: 'Public',
        grades: '9 to 12',
        distance: 2.0,
        rating: 3,
      ),
      // Add more schools as needed...
    };
  }
}