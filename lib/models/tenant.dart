// tenant.dart

class Tenant {
  final String tenantId;
  final String propertyId;
  final List<String> tenantNames; // List to accommodate multiple tenant names
  final String noOfTenants;
  final List<String> tenantPhoneNumbers; // List for multiple phone numbers
  final List<String> tenantIdProofs; // List for multiple ID proofs
  final List<String> addresses; // List for multiple addresses

  Tenant({
    required this.tenantId,
    required this.propertyId,
    required this.tenantNames,
    required this.noOfTenants,
    required this.tenantPhoneNumbers,
    required this.tenantIdProofs,
    required this.addresses,
  });

  // Factory constructor to create a Tenant instance from a map
  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      tenantId: map['tenant_id'],
      propertyId: map['property_id'],
      tenantNames: List<String>.from(map['tenant_name']),
      noOfTenants: map['no_of_tenants'],
      tenantPhoneNumbers: List<String>.from(map['tenantt_phnum']),
      tenantIdProofs: List<String>.from(map['tenant_id_proof']),
      addresses: List<String>.from(map['address']),
    );
  }

  // Method to convert Tenant instance to a map
  Map<String, dynamic> toMap() {
    return {
      'tenant_id': tenantId,
      'property_id': propertyId,
      'tenant_name': tenantNames,
      'no_of_tenants': noOfTenants,
      'tenantt_phnum': tenantPhoneNumbers,
      'tenant_id_proof': tenantIdProofs,
      'address': addresses,
    };
  }
}


// Explanation
// Fields: The fields tenantNames, tenantPhoneNumbers, tenantIdProofs, and addresses are now lists to accommodate multiple entries for each.
// Constructor: The constructor initializes these fields with the required data.
// Factory Constructor fromMap: Converts a map (like a database row) to a Tenant instance. Assumes the data is stored in a list-like structure in the database.
// Method toMap: Converts the Tenant instance back to a map, suitable for storing in a database.
// Important Considerations
// Database Structure: Ensure that your database can store these list-like structures. If using a relational database, this might require a separate table for tenant details with a one-to-many relationship.
// Data Handling: When adding or updating tenant information in the app, you'll need to handle adding elements to these lists.
// UI Implementation: The user interface for adding tenants will need to support adding multiple entries for names, phone numbers, ID proofs, and addresses.
// This approach provides the flexibility needed for handling multiple tenants per property in the Rentlo app.
//



