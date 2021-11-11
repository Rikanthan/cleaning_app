import 'package:cleaning/Widgets/button.dart';
import 'package:cleaning/Widgets/text_input.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
              child: Container(
                height: 260,
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
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              ),
                            ),
                        ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top:260.0),
              child: Center(
                child: Column(
                  children: [
                    TextInput(
                      controller: _usernameController,
                      hideText: false, 
                      hintText: 'Username', 
                      iconData: Icons.person,
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
                        buttonText: "Log in", 
                        onPress: (){}
                        ),
                      TextButton(
                        onPressed: (){}, 
                        child: Text('Forgot your password?')
                        ),
                        InkWell(
                          child: Text(
                            "Don't have an account? Register now!"
                          ),
                        )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height - 100, right: width/2),
              child: Container(
                height: 260,
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