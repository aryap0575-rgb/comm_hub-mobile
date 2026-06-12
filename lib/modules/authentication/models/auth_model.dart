class AuthModel {
  int? userId;
  String? username;
  String? token;
  Metadata? metadata;
  String? message;

  AuthModel({
    this.userId,
    this.username,
    this.token,
    this.metadata,
    this.message,
  });

  AuthModel.fromJson(Map<String, dynamic> json) {
    final rawUserId = json['user_id'];

    if (rawUserId is int) {
      userId = rawUserId;
    } else if (rawUserId != null) {
      userId = int.tryParse(rawUserId.toString());
    } else {
      userId = null;
    }

    username = json['username']?.toString();
    token = json['token']?.toString();

    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;

    message = json['message']?.toString() ?? metadata?.message;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user_id'] = userId;
    data['username'] = username;
    data['token'] = token;

    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }

    data['message'] = message;

    return data;
  }
}

class Metadata {
  int? code;
  String? message;

  Metadata({
    this.code,
    this.message,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    final rawCode = json['code'];

    if (rawCode is int) {
      code = rawCode;
    } else if (rawCode != null) {
      code = int.tryParse(rawCode.toString());
    } else {
      code = null;
    }

    message = json['message']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['code'] = code;
    data['message'] = message;

    return data;
  }
}
