import 'package:flutter/material.dart';
import 'package:my_flutter_app/main.dart';
class loginpage extends StatefulWidget{
  @override
  State<loginpage> createState() => _loginpageState();
}
class _loginpageState extends State<loginpage> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home:Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login Page',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body:Center(
        child: Column(
          children: [
            ClipRRect(
              borderRadius:BorderRadius.circular(50),
              child:SizedBox(
                height:100,
                width:100, 
              ),
            ),
            SizedBox(height:16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email id',
              ),
            ),
            SizedBox(height:8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height:8),
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                        ),
                    );
                  },
                  child: Text('Sign in'),
                );
              }
            ),
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                  },
                  child: Text('Sign up'),
                );
              }
            ),
          ],
        ),
      ),
      ),
    );
  }
}

