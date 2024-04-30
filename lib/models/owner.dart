// owner.dart

class Owner {
  final int ownerId;
  final String fullName;
  final String contactNumber;
  final String email;
  final String? address;
  final String? identityProof;
  final int? ownedProperties;

  Owner({
    required this.ownerId,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    this.address,
    this.identityProof,
    this.ownedProperties,
  });

  // Factory constructor for creating an instance from a map (e.g., database row)
  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      ownerId: map['owner_id'],
      fullName: map['full_name'],
      contactNumber: map['contact_number'],
      email: map['email'],
      address: map['address'],
      identityProof: map['identity_proof'],
      ownedProperties: map['owned_properties'],
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'owner_id': ownerId,
      'full_name': fullName,
      'contact_number': contactNumber,
      'email': email,
      'address': address,
      'identity_proof': identityProof,
      'owned_properties': ownedProperties,
    };
  }
}


// Notes
// In your app, ensure that there are appropriate links between the Owner table and other relevant tables like Property.
// Implement security measures to protect sensitive owner information, especially identity and contact details.
// Consider adding functionality for owners to manage their properties, view tenant details, and handle rental transactions.