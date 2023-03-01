import 'dart:convert';

import '../api.dart';
import 'event_list.dart';
import 'package:http/http.dart' as http;

abstract class EventAPI {
  //發文
  Future<String> post(Event e);

  /// 查詢文章列表
  Future<List<Event>> getEventList();

  //留言
  Future<String> msg(Msg m);

  /// 編輯文章列表
  // Future<String> updatePost(int id, Event event);
}

class EventRepo extends API implements EventAPI {
  @override
  Future<List<Event>> getEventList() async {
    print("i'm post funcion");
    List<Event> res = [];
    try {
      final response = await client.get(
        Uri.parse('$domain/post/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print("evnet list 200");
        json.decode(response.body).forEach((e) {
          print(e['msg'].length);
          res.add(Event.fromJson(e));
        });
        //    List<Event> list = json.decode(response.body)
        // .map((data) => Event.fromJson(data))
        // .toList();
        // print(list.isEmpty);
        // res=list;
      }
    } catch (e) {
      print(e.toString());
    }

    return res;
    // TODO: implement getEventList
    // throw "error";
  }

  @override
  Future<String> post(Event e) async {
    String res = "";
    try {
      final response = await client.post(Uri.parse('$domain/post/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(e.toJson()));
      if (response.statusCode == 200) {
        print("evnet post 200");
        print(response.body);
        res = response.body.toString();
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
    // finally{}
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<String> msg(Msg m) async {
    String res = "";
    try {
      final response = await client.post(Uri.parse('$domain/post/mes'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(m.toJson()));
      if (response.statusCode == 200) {
        print("evnet post 200");
        print(response.body);
        res = response.body.toString();
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
    // TODO: implement msg
    throw UnimplementedError();
  }
}
