import 'package:banking_system/controllers/transactions_controller.dart';
import 'package:banking_system/widgets/show_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AllCustomers extends StatefulWidget {
  const AllCustomers({super.key});
  @override
  State<AllCustomers> createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  TextEditingController transferAmount = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[700],
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent[700],
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          "Customers",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: GetBuilder<TransactionsController>(builder: (controller) {
        return ListView.builder(
            itemCount: controller.usersList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: screenWidth,
                height: screenHeight * 0.145,
                child: Card(
                  color: Colors.deepPurpleAccent[400],
                  elevation: 15,
                  borderOnForeground: true,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            " ${controller.usersList[index].firstName} ${controller.usersList[index].lastName}",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                                letterSpacing: 2,
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () async {
                                await CustomInputDialog.show(
                                  controller:
                                      Get.find<TransactionsController>(),
                                  context: context,
                                  title: "Transaction",
                                  textController: transferAmount,
                                  hintText: "Amount to transfer",
                                  confirmButtonText: "Confirm",
                                  errorMsg:
                                      controller.transactionErrorMsg?.value,
                                  confirmBtn: () async {
                                    if (await controller.transactionProcess(
                                            "${controller.usersList[index].firstName} ${controller.usersList[index].lastName}",
                                            transferAmount.value.text,
                                            index) ==
                                        "Successed") {
                                      transferAmount.clear();
                                    }
                                  },
                                );
                              },
                              iconSize: 50,
                              color: Colors.white,
                              icon: const Icon(Icons.arrow_upward))
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Phone Number : ${controller.usersList[index].phoneNumber}",
                            style: GoogleFonts.poppins(
                              letterSpacing: 2,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Balance : ${controller.usersList[index].userBalance} \$",
                            style: GoogleFonts.poppins(
                              letterSpacing: 2,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
