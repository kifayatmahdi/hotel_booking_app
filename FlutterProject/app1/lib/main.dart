import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        darkTheme: ThemeData(primarySwatch: Colors.blue),
        color: Colors.blueGrey,
        debugShowCheckedModeBanner: false,
        home: HomeActivity(),
    );
  }
  
}

class HomeActivity extends StatelessWidget{
  const HomeActivity({super.key});

  MySnackBar(message, context){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory App"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white70,
        titleSpacing: 10,
        centerTitle: false,
        toolbarHeight: 60,
        toolbarOpacity: 0.8,
        elevation: 10,
        actions: [
          IconButton(onPressed: (){MySnackBar('You have pressed comment button', context);}, icon: Icon(Icons.comment)),
          IconButton(onPressed: (){MySnackBar('You have pressed email button', context);}, icon: Icon(Icons.email)),
          IconButton(onPressed: (){MySnackBar('You have pressed search button', context);}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){MySnackBar('You have pressed settings button', context);}, icon: Icon(Icons.settings)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: (){
          MySnackBar('You have pressed floating action button', context);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        fixedColor: Colors.green,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label:'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label:'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label:'Contacts'),
        ],
        onTap: (int index){
          if(index==0){
            MySnackBar('You have pressed home bottom menu', context);
          }
          if(index==1){
            MySnackBar('You have pressed message bottom menu', context);
          }
          if(index==2){
            MySnackBar('You have pressed contact bottom menu', context);
          }
        },
      ),

      body: Text("Hello"),
    );
  }
  
}