import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  
  final getStorage = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final textLongUrl = TextEditingController();
  final _getConnect = GetConnect();
  final dio = Dio();
  void submitURL(longUrl) async{

    Map<String,dynamic> userData = getStorage.read('user');
    String userId = userData['_id'];
    if(_formKey.currentState!.validate()){
      final response = await _getConnect.post('http://192.168.29.239:3000/urlSubmit', {
        'userId':userId,
        'longUrl':longUrl
      });
      print(response.body['status']);
      await Clipboard.setData(ClipboardData(text: response.body['success']['shorturl']));
      Get.snackbar(

        "Hello",
        "Display the message here",
        snackPosition: SnackPosition.BOTTOM
      );
      setState(() {

      });
    }
  }

  List<Map<String, dynamic>> dataList = [];



  Future<void> fetchUserSubmitUrl(userId) async{
    final response = await _getConnect.post('http://192.168.29.239:3000/getUserURL', {
      'userId':userId
    });
    final List<dynamic> data = response.body['success'];

    setState(() {
      dataList = List<Map<String,dynamic>>.from((data));
    });

    print(data);
  }

  Future<void> redirect(shortId) async{
    final response = await _getConnect.get('http://192.168.29.239:3000/${shortId}');

    final responseBody = response.body;
    final decodedData = json.decode(responseBody);

// Handle the decoded data as needed
    print(decodedData);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String,dynamic> userData = getStorage.read('user');
    String userId = userData['_id'];
    // fetchUserSubmitUrl(userId);
    fetchUserSubmitUrl(userId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  const Text("* URL SHORTENER *",style: TextStyle(fontSize: 30),),
                  const Text("Long URL to Short URL"),
                  SizedBox(height: 10,),
                  Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: textLongUrl,
                          decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Long URL",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return " Please Enter long Url";
                            }
                            return null;
                          }
                        ),
                      ),
                      SizedBox(width: 10), // Add some spacing between TextField and Button
                      ElevatedButton(
                        onPressed: () {
                          submitURL(textLongUrl.text.toString());
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
                  SizedBox(height: 10,),
                  dataList.isEmpty ? CircularProgressIndicator():  Expanded(
                    child: Container(
                      child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context,index){
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 6,horizontal: 16) ,
                              child: ListTile(
                                subtitle: Text(dataList[index]['longUrl']),
                                title: Text('http://pcp.com/${dataList[index]['shorturl']}'),
                                onTap: (){
                                  redirect('${dataList[index]['shorturl']}');
                                  print(' Item Clicked: ${dataList[index]['shorturl']}');
                                },
                              ),
                            );
                         }),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
