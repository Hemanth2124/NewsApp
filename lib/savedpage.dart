import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/data.dart';
import 'package:my_flutter_app/detailscreen.dart';

class savedpage extends StatelessWidget {
  const savedpage({super.key});
  
  Future<List<Map<String,dynamic>>> fetchsavedarticles() async{
    try{
      final usercollection=FirebaseFirestore.instance.collection('articles');
      final docsnapshot=await usercollection.doc('saved articles').get();
      if(docsnapshot.exists){
        final List<dynamic> articles=docsnapshot.get('artilces')??[];
        return articles.cast<Map<String,dynamic>>();
      }
      return [];
    }
    catch(e){
      print('error fetch saved articles');
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String,dynamic>>>(
      future: fetchsavedarticles(), 
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(
            child:CircularProgressIndicator() ,
            );
        }
        else if(snapshot.hasError){
          return Center(
            child: Text('Error'),
          );
        }
        else if(snapshot.hasData && snapshot.data!.isNotEmpty){
          final savedarticles=snapshot.data!;
          return ListView.builder(
            itemCount: savedarticles.length,
            itemBuilder: (context,index){
              final article=savedarticles[index];
              return ListTile(
                leading: Image.network(article['urltoimage']??'',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                ),
                title: Text(article['title']),
                subtitle: Text(article['source']['name']),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => detailscreen(article: data[index]),
                      ),
                  );
                },
              );
            }
             );
        }
        else{
          return Center(
            child: Text('No Articles are Saved Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign:TextAlign.center,
            ),
          );
        }
      }
    );
  }
}

