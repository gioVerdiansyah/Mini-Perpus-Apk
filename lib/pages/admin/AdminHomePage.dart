import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_perpus_up/pages/lib/CurvedNavigationBar.dart';

class AdminHomePage extends StatelessWidget {
  final CurvedNavigationBarState? navState;

  AdminHomePage({required this.navState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  "Fitur Perpustakaan: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Column(
                    children: [
                      const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "1. Pelanggan",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                          )),
                      const Text("Pada pelanggan memiliki fitur untuk menambah, mengubah, dan menghapus pelanggan."),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            onPressed: () {
                              navState?.setPage(1);
                            },
                            style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 0, horizontal: 0))),
                            child: const Text(
                              "Halaman Pelanggan",
                            ),
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "2. Buku",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                          )),
                      const Text("Pada buku memiliki fitur untuk menambah, mengubah, dan menghapus buku."),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            onPressed: () {
                              navState?.setPage(2);
                            },
                            style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 0, horizontal: 0))),
                            child: const Text(
                              "Halaman Buku",
                            ),
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "3. Sewa",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                          )),
                      const Text("Pada halaman sewa memiliki fitur untuk sewa buku, masa sewa, dan denda jika lebih dari"
                          " 1 minggu"
                          "."),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            onPressed: () {
                              navState?.setPage(3);
                            },
                            style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 0, horizontal: 0))),
                            child: const Text(
                              "Halaman Sewa",
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
