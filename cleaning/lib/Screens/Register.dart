import 'package:cleaning/Screens/Login.dart';
import 'package:cleaning/Widgets/button.dart';
import 'package:cleaning/Widgets/text_input.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
    final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              left: width/10,
              child: Container(
                height: 150,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(250.0),
                        bottomRight: Radius.circular(10.0)),
                    gradient: LinearGradient(
                        colors: [Colors.black,Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                          )
                        ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:50.0),
              child: Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                    ),
                  ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top:130.0),
              child: Center(
                child: Column(
                  children: [
                    TextInput(
                      controller: _usernameController,
                      hideText: false, 
                      hintText: 'Name', 
                      iconData: Icons.person,
                      inputAction: TextInputAction.next,
                      ),
                      TextInput(
                      controller: _usernameController,
                      hideText: false, 
                      hintText: 'Phone', 
                      iconData: Icons.phone_android,
                      inputAction: TextInputAction.next,
                      ),
                      TextInput(
                      controller: _usernameController,
                      hideText: false, 
                      hintText: 'Address', 
                      iconData: Icons.location_city,
                      inputAction: TextInputAction.next,
                      ),
                    TextInput(
                      controller: _usernameController,
                      hideText: false, 
                      hintText: 'Email', 
                      iconData: Icons.email_sharp,
                      inputAction: TextInputAction.next,
                      ),
                      TextInput(
                      controller: _passwordController,
                      hideText: true, 
                      hintText: 'Password', 
                      iconData: Icons.lock,
                      inputAction: TextInputAction.go,
                      ),
                      CustomButton(
                        buttonText: "Register", 
                        onPress: (){
                          Navigator.push(
                            context,
                             MaterialPageRoute(
                               builder: (_)=> Login()
                               )
                              );
                        }
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height - 70, right: width/1.25),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(250.0)),
                    gradient: LinearGradient(
                        colors: [Colors.black,Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}