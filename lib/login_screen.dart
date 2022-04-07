import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kilobyte_admin_app/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String id="",password="";
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Text("HMA", style: TextStyle(fontSize: 60, color: Colors.blue, fontWeight: FontWeight.w800, letterSpacing: 3),),
                SizedBox(height: 100,),
                Text("Welcome Back!", style: TextStyle(fontSize: 30, letterSpacing: 2),),
                SizedBox(height: 30,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20), 
                    boxShadow: [BoxShadow(color: Colors.blue.withOpacity(.2), blurRadius: 50, offset: Offset(0,10))]
                  ),
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: "Enter Your Email ID", 
                              labelText: "Email ID",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10),)
                              ),
                            focusedBorder: OutlineInputBorder()),
                            onChanged: (value){id = value; setState(() {});},
                            validator: (value){
                              if(value!.isEmpty) {
                                return "Email ID cannot be empty!";
                              }
                              return null;
                            }
                          ),
                          SizedBox(height: 30,),
                          TextFormField(
                            obscureText: !_passwordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                              _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                              ), onPressed: () { 
                                setState(() {
                                  _passwordVisible = !_passwordVisible;  
                                });
                               },
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: "Enter Your Password", 
                              labelText: "Password",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10),)
                              ),
                            focusedBorder: OutlineInputBorder()),
                            onChanged: (value){password = value; setState(() {});},
                            validator: (value){
                              if(value!.isEmpty) {
                                return "Password cannot be empty!";
                              }else if (value.length<5)
                              {
                                return "Password length must be atleast 5 characters";
                              }
                              return null;
                            }
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: (){
                                moveToHome(context);
                              },
                              child: Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 2),),),
                          )
                        ],
                      )),
                  ),
                )              
            ]),
          ),
        ),
      ),
    );
  }

  moveToHome (BuildContext context) async {
      if(_formKey.currentState!.validate())
      {
        String? response = await postDataRequest(context, URLS.loginUrl, {"email":id,"password":password});
        if(response!=null)
        {
          try{
            var decodedData = jsonDecode(response);  
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool("LoggedIn", true);
            await prefs.setString("email", decodedData["email"]);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
            //Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
            showToast("Logged In Successfully!", Toast.LENGTH_SHORT, Colors.green, Colors.white);
          } on FormatException catch (e) {
            print(response);
            showToast("Invalid Id or Password", Toast.LENGTH_SHORT, Colors.red, Colors.white);  
          }
        }else{
          showToast("Request Failed. Try Again Later!", Toast.LENGTH_SHORT, Colors.red, Colors.white);
        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }      
  }

}