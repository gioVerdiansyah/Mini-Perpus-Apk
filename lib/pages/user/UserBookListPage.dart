import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_perpus_up/models/BookModel.dart';
import 'package:mini_perpus_up/pages/components/PaginationComponent.dart';

class UserBookListPage extends StatefulWidget{
  UserBookListPage({super.key});

  @override
  State<UserBookListPage> createState() => _UserBookListView();
}

class _UserBookListView extends State<UserBookListPage>{
  Uri? changeUrl;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder(
        future: BookModel.getBook(changeUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var data = snapshot.data['data'];

            void passingDownEvent(Uri url) {
              setState(() {
                changeUrl = url;
              });
            }

            return Column(
              children: [
                FadeInDown(
                  child: const Center(
                    child: Text("Buku buku kami", style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
                ((data['data'] == null) || data['data'].isEmpty)
                    ? const Center(
                  child: Text("Buku belum tersedia..."),
                )
                    : Container(
                  child: Expanded(
                      child: ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: data['data'].length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var book = data['data'][index];

                              return Card(
                                margin: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Judul: ${book['title']}"),
                                              Text("Category: ${book['category'] ?? '-'}"),
                                              Text("Penerbit: ${book['publisher'] ?? '-'}")
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          if (data['prev_page_url'] != null || data['next_page_url'] != null)
                            PaginationComponent(page: data, passingDownEvent: passingDownEvent)
                        ],
                      )),
                )
              ],
            );
          }
        },
      ),
    );
  }
}