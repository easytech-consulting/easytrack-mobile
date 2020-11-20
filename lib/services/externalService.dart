import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void launchURL({String url}) {
  launch(url);
}

void launchMail(String email) {
  launch('mailto:$email');
}

void launchCall(String phone) {
  launch('tel://$phone');
}

void launchWhatsApp({
  @required String phone,
  @required String message,
}) async {
  String url() {
    if (Platform.isIOS) {
      return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
    }
  }

  await launch(url());
}
