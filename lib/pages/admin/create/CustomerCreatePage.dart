import 'package:animate_do/animate_do.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_perpus_up/models/CustomerModel.dart';
import 'package:mini_perpus_up/pages/components/AppBarComponent.dart';
import 'package:mini_perpus_up/routes/ApiRoute.dart';

class CustomerCreatePage extends StatefulWidget {
  CustomerCreatePage({super.key, required this.refreshState});
  static const String routeName = '/book/create';
  final _formKey = GlobalKey<FormBuilderState>();
  final Function refreshState;

  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();

  @override
  State<CustomerCreatePage> createState() => _CustomerCreateView();
}

class _CustomerCreateView extends State<CustomerCreatePage> {
  late String gender;

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
                    "Tambah pelanggan baru",
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
                          controller: widget.name,
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
                          controller: widget.address,
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
                            items: ['-- Pilih Gender --', 'L', 'P']
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (val) => {
                              setState(() {
                                gender = val.toString();
                              })
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Jenis Kelamin",
                                hintStyle: TextStyle(color: Colors.grey[700])),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(), FormBuilderValidators.notEqual("-- Pilih Gender --")]),
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

                                var response =
                                    await CustomerModel.storeCustomer(widget.name.text, widget.address.text, gender);

                                if (response['meta']['success']) {
                                  ArtSweetAlert.show(
                                      context: context,
                                      barrierDismissible: false,
                                      artDialogArgs: ArtDialogArgs(
                                          title: "Berhasil menambah pelanggan baru",
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
        ),
      )),
    );
  }
}
