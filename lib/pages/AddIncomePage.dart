import 'package:mycashbook/helper/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddIncomePage extends StatefulWidget {
  AddIncomePage({Key? key}) : super(key: key);

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final DbHelper dbHelper = DbHelper();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void resetForm() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    amountController.clear();
    descriptionController.clear();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tambah Pemasukan"),
          backgroundColor: Color.fromARGB(255, 231, 140, 2),
        ),
        backgroundColor: Color.fromARGB(255, 240, 243, 192),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                decoration: InputDecoration(
                  labelText: "Tanggal",
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(255, 146, 84, 4)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 146, 84, 4))),
                ),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Nominal",
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(255, 146, 84, 4)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 146, 84, 4))),
                ),  
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Keterangan",
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(255, 146, 84, 4)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 146, 84, 4))),
                ),
              ),
              SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0)))),
                      onPressed: () {
                        resetForm();
                      },
                      child: const Text("Reset"),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 238, 216, 95)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0)))),
                      onPressed: () async {
                        String date = dateController.text;
                        String amount = amountController.text;
                        String description = descriptionController.text;

                        if (date.isNotEmpty && amount.isNotEmpty) {
                          int rowCount = await dbHelper.insertIncome(
                              date, amount, description);
                          if (rowCount > 0) {
                            // Successfully added income data
                            resetForm(); // Reset the form
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Pemasukan berhasil disimpan."),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Gagal menyimpan pemasukan."),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Tanggal dan Jumlah harus diisi."),
                            ),
                          );
                        }
                      },
                      child: const Text("Simpan"),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Kembali ke halaman Beranda
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0)))),
                      child: const Text("Kembali"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
