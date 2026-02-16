class UserProfileDisplay{
  final String fullName;
  final String email;

  UserProfileDisplay({
    required this.fullName,
    required this.email,
  });

// convert json from get request to dart object
  factory UserProfileDisplay.fromJson(
    Map<String,dynamic> json){
      return UserProfileDisplay(
        fullName: json['full_name'] ?? "", 
        email: json['email'] ?? "");
    }
}