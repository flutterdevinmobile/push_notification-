import 'package:flutter/material.dart';
import 'login_required_bottom_sheet_ui.dart'; // alohida UI faylni import qilamiz

class LoginRequiredBottomSheet {
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return const LoginRequiredBottomSheetUI();
      },
    );
  }
}
