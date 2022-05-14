import 'package:flutter/material.dart';

showSnackbarMessage(
    {message = "",
      scaffoldKey,
      isError: false,
      noAction: true,
      color: Colors.green}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: isError ? Colors.red : color,
    action: noAction
        ? null
        : SnackBarAction(
      label: 'Close',
      onPressed: () {
        // Some code to undo the change!
      },
    ),
  );
  scaffoldKey.currentState.showSnackBar(snackBar);
}
