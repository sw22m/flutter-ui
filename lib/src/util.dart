import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// This function is used to update the page title
void setPageTitle(String title, BuildContext context) {
  SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
    label: "Pyuscope | $title",
    primaryColor: Theme.of(context).primaryColor.value, // This line is required
  ));
}