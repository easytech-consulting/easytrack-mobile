import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.date,
  });

  int id;
  int senderId;
  int receiverId;
  String message;
  String date;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        date: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "created_at": date,
      };
}
