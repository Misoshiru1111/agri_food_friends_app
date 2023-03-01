import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../myData.dart';

class Activity extends StatelessWidget {
  const Activity({super.key});
  void show(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: Text("太康有機食農教育體驗"),
      content: Column(children: [
        Text("開始日 2022-11-19"),
        Text("結束日 2022-11-19"),
        Text("地點 736台南市柳營區義士路三段121號"),
        Text(
            "推動有機田區食農教育體驗活動，讓消費者及親子團體，在安全無農藥汙染的園區裡，能盡情地體驗有機栽培跟蔬果採收的樂趣，本年度以「好食趣」為活動主軸，當天活動除了有體驗種菜、採果、拔蘿蔔、捆稻草競賽及手作DIY等活動外，中午還能享用有機專區生產的農場餐食，另外凡參加本次體驗活動的民眾，皆能獲得\$100元蔬果兌換券，可兌換專區生產的等值有機蔬果或農產加工品，歡迎大家逗陣來食當季呷健康〜"),
      ]),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: MyTheme.dartColor),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("確認"))
      ],
    );
    showDialog(context: context, builder: ((context) => dialog));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(children: [
        Text("食農相關活動",style: TextStyle(fontSize: 30),),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: MyTheme.dartColor),
            onPressed: () {
              show(context);
            },
            child: Text("太康有機食農教育體驗"))
      ]),
    );
  }
}
