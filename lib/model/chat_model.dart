import 'dart:convert';

class ChatModel {
  String author;
  String message;

  String attachment;
  String url;

  ChatModel({
    this.author = "",
    this.message = "",
    this.attachment = "",
    this.url = "",
  });

  ChatModel.fromJson(Map json)
      : author = (json['author'] != null) ? json['author'] : "",
        message = (json['message'] != null) ? json['message'] : "",
        attachment = (json['attachment'] != null) ? json['attachment'] : "",
        url = (json['url'] != null) ? json['url'] : "";

  Map<String, dynamic> toJson() {
    return {
      "author": (author == null) ? "" : author,
      "message": (message == null) ? "" : message,
      "attachment": (attachment == null) ? "" : attachment,
      "url": (url == null) ? "" : url,
    };
  }
}
