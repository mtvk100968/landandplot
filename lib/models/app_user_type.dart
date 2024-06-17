class AppUserType {
  final String phoneNumber;
  final String? altPhoneNumber;
  final String? email;
  final String? fullName;
  final String userType; // "agent", "owner", "tenant"
  final String? address;

  AppUserType({
    required this.phoneNumber,
    this.altPhoneNumber,
    this.email,
    this.fullName,
    required this.userType,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'altPhoneNumber': altPhoneNumber,
      'email': email,
      'fullName': fullName,
      'userType': userType,
      'address': address,
    };
  }

  static AppUserType fromMap(Map<String, dynamic> map) {
    return AppUserType(
      phoneNumber: map['phoneNumber'],
      altPhoneNumber: map['altPhoneNumber'],
      email: map['email'],
      fullName: map['fullName'],
      userType: map['userType'],
      address: map['address'],
    );
  }
}
