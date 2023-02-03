import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class FancyInputConfig extends ChangeNotifier {
  dynamic? value;
  dynamic? selectionItem;
  File? file;
  String? error;
  bool? isRequired;
  String? fieldName;
  String? errorText;

  dynamic? validator;
  List<dynamic>? validators;

  IconData? icon;

  String? hintText;
  String? labelText;

  // TextEditingController? textEditingController;
  // String? errorsControllerTag;
  // String? errorText;

  // ValueChanged<String>? onChanged;

  TextEditingController textEditingController = new TextEditingController();

  String? image_path;
  bool? saveImage = false;

  bool showLabel;
  bool showCustomLabel;
  String switchActiveText;
  String switchInactiveText;

  /* TextEditingController get errorController =>
      TextEditingController(text: error);*/

  FancyInputConfig({
    this.value,
    this.error,
    this.isRequired = true,
    this.fieldName,
    this.selectionItem,
    this.errorText,
    this.validator,
    this.validators,
    this.icon,
    this.hintText,
    this.labelText,
    this.saveImage = false,
    this.showLabel = true,
    this.showCustomLabel = false,
    this.switchActiveText = "Yes",
    this.switchInactiveText = "No",
  });

  set setValue(dynamic value) {
    // print(value);
    /*print("hey..");
    print(value);
    if (value is AutocompleteItem) {
      value = value.id;
    }
    if (value is MappedListIterable) {
      print("hey");
      value = value.map((e) => (e) => e.id);
    }*/
    if (this.isRequired!) {
      if ("$value".length != 0) {
        this.value = value;
        this.error = null;
      } else {
        this.value = null;
        this.error = this.errorText;
      }
    } else {
      this.value = value;
    }
    // print(isValid);
    notifyListeners();
  }

  void onValueChanged(dynamic value) {
    // print(value);
    /*if (value is AutocompleteItem) {
      value = value.id;
    }
    if (value is List) {
      value = value.map((e) => (e) => e.id);
    }*/
    if (this.isRequired!) {
      if ("$value".length != 0) {
        this.value = value;
        this.error = null;
      } else {
        this.value = null;
        this.error = this.errorText;
      }
    } else {
      this.value = value;
    }
    // print(isValid);
    notifyListeners();
  }

  set setSelectionItem(dynamic value) {
    this.selectionItem = value;
    notifyListeners();
  }

  void onSelectionItemChanged(dynamic value) {
    this.selectionItem = value;
    notifyListeners();
  }

  set setFile(File value) {
    this.file = value;
    notifyListeners();
  }

  void onFileChange(File value) async {
    this.file = value;

    List<int> imageBytes = await value.readAsBytes();
    onValueChanged(base64Encode(imageBytes));
    notifyListeners();
  }

  void onImagePathChange(String value) {
    this.image_path = value;
    notifyListeners();
  }

  set setImagePath(String value) {
    this.image_path = value;
    notifyListeners();
  }

  bool get isValid {
    bool b = !isRequired! ? true : (value != null ? true : false);

    if (value != null) {
      if (value is List) {
        b = (value as List).length > 0;
      }
    }
    return b;
  }

  updateWith(
      {dynamic value,
      String? error,
      bool? isRequired,
      String? field_name,
      TextEditingController? field_controller}) {
    this.value = value ?? this.value;
    this.error = error ?? this.error;
    this.isRequired = isRequired ?? this.isRequired;
    this.fieldName = field_name ?? this.fieldName;
    this.textEditingController = field_controller ?? this.textEditingController;

    notifyListeners();
  }

  set setError(String value) {
    this.error = value;
    notifyListeners();
  }

  set setIsRequired(value) {
    this.isRequired = value;
    notifyListeners();
  }

  set setFieldName(String value) {
    this.fieldName = value;
    notifyListeners();
  }

  set setFieldController(TextEditingController value) {
    this.textEditingController = value;
    notifyListeners();
  }
}
