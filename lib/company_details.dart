import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kilobyte_admin_app/data/company_data.dart';
import 'package:kilobyte_admin_app/data/company_documents.dart';
import 'package:kilobyte_admin_app/routes.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CompanyDetailScreen extends StatefulWidget {
  final CompanyData companyData;
  const CompanyDetailScreen({ Key? key, required this.companyData }) : super(key: key);

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  String financialYearValue = '';
  List<String> financialYearList = ['2018-2019', '2019-2020', '2020-2021', '2021-2022'];
  List<CompanyDocuments> companyDocumentsList=[];

  @override
  void initState() {
    // TODO: implement initState
    financialYearValue = financialYearList[0];
    super.initState();
  }

  reloadOnUpdate(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

      return FutureBuilder(
      future: loadClientsData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState!=ConnectionState.done)
        {
          return Material(child: Center(child: CircularProgressIndicator()));
        }
        else if(snapshot.error != null || !snapshot.hasData)
        {
          return Container(
            child: SafeArea(
              child: Material(child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/error.png", height: 200),
                  SizedBox(height: 30,),
                  Text("Network Connection Failed !"),
                  SizedBox(height: 30,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.purple ),
                    onPressed: ()=> setState(() {
                    //loadServiceData();
                  }), child: Text("RETRY AGAIN", style: TextStyle(color: Colors.white),))
                ],
              ))),
            ),
          );
        }
        else{
          return Scaffold(
            body: SafeArea(
              child: Container(
                color: Colors.white10,
                child : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(.3), blurRadius: 20, offset: Offset(0,10))]
                      ),
                      child: Row(
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(CupertinoIcons.back)),
                          SizedBox(width: 10,),
                          Expanded(child: Text(widget.companyData.companyName, style: TextStyle(fontSize: 20, letterSpacing: 2),)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white
                                ),
                                hint: financialYearValue == '' ? Text('Select Financial Year'): 
                                Text(
                                  financialYearValue,
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
                                ),
                                items: financialYearList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (val) => setState(() => financialYearValue = val.toString(),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    companyDocumentsList.isNotEmpty ?
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: companyDocumentsList.length,
                          itemBuilder: (context, index) => client_widget(
                            companyDocuments: companyDocumentsList.elementAt(index),
                            reloadOnUpdate: reloadOnUpdate,
                          ), 
                          //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .75),
                        ),
                      ),
                    ) : Expanded(child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/folder.png", height: 200),
                        SizedBox(height: 50,),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text("No documents uploaded for financial year $financialYearValue",textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w800),),
                        ),
                      ],
                    ))),
                  ]
                )
              )
            )
          );
        }
      }
    );
  }

  Future? loadClientsData() async {
    log("--------- pass data------" + widget.companyData.id);
    if(widget.companyData.id.isNotEmpty)
    {
      var dataResponse = await getDataRequest("http://hmaapi.kilobytetech.com/documents?clientId=${widget.companyData.id}&financialYear=$financialYearValue",);
      if(dataResponse!=null)
      {
        try{
      //log("Data Loaded!  "  + dataResponse.toString());
          companyDocumentsList = List.from(dataResponse['records']).map<CompanyDocuments>((documentSingle) => CompanyDocuments.fromMap(documentSingle)).toList();
      //  print(AllCategoryDataModel.AllCategoryDataList.toString() + ' -------    '  + AllCategoryDataModel.AllCategoryDataList[0].category.toString());
          //showToast("Data Loaded!  "  + companyDocumentsList.length.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
        }catch (e){
          log(e.toString());
        }
        return dataResponse;
      }
      return null;
    }
    return null;
  }
}

class client_widget extends StatefulWidget {
  final Function reloadOnUpdate;
  final CompanyDocuments companyDocuments;
  const client_widget({
    Key? key, required this.companyDocuments, required this.reloadOnUpdate,
  }) : super(key: key);

  @override
  State<client_widget> createState() => _client_widgetState();
}


class _client_widgetState extends State<client_widget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(.2), blurRadius: 20, offset: Offset(0,10))]
      ),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(5.0),
            //   child: _imageFile==null ? Image.asset("assets/images/no_pictures.png",height: 100,) : Image.file(File(_imageFile!.path),height: 100),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: widget.companyDocuments.folder.isEmpty ? 
                  Image.asset("assets/images/file.png" ,height: 50,) 
                  : Image.network(widget.companyDocuments.folder[0].preview),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.companyDocuments.category, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 15),),
                    Text(widget.companyDocuments.type, style: TextStyle(color: Colors.blue),),
                    Text(DateFormat('MMMM').format(DateTime(0, widget.companyDocuments.month + 1)).toString().toUpperCase(), style: TextStyle(color: Colors.black),),
                  ],
                ),
              ),
            ),
            IconButton(onPressed: (){
              Alert(
                context: context,
                type: AlertType.success,
                title: "Upload File",
                desc: "Are you sure you want to Upload this file?",
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
                      await uploadFile();
                      Navigator.pop(context);
                      widget.reloadOnUpdate();
                    },
                    color: Colors.blue,
                  )
                ],
              ).show();
            }, icon: Icon(CupertinoIcons.cloud_upload_fill)),
            IconButton(onPressed: (){
              _pickImage();
            }, icon: Icon(Icons.edit,))
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print("Image picker error " + e.toString());
    }
  }

  Future? uploadFile() async {
    log("--------- pass data------" + widget.companyDocuments.id);
    if(widget.companyDocuments.id.isNotEmpty)
    {
      var dataResponse = await putDataRequest(
        context,
        "http://hmaapi.kilobytetech.com/documents/${widget.companyDocuments.id}", 
        {
          "folder": [
              {
                  "file": "https://hma-docs.s3.ap-south-1.amazonaws.com/6646b710-4e27-4728-9053-1d2103d3704f.pdf",
                  "preview": "https://hma-docs.s3.ap-south-1.amazonaws.com/7af73066-3818-4866-bb56-ae475b59fcb0.png"
              }
          ],
          "status": "COMPLETED"
        }
      );
      if(dataResponse!=null)
      {
        try{
          if(dataResponse.statusCode==200)
          {  
            var decodedData = jsonDecode(dataResponse.body);  
            showToast(decodedData['message'], Toast.LENGTH_SHORT, Colors.green, Colors.white);
          }else{
            var decodedData = jsonDecode(dataResponse.body);
            showToast(decodedData['message'], Toast.LENGTH_SHORT, Colors.green, Colors.white);
          }
          //showToast("Data Loaded!  "  + dataResponse.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
        }catch (e){
          log(e.toString());
        }
        return dataResponse;
      }else{
        showToast("Request failed. Try Again Later!",Toast.LENGTH_LONG,Colors.red,Colors.white);
      }
      return null;
    }
    return null;
  }
}