class UsersInfo {
  bool? status;
  List<Users>? users;
  int? countMessages;

  UsersInfo({this.status, this.users, this.countMessages});

  UsersInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
    countMessages = json['countMessages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    data['countMessages'] = countMessages;
    return data;
  }
}

class Users {
  String? phoneNumber;
  String? message;

  Users({this.phoneNumber, this.message});

  Users.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_number'] = phoneNumber;
    data['message'] = message;
    return data;
  }
}
