class AppUser {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? fullName;
  final String userType; // "agent", "owner", "tenant"

  AppUser({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.fullName,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'userType': userType,
    };
  }

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      fullName: map['fullName'],
      userType: map['userType'],
    );
  }
}
