import 'package:flutter/material.dart';
import 'package:flutter_node_url_shortener/welcome.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final getStorage = GetStorage();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPass = TextEditingController();

  final _getConnect = GetConnect();
  void login(email, pass) async{
    if(email.isEmpty || pass.isEmpty){
      print("Please Enter Data");
    }else{
      final response = await _getConnect.post('http://192.168.29.239:3000/userLogin', {
        'email':email,
        'password':pass
      });
      print(response.body['status']);
      if(response.body['status']){
        getStorage.write("user", response.body['success']);
        Get.offAll(WelcomePage());
      }else{
        print(response.body);
      }
    }



  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                const Text("* URL SHORTENER *",style: TextStyle(fontSize: 30),),
                const Text("Login Page"),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 2),
                  child: TextField(
                    controller: tecEmail,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 2),
                  child: TextField(
                    controller: tecPass,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
                Padding(padding: EdgeInsets.all(20),child:
                ElevatedButton(
                  onPressed: () {
                    print(tecEmail.text);
                    print(tecPass.text);
                    login(tecEmail.text, tecPass.text);
                  },
                  child: Text("LOGIN"),
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
