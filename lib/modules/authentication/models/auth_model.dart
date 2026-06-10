class AuthModel {
  String? status;
  String? message;
  String? token;
  User? user;

  AuthModel({
    this.status,
    this.message,
    this.token,
    this.user,
  });

  AuthModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    user = json['user'] != null
        ? User.fromJson(json['user'])
        : null;
  }

  get username => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['status'] = status;
    data['message'] = message;
    data['token'] = token;

    if (user != null) {
      data['user'] = user!.toJson();
    }

    return data;
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? fullname;
  String? photo;

  User({
    this.id,
    this.username,
    this.email,
    this.fullname,
    this.photo,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    fullname = json['fullname'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['fullname'] = fullname;
    data['photo'] = photo;

    return data;
  }
}