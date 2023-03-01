// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';
// import 'dart:html';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
    Event({
        required this.title,
        required this.account,
        required this.createTime,
        required this.content,
        required this.msg,
        required this.article_id
    });

    String title;
    String account;
    DateTime createTime;
    String content;
    int article_id;
    List<Msg> msg;

    factory Event.fromJson(Map<String, dynamic> json) => Event(
      article_id:json["article_id"],
        title: json["title"],
        account: json["account"],
        createTime: DateTime.parse(json["creat_time"]),
        content: json["content"],
        msg: json["msg"].length!=0?List<Msg>.from(json["msg"].map((x) => Msg.fromJson(x))):[],
        // msg:[]
    );

    Map<String, dynamic> toJson() => {
      
        "title": title,
        "account": account,
        "time": createTime.toIso8601String(),
        "content": content,
        "msg": List<dynamic>.from(msg.map((x) => x.toJson())),
    };
}

class Msg {
    Msg({
        required this.account,
        required this.time,
        required this.content,
        required this.article_id,
    });

    String account;
    String time;
    String content;
    int article_id;

    factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        account: json["user_id"] == null ? null : json["user_id"],
        time: json["time"] == null ? null : json["time"],
        content: json["m_c"] == null ? null : json["m_c"],
        article_id: json['article_id']==null?null:json["article_id"]
    );

    Map<String, dynamic> toJson() => {
        "user_id": account == null ? null : account,
        "time": time == null ? null : time,
        "content": content == null ? null : content,
        "article_id":article_id== null ? null : article_id,
    };
}
