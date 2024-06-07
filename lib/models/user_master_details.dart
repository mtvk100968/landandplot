// user_master_details.dart

class UserMasterDetails {
  final String agentId;
  final String propertyId;
  final String imageUrl;
  final String agentIdProof; // Stores the file path or URL of the image
  final String agentName;
  final String company;
  final String agentPhoneNumber;
  final String email;
  final String cityName;
  final String tmcName;
  final String districtName;
  final String stateName;
  final String pincode;

  UserMasterDetails({
    required this.agentId,
    required this.propertyId,
    required this.imageUrl,
    required this.agentIdProof,
    required this.agentName,
    required this.company,
    required this.agentPhoneNumber,
    required this.email,
    required this.cityName,
    required this.tmcName,
    required this.districtName,
    required this.stateName,
    required this.pincode,
  });

//   // Factory constructor to create an Agent instance from a map
//   factory AgentDetails.fromMap(Map<String, dynamic> map) {
//     return AgentDetails(
//       agentId: map['agent_id'],
//       propertyId: map['property_id'],
//       imageUrl: map['imageUrl'],
//       agentIdProof: map['agent_id_proof'],
//       agentName: map['agent_name'],
//       company: map['company'],
//       agentPhoneNumber: map['agent_phnum'],
//       cityName: map['city_name'],
//       tmcName: map['tmc_name'],
//       districtName: map['district_name'],
//       stateName: map['state_name'],
//       pincode: map['pincode'],
//     );
//   }
//
//   // Method to convert Agent instance to a map
//   Map<String, dynamic> toMap() {
//     return {
//       'agent_id': agentId,
//       'property_id': propertyId,
//       'imageUrl': imageUrl,
//       'agent_id_proof': agentIdProof,
//       'agent_name': agentName,
//       'company': company,
//       'agent_phnum': agentPhoneNumber,
//       'city_name': cityName,
//       'tmc_name': tmcName,
//       'district_name': districtName,
//       'state_name': stateName,
//       'pincode': pincode,
//     };
//   }
// }


  static Map<String, UserMasterDetails> fetchAgentDetailsMap() {
// Your implementation here
    return {
      '1': UserMasterDetails(
        propertyId: '1',
        imageUrl: 'https://cdn.pixabay.com/photo/2016/07/08/23/17/woman-1505407_1280.jpg',
        agentName: 'polasa Harsha',
        company: 'R Ltd',
        agentId: 'A001',
        agentIdProof: '',
        agentPhoneNumber: '+919898989898',
        email: 'tirupathim@gmail.com',
        cityName: '',
        tmcName: '',
        districtName: '',
        stateName: '',
        pincode: '',
      ),
      '2': UserMasterDetails(
        propertyId: '2',
        imageUrl: 'https://cdn.pixabay.com/photo/2016/03/23/04/01/woman-1274056_1280.jpg',
        agentName: 'Puppla Narender',
        company: 'R Ltd',
        agentId: 'A002',
        agentIdProof: '',
        agentPhoneNumber: '+919996665544',
        email: 'tvkmrudula@gmail.com',
        cityName: '',
        tmcName: '',
        districtName: '',
        stateName: '',
        pincode: '',
      ),
    };
  }
}


// Explanation
// Fields: Each field in the Dart class corresponds to a column in your SQL table.
// Agent ID Proof: The agentIdProof field is a string that should store the path or URL to the agent's ID proof image. You will need to handle the image upload separately and store the reference in this field.
// Constructor: The named parameters in the constructor allow you to create instances of Agent with specific values.
// Factory Constructor fromMap: This constructor enables creating an Agent instance from a map, which is useful when retrieving data from a database.
// Method toMap: Converts an Agent instance back to a map, useful for sending data to a database.
// Integration in the Rentlo App
// You'll need to implement functionality for uploading and storing images (agent ID proofs) and saving their paths or URLs in the agentIdProof field.
// Ensure that the app's logic can handle adding, updating, and removing agent records.
// Consider the privacy and security of the agents' personal information, especially their ID proofs and contact details

