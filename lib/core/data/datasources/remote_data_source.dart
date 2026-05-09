import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../modules/authentication/models/user_prfile_model.dart';
import '../../error/exception.dart';

abstract class RemoteDataSource {
  // Future<bool> forgotPassword();
  // Future<OfferBannerModel> getOfferBanner();
  // Future<CategoryModel> getHomeCategoryList();
  Future<UserProfileModel> signIn();
  // Future<bool> signUp();
  // Future<bool> setPasswordOnForgot();

  // Future<bool> verificationOtp();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  // @override
  // Future<bool> forgotPassword() {
  //   throw UnimplementedError();
  // }

  // @override
  // Future<CategoryModel> getHomeCategoryList() {
  //   throw UnimplementedError();
  // }

  // @override
  // Future<OfferBannerModel> getOfferBanner() {
  //   throw UnimplementedError();
  // }

  // @override
  // Future<bool> setPasswordOnForgot() {
  //   throw UnimplementedError();
  // }

  @override
  Future<UserProfileModel> signIn() async {
    try {
      final uri =
          Uri.parse('http://127.0.0.1:5500/test/mock_data/user_login.json');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      final responseJsonBody = _responseParser(response);
      return UserProfileModel.fromMap(responseJsonBody);
    } on SocketException {
      throw NetworkException('Connection problem');
    }
  }

//   @override
//   Future<bool> signUp() {
//     throw UnimplementedError();
//   }

//   @override
//   Future<bool> verificationOtp() {
//     throw UnimplementedError();
//   }
}

dynamic _responseParser(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 400:
      throw BadRequestException('Invalid request');
    case 401:

    case 403:
      throw UnauthorisedException('You are not unauthorised');
    case 422:
      throw BadRequestException('Invalid Request');
    case 500:
      throw InternalServerException('Internal server error');

    default:
      throw FetchDataException('Error occured while communication with Server');
  }
}
