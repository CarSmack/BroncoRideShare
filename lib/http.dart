import 'package:http/http.dart' as http;

import 'package:http/http.dart' as http;
main(List<String> arguments) async {
  var url = 'https://www.cpp.edu/~alumni/';
  var response = await http.post(
      url, body: {'name': 'doodle', 'color': 'blue'});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  print(await http.read('https://www.cpp.edu/~alumni/'));
}