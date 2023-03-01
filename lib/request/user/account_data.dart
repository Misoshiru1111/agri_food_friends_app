// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:agri_food_freind/request/data.dart';

// String userToJson(User data) => json.encode(data.toJson());

class User extends Data {
  // User FromJson(String str) => User.fromJson(json.decode(str));

  User({
    required this.account,
    required this.password,
    this.name,
    this.pfpicId,
    this.usertypeId,
    this.areaId,
  });

  String account;
  String password;
  dynamic name;
  dynamic pfpicId;
  dynamic usertypeId;
  dynamic areaId;

  // factory User._fromJson(Map<String, dynamic> json) => User(
  //       account: json["account"],
  //       password: json["password"],
  //       name: json["name"],
  //       pfpicId: json["pfpic_id"],
  //       usertypeId: json["usertype_id"],
  //       areaId: json["area_id"],
  //     );

  @override
  Map<String, dynamic> toJson() => {
        "account": account,
        "password": password,
        "name": name,
        "pfpic_id": pfpicId,
        "usertype_id": usertypeId,
        "area_id": areaId,
      };

  @override
  String datatoJson(Data data) {
    json.encode(data.toJson());
    // TODO: implement dataformJson
    throw UnimplementedError();
  }
  @override
  static User fromJson(String str) {
    var d=json.decode(str);
    return User(
        account: d["account"],
        password: d["password"],
        name: d["name"],
        pfpicId: d["pfpic_id"],
        usertypeId: d["usertype_id"],
        areaId: d["area_id"],
      );
    
  }
}
