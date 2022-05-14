import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/constants.dart';

class Network {
  final String _url = apiBaseUrl;

  getUrl(apiUrl){
    return apiUrl.toString().contains(RegExp(r'http(|s)\:')) ? apiUrl : _url + apiUrl;
  }

  authData(data, apiUrl) async {
    var fullUrl = getUrl(apiUrl);
    try {
      return await http.post(Uri.parse(fullUrl),
          body: jsonEncode(data), headers: _setHeaders());
    } catch (socketException) {
      print(socketException);
    }
  }

  getData(apiUrl) async {
    var fullUrl = getUrl(apiUrl);
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  postData(apiUrl, data) async {
    var fullUrl = getUrl(apiUrl);
    try {
      return await http.post(Uri.parse(fullUrl),
          body: jsonEncode(data), headers: _setHeaders());
    } catch (socketException) {
      print(socketException);
    }
  }

  uploadFile(apiUrl, key, filePath) async {
    var fullUrl = getUrl(apiUrl);
    var req = http.MultipartRequest('POST', Uri.parse(fullUrl));
    req.files.add(await http.MultipartFile.fromPath(key, filePath));
    req.headers.addAll(_setUploadHeaders());
    return await http.Response.fromStream(await req.send());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _setUploadHeaders() => {
        'Content-type': 'multipart/form-data',
        'Accept': 'application/json',
      };
}
