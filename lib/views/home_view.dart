import 'package:banking_system/controllers/transactions_controller.dart';
import 'package:banking_system/widgets/show_dialogue.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TransactionsController _transactionsController =
      Get.put(TransactionsController());
  final TextEditingController amountTransfer = TextEditingController();
  final TextEditingController userPhoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepPurpleAccent[700],
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.07,
        title: Text(
            _transactionsController.currentUser.firstName +
                _transactionsController.currentUser.lastName,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.deepPurpleAccent[700],
        titleSpacing: 0,
        leadingWidth: 50,
        leading: IconButton(
          iconSize: 30,
          style: const ButtonStyle(
              elevation: MaterialStatePropertyAll(40),
              backgroundColor: MaterialStatePropertyAll(Colors.black)),
          autofocus: true,
          icon: const Icon(
            Icons.person_rounded,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Home",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // First Data Card
          SizedBox(
            height: screenHeight * 0.18,
            width: screenWidth * 0.8,
            child: Card(
              color: Colors.deepPurpleAccent[400],
              borderOnForeground: true,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Balance",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "Customers");
                          },
                          style: TextButton.styleFrom(
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.deepPurpleAccent[400],
                              elevation: 10,
                              shadowColor: Colors.black),
                          child: Text(
                            "View Customers",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: GetBuilder<TransactionsController>(
                          builder: (controller) {
                            return Text(
                              "${controller.currentUser.userBalance}\$",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              softWrap: false,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.06),
                        child: SizedBox(
                            width: screenWidth * 0.39,
                            height: screenHeight * 0.045,
                            child: TextButton(
                                onPressed: () async {
                                  CustomInputDialog.show(
                                      context: context,
                                      title: "Transaction",
                                      textController: amountTransfer,
                                      hintText: "Amount to Transfer",
                                      confirmButtonText: "Confirm",
                                      confirmBtn: () async {
                                        await _transactionsController
                                            .transferFromHome(
                                                amountTransfer.value.text,
                                                userPhoneNumber.value.text);
                                      },
                                      extraFieldController: userPhoneNumber,
                                      extraFields:
                                          GetBuilder<TransactionsController>(
                                              builder: (context) {
                                        return TextField(
                                          keyboardType: TextInputType.number,
                                          controller: userPhoneNumber,
                                          decoration: InputDecoration(
                                              hintText: "Phone Number",
                                              errorText: _transactionsController
                                                  .errorMsg!.value),
                                        );
                                      }),
                                      errorMsg: _transactionsController
                                          .errorMsg!.value,
                                      controller:
                                          Get.find<TransactionsController>());
                                },
                                style: TextButton.styleFrom(
                                    alignment: Alignment.topCenter,
                                    fixedSize: const Size(150, 40),
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        Colors.deepPurpleAccent[400],
                                    elevation: 15),
                                child: Text(
                                  "Transfer",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ))),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          // Second Data card
          SizedBox(
            height: screenHeight * 0.23,
            width: screenWidth * 0.8,
            child: Card(
                color: Colors.redAccent,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: screenHeight * 0.03,
                              right: screenWidth * 0.3),
                          alignment: Alignment.topLeft,
                          transformAlignment: Alignment.topLeft,
                          height: 50,
                          width: 70,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Colors.white, Color(0xFFE0E0E0)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomLeft,
                                  stops: [0.5, 0.9]),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Text(
                          "Bank",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "1234 4232 2345 4322",
                      style: GoogleFonts.poppins(
                          letterSpacing: 2, fontSize: 25, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "${_transactionsController.currentUser.firstName} ${_transactionsController.currentUser.lastName}",
                          style: GoogleFonts.poppins(
                              letterSpacing: 1,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          Align(
            alignment: Alignment.center,
            child: Text("Transactions history",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          SizedBox(
            height: screenHeight * 0.3,
            child: GetBuilder<TransactionsController>(builder: (controller) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.transactionsList.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: TextField(
                          enabled: false,
                          controller: TextEditingController(text: " "),
                          decoration: InputDecoration(
                            suffixText:
                                "${controller.transactionsList[(controller.transactionsList.length - 1) - index].amount} \$",
                            prefix: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      controller
                                          .transactionsList[(controller
                                                      .transactionsList.length -
                                                  1) -
                                              index]
                                          .receiverName,
                                      style: GoogleFonts.poppins(
                                          letterSpacing: 2,
                                          fontSize: 15,
                                          color: Colors.white)),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                    ),
                                    height: 1.5,
                                    width: 150,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                      controller.transactionsList[index]
                                          .transactionDate,
                                      style: GoogleFonts.poppins(
                                          letterSpacing: 2,
                                          fontSize: 13,
                                          color: Colors.grey))
                                ]),
                            suffixStyle: GoogleFonts.poppins(
                                fontSize: 25, color: Colors.white),
                          )));
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
