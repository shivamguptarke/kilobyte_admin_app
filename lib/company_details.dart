import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kilobyte_admin_app/data/company_data.dart';
import 'package:kilobyte_admin_app/data/company_documents.dart';
import 'package:kilobyte_admin_app/routes.dart';

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
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: companyDocumentsList.length,
                          itemBuilder: (context, index) => client_widget(companyDocuments: companyDocumentsList.elementAt(index),), 
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .75),
                        ),
                      ),
                    ) : Expanded(child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/folder.png", height: 200),
                        SizedBox(height: 50,),
                        Text("No Documents Uploaded", style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w800),),
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
          showToast("Data Loaded!  "  + companyDocumentsList.length.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
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
  final CompanyDocuments companyDocuments;
  const client_widget({
    Key? key, required this.companyDocuments,
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(5.0),
            //   child: _imageFile==null ? Image.asset("assets/images/no_pictures.png",height: 100,) : Image.file(File(_imageFile!.path),height: 100),
            // ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: widget.companyDocuments.folder.isEmpty ? 
                Image.asset("assets/images/no_pictures.png",height: 100,) 
                : Image.network(widget.companyDocuments.folder[0].preview,height: 100),
            ),
            Text(widget.companyDocuments.category, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 15),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.cloud_upload_fill)),
                IconButton(onPressed: (){
                  _pickImage();
                }, icon: Icon(Icons.edit,))
              ],
            )
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
}