import 'package:banking_system/database_helper.dart';
import 'package:banking_system/modules/transactions_module.dart';
import 'package:banking_system/modules/users_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionsController extends GetxController {
  RxList<User> usersList = <User>[].obs;
  RxList<Transactions> transactionsList = <Transactions>[].obs;
  RxString? errorMsg = "".obs;
  final DatabaseHelper _db = DatabaseHelper();
  final User _currentUser = User(
      firstName: "Test",
      lastName: "User",
      userBalance: 9000,
      userId: 23,
      phoneNumber: "144920232");

  User get currentUser => _currentUser;

  @override
  onInit() async {
    usersList.value = User.fromJsonList(await _db.getUsers());
    transactionsList.value = Transactions.fromJsonList(
        await _db.getTransactions(currentUser.userId!));
    update();
    super.onInit();
  }

  Future<void> transactionProcess(String receiverName, String amountTransfering,
      [int? index]) async {
    double? amountToTransfer = double.tryParse(amountTransfering);
    if (amountToTransfer == null || amountToTransfer <= 0) {
      errorMsg!.value = "Enter a valid amount !";
      update();
    } else if (currentUser.userBalance < amountToTransfer) {
      errorMsg!.value = "Insufficient amount !";
      update();
    } else if (!(currentUser.userBalance < amountToTransfer)) {
      var timeNow = formattedDateTime();
      await _db.updateUsersBalance(usersList[index!].userId!,
          (usersList[index].userBalance + amountToTransfer));
      await _db.addTransaction(
          currentUser.userId!,
          usersList[index].userId!,
          currentUser.firstName,
          usersList[index].firstName,
          amountToTransfer,
          timeNow);
      errorMsg!.value = "";
      usersList[index].userBalance =
          await _db.getNewBalance(usersList[index].userId!);
      addTransactionToHistory(index, amountToTransfer, timeNow);
      currentUser.userBalance = currentUser.userBalance - amountToTransfer;
      update();
      Get.back();
      Get.snackbar("Transaction", "",
          messageText: const Text(
            "Successfully Transfered",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: Colors.deepPurpleAccent,
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.money));
    }
  }

  void addTransactionToHistory(
      int index, double amountTransfered, String transactionTime) {
    transactionsList.add(Transactions(
        senderId: currentUser.userId!,
        receiverId: usersList[index].userId!,
        transactionDate: transactionTime,
        senderName: currentUser.firstName,
        receiverName:
            "${usersList[index].firstName} ${usersList[index].lastName}",
        amount: amountTransfered));
    update();
  }

  Future<void> transferFromHome(
      String amountTransfered, String phoneNumber) async {
    try {
      User transferingToUser = await _db.getUserFromNum(phoneNumber);
      await transactionProcess(transferingToUser.firstName, amountTransfered,
          transferingToUser.userId! - 1);
    } catch (e) {
      if (amountTransfered == "" || phoneNumber == "") {
        errorMsg!.value = "Field can't be empty !";
        update();
      } else {
        errorMsg!.value = "User not found !";
        update();
      }
    }
  }

  String formattedDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(now).toString();
  }
}
