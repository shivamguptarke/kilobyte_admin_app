import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kilobyte_admin_app/company_details.dart';
import 'package:kilobyte_admin_app/data/company_data.dart';
import 'package:kilobyte_admin_app/routes.dart';

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
  int sampleSize = 7, limit = 10, maxLimit = 50;
  bool hasmore = true, isLoading = false;

  @override
  void initState() {
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
          
          color: Colors.white10,
          child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Clients", style: TextStyle(fontSize: 30, letterSpacing: 2),),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  itemCount: sampleSize + 1,
                  itemBuilder: (context, index) => 
                  (index<sampleSize) ? client_widget() : 
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
            ]
          )
        )
      )
    );
  }

  Future? loadClientsData() async {
    var dataResponse = await getDataRequest(URLS.getClientsUrl);
    if(dataResponse!=null)
    {
      CompanyDataModel.companyDataList = List.from(dataResponse).map<CompanyData>((typeSingle) => CompanyData.fromMap(typeSingle)).toList();
     showToast("Data Loaded!  "  + dataResponse.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
    //  print(CompanyDataModel.companyDataList.toString() + ' -------    '  + dataResponse);
        
    }
    return dataResponse;
  }

  Future fetchMoreData() async {
    //var dataResponse = await getDataRequest("http://hmaapi.kilobytetech.com/users?pageNo=$page&size=20");
    // if(dataResponse==null)
    // {
      // List<CompanyData> companyNewList;
      // companyNewList = List.from(dataResponse).map<CompanyData>((typeSingle) => CompanyData.fromMap(typeSingle)).toList();
      // CompanyDataModel.companyDataList.addAll(companyNewList);
      if(hasmore)
      {
        if(isLoading) return;
        isLoading = true;
        sampleSize = sampleSize+10;
        // if(companyNewList.length<limit)
        // {
        //   hasmore = false;
        // }
        if(maxLimit<sampleSize)
        {
          hasmore = false;
        }
        await Future.delayed(Duration(milliseconds: 2000));
        setState(() {
          isLoading = false;
          showToast("Data Loaded!  ",Toast.LENGTH_LONG,Colors.green,Colors.white);
          page++;
        });
      }
      //  print(CompanyDataModel.companyDataList.toString() + ' -------    '  + dataResponse);
    // }
    // setState(() {
    //     showToast("Data Loaded!  "  + dataResponse.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
    //     page++;
    //   });
    // return dataResponse;
  }
}

class client_widget extends StatelessWidget {
  const client_widget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(.3), blurRadius: 20, offset: Offset(0,10))]
      ),
      margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CompanyDetailScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("#HMA4231", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w800),),
                    Spacer(),
                    Text("Created On : 10/08/2021", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w800),),
                  ],
                ),
                SizedBox(height: 10,),
                Text("SG Enterprises", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 15),),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Assigned Members : ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w800),),
                    Text("Prakhar Gupta"),
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