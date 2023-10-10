import 'package:banking_system/controllers/transactions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomInputDialog extends StatelessWidget {
  final String title;
  final TransactionsController controller;
  final TextEditingController textController;
  final String hintText;
  final String confirmButtonText;
  final String? errorMsg;
  final Function(String)? onConfirm;
  final Function(String)? onChanged;
  final Function()? confirmBtn;
  final Widget? extraFields;

  const CustomInputDialog({
    super.key,
    required this.title,
    required this.textController,
    required this.hintText,
    required this.confirmButtonText,
    required this.controller,
    this.errorMsg,
    this.extraFields,
    this.onConfirm,
    this.onChanged,
    this.confirmBtn,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: Text(title),
      content: GetBuilder<TransactionsController>(builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: onChanged,
              controller: textController,
              decoration: InputDecoration(
                  hintText: hintText, errorText: controller.errorMsg!.value),
            ),
            extraFields ?? const Text("")
          ],
        );
      }),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            textController.clear();
            controller.errorMsg!.value = "";
            controller.update();
            Get.back();
          },
        ),
        TextButton(
            onPressed: () async {
              await confirmBtn!();
              textController.clear();
            },
            child: Text(confirmButtonText)),
      ],
    );
  }

  static Future<void> show(
      {required BuildContext context,
      required String title,
      required TextEditingController textController,
      required TransactionsController controller,
      required String hintText,
      required String confirmButtonText,
      String? errorMsg,
      Function()? confirmBtn,
      Widget? extraFields}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomInputDialog(
          controller: controller,
          title: title,
          textController: textController,
          hintText: hintText,
          confirmButtonText: confirmButtonText,
          errorMsg: controller.errorMsg!.value,
          confirmBtn: confirmBtn,
          extraFields: extraFields,
        );
      },
    );
  }
}
