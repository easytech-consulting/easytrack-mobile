import 'package:url_launcher/url_launcher.dart';

void launchNDA() {
  launch('http://google.com');
}

void launchMail(String email) {
  launch('mailto:$email');
}

void launchCall(String phone) {
  launch('tel://$phone');
}
