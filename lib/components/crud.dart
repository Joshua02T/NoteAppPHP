import 'dart:convert';
import 'dart:io';
import "package:path/path.dart";
import 'package:http/http.dart' as http;

String _basicAuth = 'Basic ' + base64Encode(utf8.encode('josh:josh12345'));

Map<String, String> myheaders = {'authorization': _basicAuth};

class Crud {
  getRequest(String url) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print('Error code is ${response.statusCode}');
      }
    } catch (e) {
      print('Error catch $e');
    }
  }

  postRequest(String url, Map data) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: myheaders);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print('Error code is ${response.statusCode}');
      }
    } catch (e) {
      print('Error catch $e');
    }
  }

  postRequestWithFile(String url, Map data, File file) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      var length = await file.length();
      var stream = http.ByteStream(file.openRead());
      var multiPartFile = http.MultipartFile("imagename", stream, length,
          filename: basename(file.path));
      request.headers.addAll(myheaders);
      request.files.add(multiPartFile);
      data.forEach((key, value) {
        request.fields[key] = value;
      });
      var myrequest = await request.send();
      var response = await http.Response.fromStream(myrequest);

      // Log the response to debug
      print("Response status: ${myrequest.statusCode}");
      print("Response body: ${response.body}");

      if (myrequest.statusCode == 200) {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          print('JSON decode error: $e');
          return {
            "status": "error",
            "message": "Failed to parse response as JSON"
          };
        }
      } else {
        print('error ${myrequest.statusCode}');
        return {
          "status": "error",
          "message": "Request failed with status ${myrequest.statusCode}"
        };
      }
    } catch (e) {
      print('Request error: $e');
      return {
        "status": "error",
        "message": "An error occurred while sending the request"
      };
    }
  }
}
