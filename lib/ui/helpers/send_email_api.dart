import 'package:login/ui/models/user.model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void sendEmail(
    String dataUrl, List<UserModel> contacts, UserModel loogedInUser) async {
  const String serviceId = "service_sebytpd";
  const String templateId = "template_583t674";
  const String userId = "Ib608vBVutD0JIl3c";
  const String userSubject = "ALERTA DE SEGURIDAD";
  const String userName = "";
  String userMessage =
      "¡${loogedInUser.firstName} ${loogedInUser.secondName} se encuentra en riesgo! Ha generado una alerta de seguridad. A continuación se encuentra la información adjunta como evidencia.";

  String userEmails = getEmails(contacts);
  const String replyTo = "";

  //Ib608vBVutD0JIl3c
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

  final response = await http
      .post(url,
          headers: {
            "origin": "http://localhost",
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            "user_id": userId,
            "template_params": {
              'user_name': userName,
              'to_email': userEmails,
              "reply_to": replyTo,
              'user_subject': userSubject,
              "user_message": userMessage,
              "user_url": dataUrl
            }
          }))
      .then((res) => {print("${res.statusCode} -------------")});
}

String getEmails(List<UserModel> contacts) {
  String emails = "";
  for (var i = 0; i < contacts.length; i++) {
    emails = emails + contacts[i].email!;
    if (contacts[i] != contacts.last) {
      emails = emails + ", ";
    }
  }
  return emails;
}
