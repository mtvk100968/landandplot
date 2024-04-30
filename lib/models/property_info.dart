// property_info.dart

class Property_info {
  final int propertyId;
  final String propType;
  final int bedrooms;
  final int bathrooms;
  final int carparking;
  final int totalArea;
  final int carpetArea;
  final int rentPerMonth;
  final int floorOfProp;
  final int totalFloors;
  final int noOfFlats;
  final List<String> imageUrls; // List to store multiple image URLs
  final String? extraDetails; // Optional field
  final DateTime postedDate;

  Property_info ({
    required this.propertyId,
    required this.propType,
    required this.bedrooms,
    required this.bathrooms,
    required this.carparking,
    required this.totalArea,
    required this.carpetArea,
    required this.rentPerMonth,
    required this.floorOfProp,
    required this.totalFloors,
    required this.noOfFlats,
    required this.imageUrls,
    this.extraDetails,
    required this.postedDate,
  });

  // Factory constructor for creating an instance from a map (e.g., database row)
  factory Property_info.fromMap(Map<String, dynamic> map) {
    return Property_info(
      propertyId: map['property_id'],
      propType: map['prop_type'],
      bedrooms: map['bedrooms'],
      bathrooms: map['bathrooms'],
      carparking: map['carparking'],
      totalArea: map['total_area'],
      carpetArea: map['carpet_area'],
      rentPerMonth: map['rent_per_month'],
      floorOfProp: map['floor_of_prop'],
      totalFloors: map['total_floors'],
      noOfFlats: map['no_of_flats'],
      imageUrls: List<String>.from(map['image_urls']),
      extraDetails: map['extra_details'],
      postedDate: DateTime.parse(map['posted_date']),
    ) ;
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'property_id': propertyId,
      'prop_type': propType,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'carparking': carparking,
      'total_area': totalArea,
      'carpet_area': carpetArea,
      'rent_per_month': rentPerMonth,
      'floor_of_prop': floorOfProp,
      'total_floors': totalFloors,
      'no_of_flats': noOfFlats,
      'image_urls': imageUrls,
      'extra_details': extraDetails,
      'posted_date': postedDate.toString(),
    };
  }
}







//
// Explanation
// imageUrls Field: This list holds the URLs of images associated with the property. It allows you to store multiple images for a single property.
// Factory Constructor: It includes logic to handle the imageUrls list when creating an instance from a map.
// toMap Method: Converts the instance to a map, including the list of image URLs, for storing the data in a database.
// Integration in Application
// Image Upload: Implement functionality to upload images to a storage service and retrieve their URLs.
// Form for Property Details: In the section where property details are entered, include an option to upload images. After uploading, store the returned URLs in the imageUrls list.
// Displaying Property Images: When displaying a property in your app, fetch and show all the images from the imageUrls list.
// This modification to your Property model provides a comprehensive way to store and manage multiple images for each property, enhancing the property's presentation and information in your application.