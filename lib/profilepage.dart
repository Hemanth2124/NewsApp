import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profilepage extends StatefulWidget {
  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  //const profilepage({super.key});
  String name = "Hemanth";

  String bio = "Flutter developer";

  var imageurl="";
  

  bool editing = false;

  final TextEditingController nameController = TextEditingController();

  final TextEditingController bioController = TextEditingController();

  final TextEditingController imageurlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadprofiledata();
  }
  Future loadprofiledata() async{
    final prefs=await SharedPreferences.getInstance();
    setState(() {
      name=prefs.getString('name')??"Hemanth";
      bio=prefs.getString('bio')??"Flutter developer";
      imageurl=prefs.getString('imageurl')??"";
      nameController.text=name;
      bioController.text=bio;
      imageurlController.text=imageurl;
    });
  }
  Future saveprofiledata() async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('bio', bio);
    await prefs.setString('imageurl', imageurl);
  }
  void toggleEditMode() {
    setState(() {
      editing = !editing;
    });
  }

  void saveChanges() {
    setState(() {
      name = nameController.text;
      bio = bioController.text;
      imageurl = imageurlController.text;
      editing = false;
    });
    saveprofiledata();
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
      ),
      body: Center(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height:60),
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
                              fit: BoxFit.fill,
                                imageurl,
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
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Bio: $bio',
                      style: TextStyle(
                        fontSize: 20,
                      ),
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
                      decoration: InputDecoration(
                        labelText: 'name',
                      ),
                      onSubmitted: (_) => saveChanges(),
                    ),
                    TextField(
                      controller: bioController,
                      decoration: InputDecoration(
                        labelText: 'Bio',
                      ),
                      onSubmitted: (_) => saveChanges(),
                    ),
                    TextField(
                      controller: imageurlController,
                      decoration: InputDecoration(
                        labelText: 'profile picture url',
                      ),
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
