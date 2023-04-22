import 'package:flutter/material.dart';

prettyPrint(String? msg, {String? type}) {
  debugPrint(" [] ==  [${type ?? PrettyPrinterTypes.debug}] => $msg ");
}



class PrettyPrinterTypes {
  static const error = "ERROR";
  static const debug = "DEBUG";
  static const warning = "WARNING";
}
