import 'package:hive_ce/hive.dart';

part 'request_model.g.dart';

@HiveType(typeId: 0)
class Request {
  Request({
    required this.title,
    required this.method,
    required this.path,
    required this.body,
    required this.headers,
    required this.auth,
    this.response,
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  String method;

  @HiveField(2)
  String path;

  @HiveField(3)
  Map<String, dynamic> body;

  @HiveField(4)
  Map<String, String> headers;

  @HiveField(5)
  Map<String, String> auth;

  @HiveField(6)
  String? response;

  Request.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        method = json['method'],
        path = json['path'],
        body = json['body'],
        headers = json['headers'],
        auth = json['auth'],
        response = json['response'];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'method': method,
      'path': path,
      'body': body,
      'headers': headers,
      'auth': auth,
      'response': response
    };
  }
}
