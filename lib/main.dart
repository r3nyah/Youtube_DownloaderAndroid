import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtuber_downloader/Src/Controller/Provider.dart';
import 'package:youtuber_downloader/Src/Home/Home.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context){
        return DataProvider();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Youtube Downloader',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white
          ),
        ),
        home: const Home(),
      ),
    );
  }
}
