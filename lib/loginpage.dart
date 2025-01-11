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
      debugShowCheckedModeBanner: false,
      home:Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        centerTitle: true,
        title: Text('Login Page',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body:Center(
        child: Column(
          children: [
            SizedBox(height:30),
            ClipRRect(
              borderRadius:BorderRadius.circular(50),
              child:SizedBox(
                height:100,
                width:100,
                child: Image.asset(
                  'lib/images/medium.webp',
                  fit: BoxFit.fill,
                ), 
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
            SizedBox(height:10),
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
                  child: Text('Sign in',
                  style:TextStyle(
                    fontWeight: FontWeight.bold
                  )),
                );
              }
            ),
            SizedBox(height:10),
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
                  child: Text('Sign up',
                  style:TextStyle(
                    fontWeight: FontWeight.bold
                  )),
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

