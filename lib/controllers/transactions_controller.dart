import 'package:banking_system/database_helper.dart';
import 'package:banking_system/modules/transactions_module.dart';
import 'package:banking_system/modules/users_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionsController extends GetxController {
  List<User> usersList = [];
  List<Transactions> transactionsList = [];
  RxString? errorMsg = "".obs;
  final DatabaseHelper _db = DatabaseHelper();
  final User _currentUser =
      User(firstName: "Test", lastName: "User", userBalance: 9000, userId: 23);

  User get currentUser => _currentUser;

  @override
  onInit() async {
    usersList = User.fromJsonList(await _db.getUsers());
    transactionsList = Transactions.fromJsonList(
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
          snackPosition: SnackPosition.BOTTOM,
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
        receiverName: usersList[index].firstName,
        amount: amountTransfered));
    update();
  }

  String formattedDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(now).toString();
  }
}
