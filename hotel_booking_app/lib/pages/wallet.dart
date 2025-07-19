import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../services/constant.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import '../services/widget_support.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  TextEditingController moneycontroller = new TextEditingController();
  Map<String, dynamic>? paymentIntent;

  String? wallet, id;

  String getCurrentDateFormatted() {
    final now = DateTime.now();
    final day = DateFormat('dd').format(now);
    final month = DateFormat('MMM').format(now);
    return '$day\n$month';
  }

  getthesharedpref() async {
    wallet = await SharedpreferenceHelper().getUserWallet();
    id = await SharedpreferenceHelper().getUserId();
    transactionstream= await DatabaseMethods().getUserTransactions(id!);
    setState(() {});
  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  Stream? transactionstream;

  Widget allTransaction() {
    return StreamBuilder(
      stream: transactionstream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(

          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return  Container(
              width: MediaQuery.of(context).size.width/1.3,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.black,borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))
                    ),
                    child: Text(
                      ds["Date"],
                      textAlign: TextAlign.center,
                      style: AppWidget.boldwhitetextstyle(24.0),
                    ),
                  ),
                  const SizedBox(width: 50.0,),
                  Column(children: [
                    Text("Amount Added ", style: AppWidget.normaltextstyle(18.0),),
                    Text("\$"+ds["Amount"], style: AppWidget.headlinetextstyle(30.0),)
                  ],)
                ],
              ),
            );
          },
        )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("WALLET", style: AppWidget.headlinetextstyle(30.0))),
      ),
      body:
      wallet == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [
              const SizedBox(height: 10.0),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),

                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                        color: const Color(0xFFececf8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "images/wallet.png",
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 50.0),
                          Column(
                            children: [
                              Text(
                                "Your Wallet",
                                style: AppWidget.normaltextstyle(20.0),
                              ),
                              Text(
                                "\$" + wallet!,
                                style: AppWidget.headlinetextstyle(34.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      moneycontroller.text="50";
                      makePayment("50");
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "50",
                          style: AppWidget.boldwhitetextstyle(25.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30.0),
                  GestureDetector(
                    onTap: () {
                      moneycontroller.text="100";
                      makePayment("100");
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "100",
                          style: AppWidget.boldwhitetextstyle(25.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30.0),
                  GestureDetector(
                    onTap: () {
                      moneycontroller.text="200";
                      makePayment("200");
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "200",
                          style: AppWidget.boldwhitetextstyle(25.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  openBox();
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Add Money",
                      style: AppWidget.boldwhitetextstyle(20.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0,),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0,),
                      Text("Your transactions", style: AppWidget.headlinetextstyle(20.0),),
                      const SizedBox(height: 10.0,),
                      SizedBox(
                          height: MediaQuery.of(context).size.height/2.5,
                          child: allTransaction()),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Adnan',
        ),
      )
          .then((value) {});

      displayPaymentSheet(amount);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) async {
        int updatedamount = int.parse(wallet!) + int.parse(amount);
        await DatabaseMethods().updateWallet(id!, updatedamount.toString());
        await SharedpreferenceHelper().saveUserWallet(
          updatedamount.toString(),
        );
        await getthesharedpref();
        String currentdate= getCurrentDateFormatted();
        Map<String , dynamic> addTransaction={
          "Date": currentdate,
          "Amount": moneycontroller.text,
        };
        await DatabaseMethods().addUserTransaction(addTransaction, id!);
        setState(() {});

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder:
              (_) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    Text("Payment Successfull"),
                  ],
                ),
              ],
            ),
          ),
        );
        paymentIntent = null;
      })
          .onError((error, stackTrace) {
        print("Error is :---> $error $stackTrace");
      });
    } on StripeException catch (e) {
      print("Error is:---> $e");
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(content: Text("Cancelled")),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);

    return calculatedAmount.toString();
  }
  Future openBox() => showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.cancel),
                ),
                const SizedBox(width: 50.0),
                const Text(
                  "Add Money",
                  style: TextStyle(
                    color: Color(0xff008080),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text("Enter amount"),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: moneycontroller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Money",
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                makePayment(moneycontroller.text);
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
