// recreation.dart

class Recreation {
  final String propertyId;
  final String? groceryShop1;
  final String? groceryShop2;
  final String? gym1;
  final String? gym2;
  final String? sportCenter;
  final String? amusementPark;
  final String? sportsClub;
  final String? cityPark;
  final String? mall1;
  final String? mall2;
  final String? mall3;
  final String? theater1;
  final String? theater2;
  final String? theater3;
  final String? school1;
  final String? school2;
  final String? school3;
  final String? hospital1;
  final String? hospital2;
  final String? hospital3;

  Recreation({
    required this.propertyId,
    this.groceryShop1,
    this.groceryShop2,
    this.gym1,
    this.gym2,
    this.sportCenter,
    this.amusementPark,
    this.sportsClub,
    this.cityPark,
    this.mall1,
    this.mall2,
    this.mall3,
    this.theater1,
    this.theater2,
    this.theater3,
    this.school1,
    this.school2,
    this.school3,
    this.hospital1,
    this.hospital2,
    this.hospital3,
  });

  // Factory constructor for creating an instance from a map (e.g., database row)
  factory Recreation.fromMap(Map<String, dynamic> map) {
    return Recreation(
      propertyId: map['property_id'],
      groceryShop1: map['grocery_shop1'],
      groceryShop2: map['grocery_shop2'],
      gym1: map['gym_1'],
      gym2: map['gym_2'],
      sportCenter: map['sport_center'],
      amusementPark: map['amusement_park'],
      sportsClub: map['sports_club'],
      cityPark: map['city_park'],
      mall1: map['mall_1'],
      mall2: map['mall_2'],
      mall3: map['mall_3'],
      theater1: map['theater_1'],
      theater2: map['theater_2'],
      theater3: map['theater_3'],
      school1: map['school_1'],
      school2: map['school_2'],
      school3: map['school_3'],
      hospital1: map['hospital_1'],
      hospital2: map['hospital_2'],
      hospital3: map['hospital_3'],
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'property_id': propertyId,
      'grocery_shop1': groceryShop1,
      'grocery_shop2': groceryShop2,
      'gym_1': gym1,
      'gym_2': gym2,
      'sport_center': sportCenter,
      'amusement_park': amusementPark,
      'sports_club': sportsClub,
      'city_park': cityPark,
      'mall_1': mall1,
      'mall_2': mall2,
      'mall_3': mall3,
      'theater_1': theater1,
      'theater_2': theater2,
      'theater_3': theater3,
      'school_1': school1,
      'school_2': school2,
      'school_3': school3,
      'hospital_1': hospital1,
      'hospital_2': hospital2,
      'hospital_3': hospital3,
    };
  }
}





// Explanation
// Fields: Each field in the Dart class corresponds to a column in your SQL table. The fields are nullable (String?) to account for optional amenities.
// Constructor: Uses named parameters to create instances of Recreation with specific values.
// Factory Constructor fromMap: Enables creating a Recreation instance from a map, useful for database interactions.
// Method toMap: Converts a Recreation instance back to a map, useful for sending data to a database.
// Integration in the Rentlo App
// Use this model to manage and display recreational amenities related to properties.
// Ensure proper handling of nullable fields in your application's UI and backend logic.
// This data can significantly enhance the property listing details, providing potential buyers or tenants with valuable information about nearby amenities.
