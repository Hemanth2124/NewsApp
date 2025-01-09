import 'dart:convert';
import 'package:flutter/material.dart';
import 'data.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedindex=0; 
  
  dynamic pages=[homepage(),searchpage(),savedpage()];

  void itemtapped(int index){
    setState(()
    {
      selectedindex=index;
    });
  }
 

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
        title: Text("News App",
        style:TextStyle(
         color: Colors.grey,
         fontSize: 40,
         fontWeight:FontWeight.bold,
        ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[100],
        leading: IconButton(
          onPressed: (){},
          icon: Icon(Icons.menu)
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: (){
                  Navigator.of(context).push(
                    
                   MaterialPageRoute(builder: (context) => profilepage(),),
                  );
                },
                 icon: Icon(Icons.person),
              );
            }
          )
        ],
      ),
      body: pages[selectedindex],
      bottomNavigationBar:BottomNavigationBar(
         
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        currentIndex:selectedindex,
        onTap: itemtapped,
        items:[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",

          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.search),
            label: "search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "saved",
          ),
        ],
      ) ,
      ),
    );
  }
}
class homepage extends StatefulWidget{
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  void initState(){
    super.initState();
    fetching_api();
  }
  var currentcategory;

  Future fetchinfo (String endpoint,String category) async{
      final String url='https://newsapi.org/v2/$endpoint=$category&apiKey=3abdc8f43dac40a2a245fd2668686ba9';
      
    final response= await http.get(Uri.parse(url));
    final json=jsonDecode(response.body);
    setState(() {
      data=json['articles'];
    });
  
  }
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Container(
          height: 100,
          child: Row(
            
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection:Axis.horizontal ,
                    children: [
                       
                     Padding(
                      padding: EdgeInsets.all(20),
                       child: ElevatedButton(
                        onPressed: (){
                          currentcategory='general';
                          setState(() {
                            fetchinfo('everything?q','genral');
                          });
                        },
                         child: Text('    General    ',
                         style: TextStyle(
                          fontSize: 15,
                         fontWeight: FontWeight.bold),),

                         ),
                     ),
                      
                  
                     Padding(
                       padding: const EdgeInsets.all(20),
                       child: ElevatedButton(
                        onPressed: (){
                          currentcategory='bussiness';
                          setState(() {
                            fetchinfo('everything?q','bussiness');
                          });
                        },
                       child: Text('  Bussiness  ',
                         style: TextStyle(
                          fontSize: 15,
                         fontWeight: FontWeight.bold), ),
                       ),
                     ),

                     Padding(
                      padding: EdgeInsets.all(20),
                       child: ElevatedButton(
                        onPressed: (){
                          currentcategory='sports';
                          setState(() {
                            fetchinfo('everything?q','sports');
                          });
                        },
                       child: Text('     Sports     ',
                         style: TextStyle(
                          fontSize: 15,
                         fontWeight: FontWeight.bold),),
                       ),
                     ),
                     Padding(
                      padding: EdgeInsets.all(20),
                       child: ElevatedButton(
                        onPressed: (){
                          currentcategory='current affairs';
                          setState(() {
                            fetchinfo('everything?q','current affairs');
                          });
                        },
                       child: Text('Current Affairs',
                         style: TextStyle(
                          fontSize: 15,
                         fontWeight: FontWeight.bold),),
                       ),

                     ),

                     Padding(
                      padding: EdgeInsets.all(20),
                       child: ElevatedButton(
                       onPressed: (){
                        currentcategory='politics';
                          setState(() {
                            fetchinfo('everything?q','politics');
                          });
                       },
                       child: Text('    politics    ',
                         style: TextStyle(
                          fontSize: 15,
                         fontWeight: FontWeight.bold),),
                       ),
                     ),
                    ],
                  ),
                ),
              ],
              
            
          ),
        ),

      Expanded(
         child: ListView.builder(
               itemCount:data.length,
               itemBuilder:(context, index){
          if (data[index]['author'] == null ||
                    data[index]['source']['name'] == null ||
                    data[index]['title'] == null ||
                    data[index]['description'] == null ||
                    data[index]['url'] == null ||
                    data[index]['urlToImage'] == null ||
                    data[index]['content'] == null ||
                    data[index]['publishedAt'] == null||data[index]['urlToImage'].isEmpty) {
                  return SizedBox.shrink();
                }
          return Padding(
            padding: EdgeInsets.all(30),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => detailscreen(index: index),));
              },
              child: Container(
                child: Column(
                  children:[
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children:[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              data[index]['urlToImage'] ,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Text(
                              data[index]['source']['name'],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.symmetric(horizontal:8,vertical:20),
                      child: Text(
                        data[index]['title'],
                        style: TextStyle(
                          fontSize:20,
                          fontWeight:FontWeight.bold,
                        ),
                      ),
             
                    ),
                    Padding(
                      padding:EdgeInsets.symmetric(horizontal:10),
                       child: Column(
                        children:[
                          Text(
                            data[index]['author'],
                          ),
                          Text(
                            data[index]['publishedAt'],
                          ),
                        ],
                        
                       ),
                    ),
                  ],
                ),
              ),
            ) ,
          );
               } ,
               //)
               //]
              ),
      ),
      ],
       );

      
    
      
  }
  Future fetching_api() async{

  const url='https://newsapi.org/v2/top-headlines?country=us&apiKey=3abdc8f43dac40a2a245fd2668686ba9';
  final uri=Uri.parse(url);
  final response=await http.get(uri);
  final body=response.body;
  setState((){
     data=jsonDecode(body)['articles'];
  });
}
}
class detailscreen extends StatelessWidget{
  final int index;
  const detailscreen({super.key, required this.index});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text('News App',
        style: TextStyle(
          fontSize:30,
          fontWeight: FontWeight.bold,
        ),),
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        )
      ),
      body:Column(
        children:[
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
              child:Image.network(
                data[index]['urlToImage'],
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top:8,
              left:8,
              child: Text(
                data[index]['source']['name'],
                style:TextStyle(
                  fontSize:10,
                  color: Colors.black,
                ),
              ),
            ),
              ],
            ),
            
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              data[index]['title'],
              style: TextStyle(
                fontSize:30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding:EdgeInsets.all(20),
            child:Text(
              data[index]['description'],
              style:TextStyle(
                fontSize:10,
                color: Colors.black,
              ),
            ), 
          ),
          Padding(
            padding: EdgeInsets.all(20),

            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data[index]['author'],

                ),
                Text(
                  data[index]['publishedAt'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class searchpage extends StatelessWidget{
  const searchpage({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      child: TextField(
        decoration: InputDecoration(
          hintText: 'search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.red,
            ),
            
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
              onPressed: (){}, 
              icon:Icon(Icons.search),
              ),
          ),
        ),
        enabled: true,
      ),
    );
  }
}
class savedpage extends StatelessWidget{
  const savedpage({super.key});

