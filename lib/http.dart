import 'package:http/http.dart' as http;

/*
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

main(List<String> arguments) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  //var url = "https://www.googleapis.com/books/v1/volumes?q={http}";
  var url = "https://www.cpp.edu/~alumni";
  // Await the http get response, then decode the json-formatted responce.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var itemCount = jsonResponse['totalItems'];
    print("Number of books about http: $itemCount.");
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
}*/
import 'package:http/http.dart' as http;
main(List<String> arguments) async {
  var url = 'https://www.cpp.edu/~alumni/';
  var response = await http.post(
      url, body: {'name': 'doodle', 'color': 'blue'});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  print(await http.read('https://www.cpp.edu/~alumni/'));
}