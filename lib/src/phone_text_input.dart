import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

import 'fancy_inputs_config.dart';

class FancyPhoneTextInput extends StatelessWidget {
  dynamic validator;

  IconData? icon;

  String? hintText;
  String? labelText;
  TextEditingController? textController;
  TextInputType? keyboardType;
  String? errorsControllerTag;

  bool disabled = false;

  int maxLength;
  bool maxLengthEnforced;

  int minLines;
  ValueChanged<String>? onChanged;
  String? errorText;
  FancyInputConfig? config;
  void Function()? trigger;
  Color? hintColor;
  Color? textColor;
  FancyPhoneTextInput({
    Key? key,
    this.validator,
    this.icon,
    this.hintText,
    this.labelText,
    this.textController,
    this.keyboardType,
    this.errorsControllerTag,
    this.disabled = false,
    this.maxLength = 9,
    this.maxLengthEnforced = true,
    this.onChanged,
    this.errorText,
    this.minLines = 1,
    this.config,
    this.trigger,
    this.hintColor = Colors.grey,
    this.textColor = Colors.black,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        if (config!.showLabel)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              config!.labelText!,
              style: TextStyle(),
            ),
          ),
        if (config!.showLabel)
          SizedBox(
            height: 5,
          ),
        TextFormField(
          autocorrect: true,
          autofocus: false,
          enabled: !disabled,
          controller: config!.textEditingController,
          keyboardType: TextInputType.phone,
          maxLength: maxLength,
          minLines: minLines,
          maxLines: minLines,
          // maxLengthEnforced: maxLengthEnforced,
          style: TextStyle(color: textColor, fontSize: 15.5),
          onChanged: (value) {
            /*if (errorsControllerTag != null) {
                MyTextInputErrorController c =
                    Get.find<MyTextInputErrorController>(
                        tag: errorsControllerTag);
                c.errors.value = "";
              }*/

            if (config != null) {
              if (value.startsWith("0") && value.length > 5) {
                value = value.replaceFirst("0", "");
                config!.textEditingController.text = value;
                config!.textEditingController.selection =
                    TextSelection.fromPosition(TextPosition(
                  offset: config!.textEditingController.text.length,
                ));
              }

              if (value.startsWith("0")) {
                config!.onValueChanged(value);
              } else {
                if (value.length > 0) {
                  config!.onValueChanged("0${value}");
                } else {
                  config!.onValueChanged(null);
                }
              }
            }

            if (trigger != null) {
              trigger!();
            }
          },
          decoration: InputDecoration(
            fillColor: Colors.grey.shade200,
            filled: true,
            labelStyle: TextStyle(
              color: textColor,
            ),
            hintStyle: TextStyle(
              color: hintColor,
            ),
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 5.0, top: 5.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                // color: Cc.primaryColor,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                // color: Cc.black,
                width: 0.2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: "Enter ${config!.labelText}",
            counterStyle: TextStyle(
              color: Colors.transparent,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                // color: Cc.black,
                width: 1,
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minHeight: 32,
              minWidth: 32,
            ),
            prefixIcon: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Flag.fromCode(
                    FlagsCode.UG,
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "+256",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor!.withOpacity(.7),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: .5,
                    color: textColor,
                    height: 20,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),

            /*border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Cc.BG_FRONT,
                  width: 0.5,
                ),
              ),*/
            /*prefixIcon: IconTheme(
                data: IconThemeData(
                  color: Cc.deep_red,
                ),
                child: Icon(icon),
              ),*/
          ),
        ),
        config!.error != null
            ? Text(
                config!.error!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              )
            : SizedBox()
      ],
    );
  }
}
