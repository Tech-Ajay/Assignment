import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supertails/views/widgets/QText.dart';
import 'package:supertails/views/widgets/q_button.dart';

class QDialog {
  static Future<dynamic> show({
    required String title,
    required Widget content,
    String? confirmBtnText,
    Function()? onConfirm,
    bool enableCancel = true,
    Function()? oncancel,
    bool enableScroll = false,
    bool isMobile = false,
    required BuildContext context,
    List<Widget>? actions,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: enableScroll,
          title: title == ''
              ? null
              : Center(
                  child: QText(
                    text: title,
                    color: Colors.black,
                    fontSize: 25,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    isHeader: true,
                  ),
                ),
          contentPadding: EdgeInsets.all(20),
          content: content,
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.symmetric(vertical: 15),
          actions: actions ??
              [
                if (enableCancel)
                  QButton(
                    isMobile: isMobile,
                    onPress: () {
                      oncancel == null ? Get.back() : oncancel();
                    },
                    text: 'Cancel',
                  ),
                if (onConfirm != null)
                  QButton(
                    isMobile: isMobile,
                    onPress: onConfirm,
                    text: confirmBtnText ?? 'Confirm',
                    backgroundColor: Colors.red,
                  )
              ],
        );
      },
    );
  }
}
