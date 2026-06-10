class LoginResponse {
  final String? username;
  final String? token;
  final Metadata? metadata;

  LoginResponse({
    this.username,
    this.token,
    this.metadata,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      username: json['username'],
      token: json['token'],
      metadata:
          json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'token': token,
      'metadata': metadata?.toJson(),
    };
  }
}

class Metadata {
  final int? code;
  final String? message;

  Metadata({
    this.code,
    this.message,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}

class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "username": username,
      "password": password,
      "confirm_password": confirmPassword,
    };
  }
}
