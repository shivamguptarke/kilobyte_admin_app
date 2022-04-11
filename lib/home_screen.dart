import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kilobyte_admin_app/company_details.dart';
import 'package:kilobyte_admin_app/data/company_data.dart';
import 'package:kilobyte_admin_app/login_screen.dart';
import 'package:kilobyte_admin_app/routes.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  final _formKey = GlobalKey<FormState>();
  String id="",password="";
  int page = 1;
  int limit = 20, maxLimit = 50;
  bool hasmore = true, isLoading = false;

  @override
  void initState() {
    fetchMoreData();
    // TODO: implement initState
    controller.addListener(() {
      if(controller.position.maxScrollExtent==controller.offset)
      {
        fetchMoreData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.blue.withOpacity(.3), blurRadius: 20, offset: Offset(0,10))]
                ),
                child: Row(
                  children: [
                    Text("Clients", style: TextStyle(fontSize: 30, letterSpacing: 2),),
                    Spacer(),
                    IconButton(onPressed: (){
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        title: "Alert",
                        desc: "Are you sure you want to logout?",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "CANCEL",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.white,
                          ),
                          DialogButton(
                            child: Text(
                              "YES",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.clear();
                               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                LoginScreen()), (Route<dynamic> route) => false);
                            },
                            color: Colors.blue,
                          )
                        ],
                      ).show();
                    }, icon: Icon(Icons.logout))
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {  
                    setState(() {
                      page = 1;
                      hasmore = true;
                      CompanyDataModel.companyDataList.clear();
                      fetchMoreData();
                    });
                  },
                  child: ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: CompanyDataModel.companyDataList.length + 1,
                    itemBuilder: (context, index) => 
                    (index<CompanyDataModel.companyDataList.length) ? client_widget(companyData : CompanyDataModel.companyDataList.elementAt(index)) : 
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            hasmore ? CircularProgressIndicator() : Text("No more data to load")
                          ],
                        ),
                      ),
                    )
                  ),
                ),
              ),
            ]
          )
        )
      )
    );
  }

  Future fetchMoreData() async {
    var dataResponse = await getDataRequest("http://hmaapi.kilobytetech.com/users?pageNo=$page&size=$limit");
    if(dataResponse!=null)
    {
      try{
        maxLimit = dataResponse['_metaData']['total_count'];
        limit = dataResponse['_metaData']['per_page'];
      //log( ' -------    '  + dataResponse.toString());
      //log( ' -------    '  + dataResponse['records'].toString());
      log(maxLimit.toString() + limit.toString());
      List<CompanyData> companyNewList = List.from(dataResponse['records']).map<CompanyData>((company) => CompanyData.fromMap(company)).toList();
      CompanyDataModel.companyDataList.addAll(companyNewList);
      //showToast("Data Loaded!  "  + companyNewList.length.toString() + CompanyDataModel.companyDataList.length.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
      if(hasmore)
      {
        if(isLoading) return;
        isLoading = true;
        log("-------------company list size---------" + CompanyDataModel.companyDataList.length.toString());
        if(companyNewList.length<limit)
        {
          hasmore = false;
        }
        //await Future.delayed(Duration(milliseconds: 2000));
        setState(() {
          isLoading = false;
      //   showToast("Data Loaded!  ",Toast.LENGTH_LONG,Colors.green,Colors.white);
          page++;
        });
      }
      log( ' -------    '  + dataResponse.toString());
      }catch (e){
        log(e.toString());
      }
    }else{
      showToast("Something went wrong. Try again Later!",Toast.LENGTH_LONG,Colors.red,Colors.white);
    }
  }
}

class client_widget extends StatelessWidget {
  final CompanyData companyData;
  const client_widget({
    Key? key, required this.companyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String temp='';
    for (var item in companyData.communicationEmails) {
      temp = temp + item + ", " ;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(.3), blurRadius: 20, offset: Offset(0,10))]
      ),
      margin: EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CompanyDetailScreen(companyData: companyData)));
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("#" + companyData.clientID, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w800),),
                    Spacer(),
                    Text("Created On : " +  DateFormat('dd-MM-yy, hh:mm a').format(DateTime.parse(companyData.updatedAt)), style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w800),),
                  ],
                ),
                SizedBox(height: 10,),
                Text(companyData.companyName, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 15),),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Assigned Members : ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w800),),
                    Expanded(child: Text(companyData.communicationEmails.isNotEmpty ? temp : "NONE")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}