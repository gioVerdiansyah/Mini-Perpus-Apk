import 'package:animate_do/animate_do.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:aplikasi_perpustakaan/models/BookModel.dart';
import 'package:aplikasi_perpustakaan/pages/components/AppBarComponent.dart';
import 'package:aplikasi_perpustakaan/routes/ApiRoute.dart';

class BookEditPage extends StatefulWidget {
  BookEditPage({super.key, required this.bookID, required this.refreshState});
  static const String routeName = '/book/edit';
  final String bookID;
  final _formKey = GlobalKey<FormBuilderState>();
  final Function refreshState;

  @override
  State<BookEditPage> createState() => _BookEditView();
}

class _BookEditView extends State<BookEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      body: Container(
          child: FormBuilder(
        key: widget._formKey,
        child: FutureBuilder(
          future: BookModel.showBook(widget.bookID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var data = snapshot.data['data'];
              final TextEditingController title = TextEditingController(text: data['title']);
              final TextEditingController category = TextEditingController(text: data['category']);
              final TextEditingController publisher = TextEditingController(text: data['publisher']);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    FadeInDown(
                        child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          "Tambah buku baru",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    )),
                    Card(
                      margin: EdgeInsets.all(15),
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)))),
                              child: FormBuilderTextField(
                                name: "title",
                                controller: title,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Judul Buku",
                                    hintStyle: TextStyle(color: Colors.grey[700])),
                                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)))),
                              child: FormBuilderTextField(
                                name: "category",
                                controller: category,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Kategori Buku",
                                    hintStyle: TextStyle(color: Colors.grey[700])),
                                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)))),
                              child: FormBuilderTextField(
                                name: "publisher",
                                controller: publisher,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Penerbit Buku",
                                    hintStyle: TextStyle(color: Colors.grey[700])),
                                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IntrinsicWidth(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Processing "
                                            "Data"),
                                        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                                      ));

                                      var response = await BookModel.updateBook(widget.bookID,title.text, category.text,
                                          publisher
                                          .text);

                                      if (response['meta']['success']) {
                                        ArtSweetAlert.show(
                                            context: context,
                                            barrierDismissible: false,
                                            artDialogArgs: ArtDialogArgs(
                                                title: "Berhasil mengubah buku",
                                                text: response['meta']['message'],
                                                type: ArtSweetAlertType.success,
                                                onConfirm: () => {
                                                  Navigator.pop(context),
                                                  widget.refreshState(ApiRoute.getBookRoute)
                                                }));
                                      } else {
                                        ArtSweetAlert.show(
                                            context: context,
                                            artDialogArgs: ArtDialogArgs(
                                              title: response['meta']['message'],
                                              text: response['data'] ?? "Ada kesalahan server",
                                              type: ArtSweetAlertType.danger,
                                            ));
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(248, 255, 54, 0.6)),
                                      foregroundColor: MaterialStateProperty.all(Colors.white),
                                    ),
                                    child: const Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [Text('Simpan'), Icon(Icons.send)],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      )),
    );
  }
}
