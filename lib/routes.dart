import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class MyRoutes{
  // static String splashRoute = "/";
  // static String loginRoute = "/login";
  // static String homeRoute = "/home";
  //static String initialUrlRoute = "http://hmaapi.kilobytetech.com/auth/login";
}

class URLS{
  static String loginUrl = "http://hmaapi.kilobytetech.com/auth/login";
  static String getClientsUrl = "http://hmaapi.kilobytetech.com/users?pageNo=1&size=20";
}

Future<String?> postDataRequest(BuildContext  context,String urlAddress, Map<String, dynamic> jsonData,) async {
    print(urlAddress + jsonData.toString());
    String? dataResponse;

    try{
      showLoaderDialog(context);
      final http.Response response = await http.post(
        Uri.parse(urlAddress),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        //pass data
        body: jsonEncode(jsonData) ,
      );

      Navigator.pop(context);
    
      dataResponse = response.body;
      log("-----------------"+ response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        //showToast("Saved Data Successfully",Toast.LENGTH_LONG,Colors.green,Colors.white);
        } else {
          //showToast("Request Failed. Try Again Later!",Toast.LENGTH_LONG,Colors.red,Colors.white);
          dataResponse = null;
          //throw Exception('Failed to Post Data Request');
      }
      return dataResponse;
    }on SocketException{
      Navigator.pop(context);
      print("socketexception");
      //showToast("Network Connection Failed",Toast.LENGTH_LONG,Colors.red,Colors.white);
      return null;
    }
}

Future<dynamic> getDataRequest(String urlAddress) async {
    //await Future.delayed(Duration(seconds: 2));
    try{
      final response = await http.get(Uri.parse(urlAddress));
      var decodeddata;
      print(urlAddress);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        try{
          decodeddata = jsonDecode(response.body);
          print(decodeddata.toString());
          return decodeddata;
        } on FormatException catch (e) {
          print('The provided string is not valid JSON' + response.body);
          return null;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load data');
      }
    }on SocketException{
      print("socketexception");
      return null;
    }
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20,),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading...." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  showToast(String message, Toast tLength, Color bgcolor, Color txtcolor)
  {
    Fluttertoast.showToast(
        msg: message,
        toastLength: tLength,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: bgcolor,
        textColor: txtcolor,
        fontSize: 16.0
      );
  }