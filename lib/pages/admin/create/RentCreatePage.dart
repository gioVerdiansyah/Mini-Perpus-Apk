import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_perpus_up/env.dart';
import 'package:mini_perpus_up/models/RentModel.dart';
import 'package:mini_perpus_up/pages/components/AppBarComponent.dart';
import 'package:mini_perpus_up/routes/ApiRoute.dart';
import 'package:url_launcher/url_launcher.dart';

class RentCreatePage extends StatefulWidget {
  RentCreatePage({super.key, required this.refreshState, required this.data});
  static const String routeName = '/book/create';
  final _formKey = GlobalKey<FormBuilderState>();
  final Function refreshState;
  final Map<String, dynamic> data;

  @override
  State<RentCreatePage> createState() => _RentCreateView();
}

class _RentCreateView extends State<RentCreatePage> {
  int? denda;
  late String no_pelanggan;
  late String kode_buku;
  final TextEditingController tglPinjamdanPengembalian = TextEditingController();
  final TextEditingController jumlahBuku = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<dynamic> customers = widget.data['customer'];
    List<dynamic> books = widget.data['book'];

    void calcPrice() {
      setState(() {
        String tgl1 = DateFormat("yyyy-MM-dd")
            .parse(DateFormat("M/d/yyyy")
                .parse(tglPinjamdanPengembalian.text.split(' -'
                    ' ')[0])
                .toString())
            .toString();
        String tgl2 = DateFormat("yyyy-MM-dd")
            .parse(DateFormat("M/d/yyyy")
                .parse(tglPinjamdanPengembalian.text.split(' -'
                    ' ')[1])
                .toString())
            .toString();

        DateTime date1 = DateTime.parse(tgl1);
        DateTime date2 = DateTime.parse(tgl2);

        Duration difference = date2.difference(date1);
        int selisihHari = difference.inDays;

        if (selisihHari > 14) {
          denda = 10000 * int.parse(jumlahBuku.text);
        } else if (selisihHari > 7) {
          denda = 7000 * int.parse(jumlahBuku.text);
        } else {
          denda = 5000 * int.parse(jumlahBuku.text);
        }
      });
    }

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
                      "Tambah sewa",
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
                            child: FormBuilderDropdown(
                              name: "Customer Number",
                              items: customers
                                  .map((e) => DropdownMenuItem(
                                        value: e['number'],
                                        child: Text(e['name']),
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "No Pelanggan",
                                  hintStyle: TextStyle(color: Colors.grey[700])),
                              onChanged: (val) => {no_pelanggan = val.toString()},
                              validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                            )),
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)))),
                            child: FormBuilderDropdown(
                              name: "Book Number",
                              items: books
                                  .map((e) => DropdownMenuItem(
                                        value: e['code'],
                                        child: Text(e['title']),
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Kode Buku",
                                  hintStyle: TextStyle(color: Colors.grey[700])),
                              onChanged: (val) => {kode_buku = val.toString()},
                              validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                            )),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)))),
                          child: FormBuilderTextField(
                            name: "total",
                            controller: jumlahBuku,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Total Buku yangg dipinjam",
                                hintStyle: TextStyle(color: Colors.grey[700])),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(), FormBuilderValidators.integer()]),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)))),
                          child: FormBuilderDateRangePicker(
                            name: "date",
                            controller: tglPinjamdanPengembalian,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Tanggal pinjam dan pengembalian",
                                hintStyle: TextStyle(color: Colors.grey[700])),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                  child: Column(children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: IntrinsicWidth(
                                    child: TextButton(
                                        onPressed: () {
                                          widget._formKey.currentState?.fields['total']?.save();
                                          widget._formKey.currentState?.fields['date']?.save();

                                          var total = widget._formKey.currentState?.fields['total']?.validate() ?? false;
                                          var date = widget._formKey.currentState?.fields['date']?.validate() ?? false;

                                          if (total && date) {
                                            calcPrice();
                                          }
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                            const Color.fromRGBO(143, 148, 251, 1),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                          child: Center(
                                            child: Text(
                                              "Hitung biaya sewa",
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )),
                                  ),
                                )
                              ])),
                            ),
                            IntrinsicWidth(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (widget._formKey.currentState?.saveAndValidate() ?? false) {
                                    calcPrice();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("Processing "
                                          "Data"),
                                      backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                                    ));

                                    var response = await RentModel.storeRent(
                                        no_pelanggan,
                                        kode_buku,
                                        DateFormat("yyyy-MM-dd")
                                            .parse(DateFormat("M/d/yyyy")
                                                .parse(tglPinjamdanPengembalian.text.split(' -'
                                                    ' ')[0])
                                                .toString())
                                            .toString(),
                                        DateFormat("yyyy-MM-dd")
                                            .parse(DateFormat("M/d/yyyy")
                                                .parse(tglPinjamdanPengembalian.text.split(' -'
                                                    ' ')[1])
                                                .toString())
                                            .toString(),
                                        int.parse(jumlahBuku.text),
                                        denda!);

                                    if (response['meta']['success']) {
                                      ArtSweetAlert.show(
                                          context: context,
                                          barrierDismissible: false,
                                          artDialogArgs: ArtDialogArgs(
                                              title: "Berhasil menambah data sewa",
                                              text: "Apakah Anda ingin print?",
                                              type: ArtSweetAlertType.success,
                                              confirmButtonText: "Ya",
                                              cancelButtonText: "Tidak",
                                              showCancelBtn: true,
                                              onConfirm: () =>
                                                  {launchUrl(Uri.parse("${Env.APP_URL}print/rent/${response['data']}"))},
                                              onCancel: () =>
                                                  {Navigator.pop(context), widget.refreshState(ApiRoute.getRentRoute)}));
                                    } else {
                                      ArtSweetAlert.show(
                                          context: context,
                                          artDialogArgs: ArtDialogArgs(
                                            title: response['meta']['message'],
                                            text: response['data'] ?? "Ada kesalahan server",
                                            type: ArtSweetAlertType.danger,
                                          ));
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
                            )
                          ],
                        ),
                        if (denda != null)
                          Text(
                              "Biaya sewa adalah: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(denda).toString()}")
                      ],
                    ),
                  ),
                ),
              ],
            )),
      )),
    );
  }
}
