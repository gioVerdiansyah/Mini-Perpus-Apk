import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:aplikasi_perpustakaan/routes/ApiRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_perpustakaan/models/BookModel.dart';
import 'package:aplikasi_perpustakaan/pages/components/PaginationComponent.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class UserBookListPage extends StatefulWidget{
  UserBookListPage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController query = TextEditingController();

  @override
  State<UserBookListPage> createState() => _UserBookListView();
}

class _UserBookListView extends State<UserBookListPage>{
  Uri? changeUrl;
  String? value;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder(
        future: BookModel.getBook(changeUrl, value),
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: FormBuilder(
                        key: widget._formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 20,
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)))),
                              child: FormBuilderTextField(
                                name: "rent",
                                controller: widget.query,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search Rent",
                                    hintStyle: TextStyle(color: Colors.grey[700])),
                                // validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    changeUrl = ApiRoute.getBookRoute;
                                    value = widget.query.text;
                                  });
                                },
                                child: Icon(Icons.search))
                          ],
                        )),
                  ),
                ),
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
                                              Text("Penerbit: ${book['publisher'] ?? '-'}"),
                                              Text("Dibuat: ${DateFormat("dd/MM/yyyy").format(DateTime.parse(book['created_at']))}")
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