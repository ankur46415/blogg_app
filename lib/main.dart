import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'ListData.dart';
import 'ListDetailScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late List<dynamic> products;
  late List<ListData> blogList = [];
  bool _isLoading=true; //bool variabl

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if(_isLoading){
      fetchBlogs().whenComplete(() => {
        // Fluttertoast.showToast(
        //     msg: "${blogList.length}",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     textColor: Colors.white,
        //     fontSize: 16.0
        // ),
        setState(() {})
      });
    }

    return MaterialApp(
      title: 'Blog list screen',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Blog list screen'),
        ),
        body: !_isLoading? ListView.builder(
          itemCount: blogList.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
              child: Container(
                  margin: EdgeInsets.all(4.0),
                  padding: EdgeInsets.all(8.0),
                  decoration:BoxDecoration(
                      borderRadius:BorderRadius.circular(8),
                      color:Colors.white
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(5.0),
                        child: Text(
                          "${blogList[index].id}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(color:Colors.green,fontSize:15),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10,bottom: 15,left: 5,right: 5),
                        child: Image.network("${blogList[index].imageUrl}"),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(5.0),
                        child: Text(
                          "${blogList[index].title}",
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: const TextStyle(color:Colors.black,fontSize:16),
                        ),
                      ),
                    ],
                  )),
              onPressed: () {
                //   navigate to another screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ListDetailScreen(blogList[index],const Key("data"))),
                );
              },
            );
          },
        ): const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // Future<List<dynamic>> fetchUsers() async {
  //   var result = await http.get(Uri.parse("https://randomuser.me/api/?results=20"));
  //   products = jsonDecode(result.body)['results'];
  //   return products;
  // }

  Future<List<ListData>> fetchBlogs() async {
    blogList = [];
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';
    print('fetchBlogs');
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        // Request successful, handle the response data here
        _isLoading = false;
        List<dynamic> list = jsonDecode(response.body)['blogs'];
        list.forEach((element) {
          blogList.add(ListData.fromJson(element));
        });
        print('Response data: ${response.body}');
      } else {
        // Request failed
        print('Request failed with status code: ${response.statusCode}');
        print('Response data: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('FetchBlogs Error: $e');
    }

    return blogList;
  }

}