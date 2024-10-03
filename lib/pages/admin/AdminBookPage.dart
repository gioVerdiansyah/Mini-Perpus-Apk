import 'package:intl/intl.dart';
import 'package:aplikasi_perpustakaan/routes/ApiRoute.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:aplikasi_perpustakaan/env.dart';
import 'package:aplikasi_perpustakaan/models/BookModel.dart';
import 'package:aplikasi_perpustakaan/pages/admin/create/BookCreatePage.dart';
import 'package:aplikasi_perpustakaan/pages/admin/edit/BookEditPage.dart';
import 'package:aplikasi_perpustakaan/pages/components/PaginationComponent.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminBukuPage extends StatefulWidget {
  AdminBukuPage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController query = TextEditingController();

  @override
  State<AdminBukuPage> createState() => _AdminBukuView();
}

class _AdminBukuView extends State<AdminBukuPage> {
  Uri? changeUrl;
  String? value;
  @override
  Widget build(BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Expanded(
                    flex: 100,
                    child: Column(
                      children: [
                        FormBuilder(
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
                                    name: "book",
                                    controller: widget.query,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search Book",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    // Navigator.of(context, rootNavigator: true).pushNamed("/book/create");
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => BookCreatePage(refreshState:
                                    passingDownEvent),));
                                  },
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                      backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(43, 255, 149, 0.6)),
                                      foregroundColor: MaterialStateProperty.all(Colors.white),
                                  ),
                                  child: const Text(
                                    "Tambah Buku",
                                  )),
                            ),Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    launchUrl(Uri.parse("${Env.APP_URL}print/book"));
                                  },
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                      backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(248, 255, 54, 0.6)),
                                      foregroundColor: MaterialStateProperty.all(Colors.white),
                                  ),
                                  child: const Text(
                                    "Cetak semua Buku",
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ((data['data'] == null) || data['data'].isEmpty)
                    ? const Center(
                        child: Text("Buku belum tersedia..."),
                      )
                    : Container(
                        child: Expanded(
                          flex: 500,
                            child: ListView(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: data['data'].length,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var book = data['data'][index];
                                var i = index + 1;

                                return Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Judul: ${book['title']}"),
                                                    Text("Category: ${book['category'] ?? '-'}"),
                                                    Text("Penerbit: ${book['publisher'] ?? '-'}"),
                                                    Text("Dibuat: ${DateFormat("dd/MM/yyyy").format(DateTime.parse(book['created_at']))}")
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 10),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                        BookEditPage(bookID: book['id'], refreshState: passingDownEvent)));
                                                  },
                                                  child: const Text("Edit"),
                                                  style: ButtonStyle(
                                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5))),
                                                      backgroundColor: MaterialStateProperty.all(
                                                          const Color.fromRGBO(248, 255, 54, 0.6)),
                                                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  ArtSweetAlert.show(
                                                      context: context,
                                                      artDialogArgs: ArtDialogArgs(
                                                          title: "Apakah Anda yakin?",
                                                          text: "Untuk menghapus buku ${book['title']}?",
                                                          type: ArtSweetAlertType.warning,
                                                          showCancelBtn: true,
                                                          onConfirm: () async {
                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                              content: Text("Processing "
                                                                  "Data"),
                                                              backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                                                            ));

                                                            var response = await BookModel.deleteBook(book['id']);
                                                            if (response['meta']['success']) {
                                                              ArtSweetAlert.show(
                                                                  context: context,
                                                                  artDialogArgs: ArtDialogArgs(
                                                                      type: ArtSweetAlertType.success,
                                                                      title: "Berhasil!",
                                                                      text: response['meta']['message'],
                                                                      onConfirm: () {
                                                                        passingDownEvent(Uri.parse(data['path']));
                                                                      }));
                                                            } else {
                                                              ArtSweetAlert.show(
                                                                  context: context,
                                                                  artDialogArgs: ArtDialogArgs(
                                                                      type: ArtSweetAlertType.danger,
                                                                      title: "Ups, Something wrong!",
                                                                      text: response['meta']['message']));
                                                            }
                                                          }));
                                                },
                                                child: const Text("Hapus"),
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                    backgroundColor: MaterialStateProperty.all(
                                                        const Color.fromRGBO(255, 54, 54, 0.6)),
                                                    foregroundColor: MaterialStateProperty.all(Colors.white)),
                                              )
                                            ],
                                          ),
                                        )
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
