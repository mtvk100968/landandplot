// company_agent.dart

class CompanyAgent {
  final String compAgentId;
  final String propertyId;
  final String agentName;
  final String agentPhoneNumber;
  final String address;
  final String tmcName;
  final String districtName;
  final String stateName;
  final int pincode;

  CompanyAgent({
    required this.compAgentId,
    required this.propertyId,
    required this.agentName,
    required this.agentPhoneNumber,
    required this.address,
    required this.tmcName,
    required this.districtName,
    required this.stateName,
    required this.pincode,
  });

  // Factory constructor for creating an instance from a map (e.g., database row)
  factory CompanyAgent.fromMap(Map<String, dynamic> map) {
    return CompanyAgent(
      compAgentId: map['comp_agent_id'],
      propertyId: map['property_id'],
      agentName: map['agent_name'],
      agentPhoneNumber: map['agent_phnum'],
      address: map['address'],
      tmcName: map['tmc_name'],
      districtName: map['district_name'],
      stateName: map['state_name'],
      pincode: map['pincode'],
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'comp_agent_id': compAgentId,
      'property_id': propertyId,
      'agent_name': agentName,
      'agent_phnum': agentPhoneNumber,
      'address': address,
      'tmc_name': tmcName,
      'district_name': districtName,
      'state_name': stateName,
      'pincode': pincode,
    };
  }
}




// Explanation
// Fields: Each field in the Dart class corresponds to a column in your SQL table.
// Constructor: Uses named parameters to allow creation of CompanyAgent instances with specific values.
// Factory Constructor fromMap: Enables creating a CompanyAgent instance from a map, useful when retrieving data from a database.
// Method toMap: Converts a CompanyAgent instance back to a map, useful for sending data to a database.
// Integration in the Rentlo App
// When integrating this model with your database operations, use the toMap and fromMap methods for serialization and deserialization of data.
// Ensure that the app's logic can handle adding, updating, and removing company agent records.
// Consider the privacy and security of the agents' personal information, especially their contact details.
// This CompanyAgent class will help you effectively manage company agent-related data within your application, ensuring data consistency and facilitating database interactions