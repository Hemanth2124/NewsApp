
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_flutter_app/data.dart';
import 'package:my_flutter_app/detailscreen.dart';


class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  void initState() {
    super.initState();
    loading=true;
    fetching_api();
    fetchinfo('everything?q', 'general');
  }

  var currentcategory;
  var loading=true;
  Future fetchinfo(String endpoint, String category) async {
    final String url =
        'https://newsapi.org/v2/$endpoint=$category&apiKey=3abdc8f43dac40a2a245fd2668686ba9';

    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    if(mounted){
    setState(() {
      data = json['articles'];
      loading=false;
      
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          currentcategory = 'general';
                          setState(() {
                            fetchinfo('everything?q', 'general');
                          });
                        },
                        child: Text(
                          '    General    ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          currentcategory = 'bussiness';
                          setState(() {
                            fetchinfo('everything?q', 'bussiness');
                          });
                        },
                        child: Text(
                          '  Bussiness  ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          currentcategory = 'sports';
                          setState(() {
                            fetchinfo('everything?q', 'sports');
                          });
                        },
                        child: Text(
                          '     Sports     ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          currentcategory = 'Health';
                          setState(() {
                            fetchinfo('everything?q', 'Health');
                          });
                        },
                        child: Text(
                          '     Health     ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          currentcategory = 'Technology';
                          setState(() {
                            fetchinfo('everything?q', 'Technology');
                          });
                        },
                        child: Text(
                          'Technology',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
        loading?CircularProgressIndicator():
        Expanded(
          
          child:ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (data[index]['author'] == null ||
                  data[index]['source']['name'] == null ||
                  data[index]['title'] == null ||
                  data[index]['description'] == null ||
                  data[index]['url'] == null ||
                  data[index]['urlToImage'] == null ||
                  data[index]['content'] == null ||
                  data[index]['publishedAt'] == null ||
                  data[index]['urlToImage'].isEmpty) {
                return SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.all(30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => detailscreen(article:data[index]),
                        ));
                  },
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child:Image.network(
                                  data[index]['urlToImage'],
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.network(
        'https://www.counterpunch.org/wp-content/uploads/2024/12/flaglongview-scaled.jpeg', // Path to your default image in assets
        fit: BoxFit.fill,
        width: double.infinity,
      );
    },
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                          child: Text(
                            data[index]['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
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
                  ),
                ),
              );
            },
            //)
            //]
          ),
        ),
      ],
    );
  }

  Future fetching_api() async {
    const url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=3abdc8f43dac40a2a245fd2668686ba9';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
  final jsondata=jsonDecode(body);
  if(jsondata['articles'] != null){
    if(mounted){}
    setState(() {
      data=jsondata['articles'];
      loading=false;
    });
  }
  else{
    setState(() {
      data=[];
    });
  }
  }
}