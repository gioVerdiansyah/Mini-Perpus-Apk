import 'package:animate_do/animate_do.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_perpus_up/models/BookModel.dart';
import 'package:mini_perpus_up/pages/components/AppBarComponent.dart';
import 'package:mini_perpus_up/routes/ApiRoute.dart';

class BookCreatePage extends StatefulWidget {
  BookCreatePage({super.key, required this.refreshState});
  static const String routeName = '/book/create';
  final _formKey = GlobalKey<FormBuilderState>();
  final Function refreshState;

  final TextEditingController title = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController publisher = TextEditingController();

  @override
  State<BookCreatePage> createState() => _BookCreateView();
}

class _BookCreateView extends State<BookCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      body: Container(
          child: FormBuilder(
        key: widget._formKey,
        child: Padding(
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
                          controller: widget.title,
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
                          controller: widget.category,
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
                          controller: widget.publisher,
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
                                if(widget._formKey.currentState?.saveAndValidate() ?? false) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Processing "
                                        "Data"),
                                    backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                                  ));

                                  var response = await BookModel.storeBook(
                                      widget.title.text, widget.category.text, widget.publisher.text);

                                  if (response['meta']['success']) {
                                    ArtSweetAlert.show(
                                        context: context,
                                        barrierDismissible: false,
                                        artDialogArgs: ArtDialogArgs(
                                            title: "Berhasil menyimpan buku",
                                            text: response['meta']['message'],
                                            type: ArtSweetAlertType.success,
                                            onConfirm: () =>
                                            {
                                              Navigator.pop(context),
                                              widget.refreshState(ApiRoute.getCustomerRoute)
                                            }));
                                  } else {
                                    ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          title: response['meta']['message'],
                                          text: response['data'] ?? "Ada kesalahan server",
                                          type: ArtSweetAlertType.danger,));
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(43, 255, 149, 0.6)),
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
        ),
      )),
    );
  }
}
