import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kilobyte_admin_app/routes.dart';

class CompanyDetailScreen extends StatefulWidget {
  const CompanyDetailScreen({ Key? key }) : super(key: key);

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {

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
        else if(snapshot.error!=null || snapshot.hasData)
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
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(CupertinoIcons.back)),
                        SizedBox(width: 10,),
                        Text("Company Documents", style: TextStyle(fontSize: 20, letterSpacing: 2),),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: 15,
                          itemBuilder: (context, index) => client_widget(), 
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .75),
                        ),
                      ),
                    ),
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
    var dataResponse = await getDataRequest("http://hmaapi.kilobytetech.com/documents?clientId=5f60e62502392e786fa4ae95&financialYear=2020-2021",);
    if(dataResponse!=null)
    {
     log("Data Loaded!  "  + dataResponse.toString());
      //ServiceTypeDataModel.serviceTypeDataList = List.from(dataResponse).map<ServiceTypeData>((typeSingle) => ServiceTypeData.fromMap(typeSingle)).toList();
    //  print(AllCategoryDataModel.AllCategoryDataList.toString() + ' -------    '  + AllCategoryDataModel.AllCategoryDataList[0].category.toString());
        //showToast("Data Loaded!  "  + ServiceTypeDataModel.serviceTypeDataList.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
    }
    return dataResponse;
  }
}

class client_widget extends StatefulWidget {
  const client_widget({
    Key? key,
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
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(.2), blurRadius: 20, offset: Offset(0,10))]
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: _imageFile==null ? Image.asset("assets/images/no_pictures.png",height: 100,) : Image.file(File(_imageFile!.path),height: 100),
            ),
            Text("TDS DOCUMENT", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 15),),
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