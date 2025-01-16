import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signupage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'loggedin.dart';

class loginpage extends StatefulWidget {
  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
   final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    loaduser();
  }

  Future<void> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  
  final user = FirebaseAuth.instance.currentUser;

  if (isLoggedIn && user != null) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
      }
    });
  
  } else {
    
    await saveLoginState(false);
  }
}

  Future<void> saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> signInUser() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print('User signed in: ${credential.user?.email}');

      await saveLoginState(true);

      if(mounted){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
      );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      print(e);
    }
  }

    Future<User?> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? guser = await GoogleSignIn().signIn();
      if (guser == null) {
        return null;
      }
      
      final GoogleSignInAuthentication gauth = await guser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gauth.accessToken,
        idToken: gauth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          centerTitle: true,
          title: Text(
            'Login Page',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    'lib/images/medium.webp',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Email id',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await signInUser();
                },
                child: Text(
                  'Sign in',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      User? user = await _signInWithGoogle(context);
                      if (user != null) {
                        var pref = await SharedPreferences.getInstance();
                        await pref.setBool('isLoggedIn', true);
                      } else {
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Google Sign-In failed. Please try again.')),
                        );
                      }
                    },
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }
              ),

              
              SizedBox(height:8),
              Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyWidget(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
  Future loaduser() async {
    var prefs = await SharedPreferences.getInstance();
    if(mounted){
    setState(() {
      save.loggedinusername = prefs.getString('loggedinusername') ?? "";
    });
  }
  }
}
