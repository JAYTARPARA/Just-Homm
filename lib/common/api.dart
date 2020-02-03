import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:justhomm/common/common.dart';
import 'package:justhomm/other-pages/profile.dart';

class API {
  var response, apiSendURL, userInfo;
  var resultError;
  var apiURL = 'https://desk.justhomm.com';
  var responseCookie;

  sendOTP(mobileNumber) async {
    apiSendURL =
        '$apiURL/api/method/justhomm.api.get_otp?mobile_no=$mobileNumber';
    try {
      response = await http.get(apiSendURL);
      return jsonDecode(response.body);
    } catch (e) {
      return 'error';
    }
  }

  verifyOTP(mobileNumber, sentOTP) async {
    apiSendURL =
        '$apiURL/api/method/justhomm.api.verify_otp?mobile_no=$mobileNumber&otp=$sentOTP';
    try {
      response = await http.get(apiSendURL);
      return jsonDecode(response.body);
    } catch (e) {
      return 'error';
    }
  }

  checkLogin(mobileNumber, password) async {
    apiSendURL = '$apiURL/api/method/login';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    var body = jsonEncode({
      'usr': '$mobileNumber',
      'pwd': '$password',
    });
    try {
      response = await http.post(apiSendURL, headers: headers, body: body);
      if (jsonDecode(response.body)['message'] == 'Logged In' ||
          jsonDecode(response.body)['message'] == 'No App') {
        await Common().writeData(
          'sid',
          response.headers['set-cookie'].split('sid')[1].split(';')[0],
        );
      }
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  getRole() async {
    apiSendURL = '$apiURL/api/method/justhomm.api.get_role';
    responseCookie = await Common().readData('sid');
    Map<String, String> headers = {"Cookie": "sid$responseCookie;"};
    // print(responseCookie);
    try {
      response = await http.get(apiSendURL, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return 'error';
    }
  }

  setRole(role) async {
    apiSendURL = '$apiURL/api/method/justhomm.api.set_role?role=$role';
    responseCookie = await Common().readData('sid');
    Map<String, String> headers = {"Cookie": "sid$responseCookie;"};
    print(responseCookie);
    try {
      response = await http.get(apiSendURL, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return 'error';
    }
  }

  logout() async {
    apiSendURL = '$apiURL/api/method/logout';
    try {
      response = await http.get(apiSendURL);
      return jsonDecode(response.body);
    } catch (e) {
      return 'error';
    }
  }

  sendPassword(mobileNumber) async {
    apiSendURL =
        '$apiURL/api/method/justhomm.api.forget_password?mobile_no=$mobileNumber';
    try {
      response = await http.get(apiSendURL);
      // print(jsonDecode(response.body)['_server_messages']);
      return jsonDecode(response.body['_server_messages']);
    } catch (e) {
      return 'error';
    }
  }

  getUserData() async {
    apiSendURL = '$apiURL/api/method/justhomm.api.update_user_profile';
    responseCookie = await Common().readData('sid');
    Map<String, String> headers = {"Cookie": "sid$responseCookie;"};
    try {
      response = await http.get(apiSendURL, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return 'error';
    }
  }

  getName() async {
    apiSendURL = '$apiURL/api/method/justhomm.api.update_user_profile';
    responseCookie = await Common().readData('sid');
    print(responseCookie);
    Map<String, String> headers = {"Cookie": "sid$responseCookie;"};
    try {
      response = await http.get(apiSendURL, headers: headers);
      userInfo = jsonDecode(response.body);
      Profile userProfile = Profile.fromJson(userInfo['message']);
      if (userProfile.first_name == null || userProfile.last_name == null) {
        return '';
      } else {
        return userProfile.first_name + ' ' + userProfile.last_name;
      }
    } catch (e) {
      return 'error';
    }
  }

  saveUserData(
    firstName,
    middleName,
    lastName,
    address,
    gender,
    email,
    dob,
  ) async {
    apiSendURL =
        '$apiURL/api/method/justhomm.api.update_user_profile?first_name=$firstName&middel_name=$middleName&last_name=$lastName&address=$address&gender=$gender&email=$email&dob=$dob';
    responseCookie = await Common().readData('sid');
    Map<String, String> headers = {"Cookie": "sid$responseCookie;"};
    try {
      response = await http.get(apiSendURL, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return 'error';
    }
  }

  changePassword(password) async {
    apiSendURL = '$apiURL/api/method/frappe.auth.get_logged_user';
    responseCookie = await Common().readData('sid');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Cookie": "sid$responseCookie;",
    };
    var body = jsonEncode({'new_password': '$password'});
    try {
      response = await http.get(apiSendURL, headers: headers);
      // print(response.body);
      var userID = jsonDecode(response.body)['message'];
      var apiSendURLPassword = '$apiURL/api/resource/User/$userID';

      var responseUpdatePassword =
          await http.put(apiSendURLPassword, headers: headers, body: body);
      // print(jsonDecode(responseUpdatePassword.body)['data']);
      return jsonDecode(responseUpdatePassword.body);
    } catch (e) {
      return 'error';
    }
  }

  getAllProperties() async {
    apiSendURL = '$apiURL/api/method/justhomm.api.get_property';
    responseCookie = await Common().readData('sid');
    Map<String, String> headers = {"Cookie": "sid$responseCookie;"};
    try {
      response = await http.get(apiSendURL, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return 'error';
    }
  }
}
