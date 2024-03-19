import "package:http/http.dart" as http;

Future GetData(url) async {
  http.Response Response = await http.get(url);
  return Response.body;
}
