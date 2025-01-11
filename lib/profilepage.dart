import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class profilepage extends StatefulWidget {
  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  String name = "Hemanth";
  String bio = "Flutter developer";
  var imageurl = "";
  bool editing = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController imageurlController = TextEditingController();

Future<void> fetchProfileDetails() async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Get the document
    DocumentSnapshot documentSnapshot = await firestore.collection('profiledetails').doc('my-id').get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      // Extract the data
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      // Print or use the data
      String name = data['name'] ?? 'Unknown';
      String bio = data['bio'] ?? 'No bio available';
      print('Name: $name, Bio: $bio');
    } else {
      print('Document does not exist');
    }
  } catch (e) {
    print('Error fetching profile details: $e');
  }
}



  @override
  void initState() {
    super.initState();
    loadprofiledata();
  }

 Future<void> loadprofiledata() async {
  final firestore = FirebaseFirestore.instance;

  try {
    DocumentSnapshot documentSnapshot = await firestore.collection('profiledetails').doc('my-id').get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        name = data['name'] ?? 'Hemanth';
        bio = data['bio'] ?? 'Flutter developer';
        imageurl = data['imageurl'] ?? '';
      });
    } else {
      print('Document does not exist');
    }
  } catch (e) {
    print('Error loading profile data from Firestore: $e');
  }
}


  

  void toggleEditMode() {
    setState(() {
      editing = !editing;
    });
  }

  Future<void> saveToFirestore() async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('profiledetails').doc('my-id').set({
      'name': name,
      'bio': bio,
      'imageurl': imageurl,
    });
    print('Profile details saved to Firestore');
  } catch (e) {
    print('Error saving to Firestore: $e');
  }
}
Future<void> saveprofiledata() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('bio', bio);
    await prefs.setString('imageurl', imageurl);
  }
void saveChanges() {
    setState(() {
      name = nameController.text;
      bio = bioController.text;
      imageurl = imageurlController.text;
      editing = false;
    });
    saveprofiledata();
    saveToFirestore();
  }


  Future<void> googleLogout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }
    await FirebaseAuth.instance.signOut();
    print("User successfully logged out");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await googleLogout();
              var prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => loginpage(),
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 60),
            if (!editing) ...[
              GestureDetector(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: imageurl.isNotEmpty
                            ? Image.network(
                                imageurl,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('lib/images/medium.webp');
                                },
                              )
                            : Image.asset('lib/images/medium.webp'),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Name: $name',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Bio: $bio',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: toggleEditMode,
                      child: Text('Edit profile'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              GestureDetector(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      onSubmitted: (_) => saveChanges(),
                    ),
                    TextField(
                      controller: bioController,
                      decoration: InputDecoration(labelText: 'Bio'),
                      onSubmitted: (_) => saveChanges(),
                    ),
                    TextField(
                      controller: imageurlController,
                      decoration: InputDecoration(labelText: 'Profile picture URL'),
                      onSubmitted: (_) => saveChanges(),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: saveChanges,
                      child: Text('Save changes'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
