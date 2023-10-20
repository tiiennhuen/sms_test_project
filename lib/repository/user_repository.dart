import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms_test_project/models/user.dart';

class UserRepository {
  static const String staging =
      'https://keepyoursight.staging.corpsoft.io/api/messages/dispatch/8RQJC8qbQ8ac';
  static const String production =
      'https://remonihealth.online/api/messages/dispatch/8RQJC8qbQ8ac';

  Future<List<Users>> fetchUsers() async {
    var url = Uri.parse(
      // staging,
      production,
    );
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final users = data["users"] as List;

      List<Users> userList = users.map((user) {
        return Users(
            phoneNumber: user["phone_number"], message: user["message"]);
      }).toList();

      return userList;
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}
