import 'dart:convert';

import 'package:agri_food_freind/request/api.dart';
import 'package:http/http.dart' as http;

import '../formater.dart';
import 'account_data.dart';

abstract class AccountAPI{
  //註冊會員
  // Future<String> createUser();

  /// 登入
  Future<String> login(String user, String psw);

  /// 編輯會員
  // Future<String> updateUser(int id, User user);
}

class AccountRepo extends API implements AccountAPI {

  
  

  @override
  Future<String> login(String user, String psw) async {
    
    // print(User(account: "11136015", password: "111").toJson());
    try {
      final response = await client.post(Uri.parse('$domain/user/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body:
              jsonEncode(User(account: user, password: psw).toJson()));
      if (response.statusCode == 200) {
        // try {
          var omg =json.decode(response.body);
          var oomg=omg['data']['data'][0];
          print("this is oomg"+oomg.toString());

          var ooomg = User.fromJson(json.encode(oomg));
          return "gogo";
          // print(json.encode(omg['data']));
          // var ommg = User.fromJson(json.encode(omg['data']));
          // var temp = Formater.formaterFromJson(response.body,User.fromJson);
          // print(ommg.toString());
        // } 
        // catch (e) {
        //   print("catch here");
        //   print(e.toString());
        // }
       

        // return Event.fromJson(jsonDecode(response.body));
      } else {
        return "";
        // return Event.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e.toString());
    }
    // TODO: implement login
    throw "error";
  }
}
