
// property_distance.dart

class PropertyDistance {
  final String propertyId;
  final int adjRoadInFeet;
  final int mainRoad;
  final int shighway;
  final int nhighway;
  final String railwayStation;
  final String airport;
  final int expressway;
  final int orr;
  final int rrr;
  final String? metro;  // Optional since it might not be applicable for all properties
  final String? mmts;   // Optional
  final String? busTerminal; // Optional

  PropertyDistance({
    required this.propertyId,
    required this.adjRoadInFeet,
    required this.mainRoad,
    required this.shighway,
    required this.nhighway,
    required this.railwayStation,
    required this.airport,
    required this.expressway,
    required this.orr,
    required this.rrr,
    this.metro,
    this.mmts,
    this.busTerminal,
  });

  // Factory constructor for creating an instance from a map (e.g., database row)
  factory PropertyDistance.fromMap(Map<String, dynamic> map) {
    return PropertyDistance(
      propertyId: map['property_id'],
      adjRoadInFeet: map['adj_road_in_feet'],
      mainRoad: map['mainroad'],
      shighway: map['shighway'],
      nhighway: map['nhighway'],
      railwayStation: map['railway_station'],
      airport: map['airport'],
      expressway: map['expressway'],
      orr: map['orr'],
      rrr: map['rrr'],
      metro: map['metro'],
      mmts: map['mmts'],
      busTerminal: map['bus_terminal'],
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'property_id': propertyId,
      'adj_road_in_feet': adjRoadInFeet,
      'mainroad': mainRoad,
      'shighway': shighway,
      'nhighway': nhighway,
      'railway_station': railwayStation,
      'airport': airport,
      'expressway': expressway,
      'orr': orr,
      'rrr': rrr,
      'metro': metro,
      'mmts': mmts,
      'bus_terminal': busTerminal,
    };
  }
}



// Explanation
// Fields: Each field in the Dart class corresponds to a column in your SQL table. Nullable fields (String?) are used for optional data.
// Constructor: Uses named parameters to allow creation of PropertyDistance instances with specific values.
// Factory Constructor fromMap: Enables creating a PropertyDistance instance from a map, useful when retrieving data from a database.
// Method toMap: Converts a PropertyDistance instance back to a map, useful for sending data to a database.
// Integration in the Rentlo App
// When integrating this model with your database operations, use the toMap and fromMap methods for serialization and deserialization of data.
// Ensure that the app's logic can handle adding, updating, and removing property distance records.
// This data can be very useful for users evaluating property locations in relation to important infrastructure like roads, public transport, and airports.
// This PropertyDistance class will help you effectively manage property distance-related data within your application, ensuring data consistency and facilitating database interactions.
