import 'package:animate_do/animate_do.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:aplikasi_perpustakaan/models/CustomerModel.dart';
import 'package:aplikasi_perpustakaan/pages/components/AppBarComponent.dart';
import 'package:aplikasi_perpustakaan/routes/ApiRoute.dart';

class CustomerEditPage extends StatefulWidget {
  CustomerEditPage({super.key, required this.refreshState, required this.customerID});
  static const String routeName = '/book/create';
  final _formKey = GlobalKey<FormBuilderState>();
  final Function refreshState;
  final String customerID;

  @override
  State<CustomerEditPage> createState() => _CustomerUpdateView();
}

class _CustomerUpdateView extends State<CustomerEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      body: Container(
          child: FormBuilder(
        key: widget._formKey,
        child: FutureBuilder(
          future: CustomerModel.showCustomer(widget.customerID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var data = snapshot.data['data'];
              final TextEditingController name = TextEditingController(text: data['name']);
              final TextEditingController address = TextEditingController(text: data['address']);
              late String gender = data['gender'];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    FadeInDown(
                        child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          "Ubah data pelanggan",
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
                                name: "name",
                                controller: name,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Nama Pelanggan",
                                    hintStyle: TextStyle(color: Colors.grey[700])),
                                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)))),
                              child: FormBuilderTextField(
                                name: "address",
                                controller: address,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Alamat Pelanggan",
                                    hintStyle: TextStyle(color: Colors.grey[700])),
                                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)))),
                                child: FormBuilderDropdown(
                                  name: "gender",
                                  initialValue: gender,
                                  items: ['-- Pilih Gender --', 'L', 'P']
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList(),
                                  onChanged: (val) => {gender = val.toString()},
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Jenis Kelamin",
                                      hintStyle: TextStyle(color: Colors.grey[700])),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.notEqual("-- Pilih Gender --")
                                  ]),
                                )),
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

                                      var response = await CustomerModel.updateCustomer(
                                          widget.customerID, name.text, address.text, gender);

                                      if (response['meta']['success']) {
                                        ArtSweetAlert.show(
                                            context: context,
                                            barrierDismissible: false,
                                            artDialogArgs: ArtDialogArgs(
                                                title: "Berhasil mengubah data pelanggan",
                                                text: response['meta']['message'],
                                                type: ArtSweetAlertType.success,
                                                onConfirm: () =>
                                                    {Navigator.pop(context), widget.refreshState(ApiRoute.getCustomerRoute)}));
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
              );
            }
          },
        ),
      )),
    );
  }
}
