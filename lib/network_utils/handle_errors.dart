import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../components/snackbar.dart';

void handleErrors(GlobalKey _scaffoldKey, res) {
  var body = json.decode(res.body);
  var message = 'An Error Occured (' +
      res.statusCode.toString() +
      '). Retry request later';
  if (res.statusCode == 422 && body['errors'] != null) {
    message = Map<String, dynamic>.from(body["errors"])
        .entries
        .map((e) => e.key + ":" + e.value[0])
        .toList()
        .join(", ");
  } else if ((body['error'] != null || body['message'] != null)) {
    message = body['error'] ?? body['message'];
  }
  showSnackbarMessage(
      message: message, scaffoldKey: _scaffoldKey, isError: true);
}
