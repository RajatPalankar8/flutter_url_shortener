import 'package:flutter/material.dart';
import 'package:flutter_node_url_shortener/login.dart';
import 'package:flutter_node_url_shortener/welcome.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   final userdate = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     userdate.writeIfNull('user', false);

    Future.delayed(Duration(seconds: 2),() async{
      checkiflogged();
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void checkiflogged(){

    if(userdate.read('user').toString().isNotEmpty ||userdate.read('user') ){
      Get.offAll(()=>WelcomePage());
    }else{
      Get.offAll(()=>Login());
    }
  }
}






