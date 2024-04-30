// rental_agreement.dart

class RentalAgreement {
  final int agreementId;
  final int propertyId;
  final int tenantId;
  final int landlordId;
  final DateTime startDate;
  final DateTime endDate;
  final int monthlyRent;
  final int securityDeposit;
  final String? agreementDetails; // Optional field

  RentalAgreement({
    required this.agreementId,
    required this.propertyId,
    required this.tenantId,
    required this.landlordId,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    required this.securityDeposit,
    this.agreementDetails,
  });

  // Factory constructor to create a RentalAgreement instance from a map
  factory RentalAgreement.fromMap(Map<String, dynamic> map) {
    return RentalAgreement(
      agreementId: map['agreement_id'],
      propertyId: map['property_id'],
      tenantId: map['tenant_id'],
      landlordId: map['landlord_id'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      monthlyRent: map['monthly_rent'],
      securityDeposit: map['security_deposit'],
      agreementDetails: map['agreement_details'],
    );
  }

  // Method to convert RentalAgreement instance to a map
  Map<String, dynamic> toMap() {
    return {
      'agreement_id': agreementId,
      'property_id': propertyId,
      'tenant_id': tenantId,
      'landlord_id': landlordId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'monthly_rent': monthlyRent,
      'security_deposit': securityDeposit,
      'agreement_details': agreementDetails,
    };
  }
}



// Explanation
// Fields: Each field in the Dart class represents a column in your SQL table. Nullable fields (String?) correspond to columns that may not always have a value.
// Constructor: Uses named parameters to allow creation of RentalAgreement instances with specific values. The required keyword is used for non-nullable fields.
// Factory Constructor fromMap: Creates an instance of RentalAgreement from a map, useful when retrieving data from a database.
// Method toMap: Converts a RentalAgreement instance back to a map, useful for sending data to a database.
// This model class will help you manage rental agreement data in your Flutter application, ensuring consistency with your database schema.