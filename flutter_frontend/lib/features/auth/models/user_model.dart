class UserModel {
  final String accessToken;
  final String email;
  final String? lastLogin;
  final String message;

  UserModel({
    required this.accessToken,
    required this.email,
    this.lastLogin,
    required this.message,
  });

  // factory is here used to create auser from the Json response got 
  //from the backend of signup and login

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      accessToken: json['access_token'],
      email : json['email'],
      lastLogin : json['lasst_login'],
      message : json['message'],
    );
  }

}
