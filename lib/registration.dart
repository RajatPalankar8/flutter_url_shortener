import 'package:flutter/material.dart';
import 'package:flutter_node_url_shortener/login.dart';
import 'package:get/get.dart';
class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  TextEditingController tecName = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPass = TextEditingController();
  final _getConnect = GetConnect();

  void _registerUser(name,email,pass) async{
    if(name.isEmpty || email.isEmpty || pass.isEmpty){
      print("Please Enter Data");
      Get.snackbar("Please Enter Details","");
    }else{
      print('${name}  ${email}  ${pass}');

      final response = await _getConnect.post('http://192.168.29.239:3000/userRegistration', {
          'name':name,
          'email':email,
          'password':pass
      });
      print(response.body['status']);
      if(response.body['status']){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
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
                  const Text("Registration Page"),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 2),
                    child: TextField(
                      controller: tecName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Full Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
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
                      print(tecName.text);
                      _registerUser(tecName.text,tecEmail.text,tecPass.text);
                    },
                    child: Text("REGISTER"),
                  ),),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                    },
                    child: Text("LOGIN"),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
