
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';
import 'package:my_flutter_app/loginpage.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

final TextEditingController emailcontroller=TextEditingController();

  final TextEditingController passwordcontroller=TextEditingController();

  final TextEditingController namecontroller=TextEditingController();

  final TextEditingController biocontroller=TextEditingController();
  final TextEditingController controllername=TextEditingController();

Future<void> registeruser() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      print('User registered: ${credential.user?.email}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
      ),
      
      body:Column(
        children: [
          TextField(
            controller: emailcontroller,
              decoration: InputDecoration(
              border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(20)
              ),
              labelText: 'Email id',
              ),
          ),
          SizedBox(height:10),
          TextField(
            controller: passwordcontroller,
              decoration: InputDecoration(
              border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(20)
              ),
              labelText: 'Password',
              ),
          ),
          SizedBox(height:10),
          TextField(
            controller: namecontroller,
              decoration: InputDecoration(
              border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(20)
              ),
              labelText: 'Name',
              ),
          ),
          SizedBox(height:10),
          TextField(
            controller: biocontroller,
              decoration: InputDecoration(
              border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(20)
              ),
              labelText: 'Bio',
              ),
          ),
          SizedBox(height:10),
          ElevatedButton(
            child: Text('Create Account',
             style: TextStyle(
              fontWeight: FontWeight.bold,
             ),),
            onPressed: ()async{
              await registeruser();
              final firestore=FirebaseFirestore.instance;
              firestore.collection('profiledetails').doc('my-id').set(
                {'name': namecontroller.text,
                'bio': biocontroller.text,
                }
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(context) => loginpage(),)
                );
                 
            },

              )
        ],
      )

    );
    
  }
}
