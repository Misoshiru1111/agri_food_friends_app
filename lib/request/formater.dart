// // To parse this JSON data, do
// //
// //     final formater = formaterFromJson(jsonString);

// import 'dart:convert';


// import 'package:agri_food_freind/request/data.dart';



//  class Formater<T extends Data> {
//     Formater({
//         required this.sucess,
//          requthis.data,
//         required this.message,
//     });

//     bool sucess;
//     T data;
//     String message;
//     static Formater formaterFromJson(String str) {
//       print("hi ");
//       var a=json.decode(str);
//       return(
//         Formater(
//           sucess: a["sucess"],
//           data: a['data']==null?Data.fromJson(a['data']):null,
//           message: a["message"]
//           )
//         );
//     }
//     String formaterToJson(Formater<T> data) => json.encode(data.toJson());

//     Map<String, dynamic> toJson() => {
      
//         "sucess": sucess,
//         "data": "data.toJson()",
//         "message": message,
//     };
    
// }