import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_perpus_up/models/CustomerModel.dart';
import 'package:mini_perpus_up/pages/admin/create/CustomerCreatePage.dart';
import 'package:mini_perpus_up/pages/admin/edit/CustomerEditPage.dart';
import 'package:mini_perpus_up/pages/components/PaginationComponent.dart';

class AdminPelangganPage extends StatefulWidget{
  AdminPelangganPage({super.key});

  @override
  State<AdminPelangganPage> createState() => _AdminPelangganView();
}

class _AdminPelangganView extends State<AdminPelangganPage>{
  Uri? changeUrl;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder(
        future: CustomerModel.getCustomer(changeUrl),
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                      onPressed: () async {
                        // Navigator.of(context, rootNavigator: true).pushNamed("/Customer/create");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerCreatePage(refreshState:
                        passingDownEvent),));
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(43, 255, 149, 0.6)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text(
                        "Tambah Pelanggan",
                      )),
                ),
                ((data['data'] == null) || data['data'].isEmpty)
                    ? const Center(
                  child: Text("Belum ada data pelanggan..."),
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
                              var customer = data['data'][index];
                              var i = index + 1;

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
                                              Text("Nama: ${customer['name']}"),
                                              Text("Jenis Kelamin: ${customer['gender'] ?? '-'}"),
                                              Text("Alamat: ${customer['address'] ?? '-'}")
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                    CustomerEditPage(customerID: customer['id'], refreshState:
                                                    passingDownEvent)));
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
                                                      text: "Untuk menghapus pelanggan ${customer['name']}?",
                                                      type: ArtSweetAlertType.warning,
                                                      showCancelBtn: true,
                                                      onConfirm: () async {
                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                          content: Text("Processing "
                                                              "Data"),
                                                          backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                                                        ));

                                                        var response = await CustomerModel.deleteCustomer(customer['id']);
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
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                backgroundColor: MaterialStateProperty.all(
                                                    const Color.fromRGBO(255, 54, 54, 0.6)),
                                                foregroundColor: MaterialStateProperty.all(Colors.white)),
                                            child: const Text("Hapus"),
                                          )
                                        ],
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