  @override
  Widget build(BuildContext context){
    return Center(
      child: Text(
        'No Articles are saved yet,start now',
        style: TextStyle(
          fontSize:30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
class profilepage extends StatefulWidget{
  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  //const profilepage({super.key});
  String name="Hemanth";

  String bio="Flutter developer";

  String imageurl="";

  bool editing=false;

  final TextEditingController nameController=TextEditingController();

  final TextEditingController bioController=TextEditingController();

  final TextEditingController imageurlController=TextEditingController();

  @override
  void initState(){
    super.initState();
    nameController.text=name;
    bioController.text=bio;
    imageurlController.text=imageurl;
  }

  void toggleEditMode(){
    setState((){
      editing= !editing;
    });
  }

  void saveChanges(){
    
    setState((){
      name=nameController.text;
      bio=bioController.text;
      imageurl=imageurlController.text;
      editing=false;
    });
    
    
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        centerTitle: true,
        title: Text('Profile',
        style:TextStyle(
          fontSize:30,
          fontWeight: FontWeight.bold,
        ),),
        leading: IconButton( 
         icon: Icon(Icons.arrow_back),
         onPressed:(){
          Navigator.pop(context);
         },
         ),
      ),
      body:Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            if(!editing)...[
              GestureDetector(
                child:Column(
                  children: [
                  Text('Name: $name',
                  style:TextStyle(
                    fontSize: 20,
                  ) ,),
                  SizedBox(height: 8),
                  Text('Bio: $bio',
                  style:TextStyle(
                    fontSize:20,
                  ),),
                  SizedBox(height: 8),
                  imageurl.isNotEmpty?Image.network(imageurl):Text('No profile picture'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: toggleEditMode, 
                    child: Text('Edit profile'),),
                  ],
                ),
              ),
                ]
                else...[
                  GestureDetector(
                  child:Column(
                    children: [
                      TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'name',
                    ),
                    onSubmitted: (_)=> saveChanges(),
                  ),
                  TextField(
                    controller: bioController,
                    decoration: InputDecoration(
                      labelText:'Bio',
                    ),
                    onSubmitted: (_)=>saveChanges(),
                  ),
                  TextField(
                    controller: imageurlController,
                    decoration: InputDecoration(
                     labelText: 'profile picture url',
                    ),
                    onSubmitted: (_)=>saveChanges(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: saveChanges ,
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
