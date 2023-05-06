import 'package:fancy_form_inputs/src/fancy_inputs_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FancyTextInput extends ConsumerWidget {
  dynamic validator;

  IconData? icon;

  String? hintText;
  String? labelText;
  TextEditingController? textController;
  TextInputType? keyboardType;
  String? errorsControllerTag;

  bool disabled = false;

  int? maxLength;
  bool maxLengthEnforced;

  int minLines;
  ValueChanged<String>? onChanged;
  String? errorText;
  List<TextInputFormatter>? inputFormatters = [];

  FancyInputConfig? config;
  void Function()? trigger;

  FancyTextInput({
    Key? key,
    this.validator,
    this.icon,
    this.hintText,
    this.labelText,
    this.textController,
    this.keyboardType,
    this.errorsControllerTag,
    this.disabled = false,
    this.maxLength = null,
    this.maxLengthEnforced = false,
    this.onChanged,
    this.errorText,
    this.minLines = 1,
    this.config,
    this.trigger,
    this.inputFormatters = null,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context, watch) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              config!.labelText!,
              style: TextStyle(),
            )),
        SizedBox(
          height: 5,
        ),
        /*disabled
            ? IgnorePointer(
                child: buildTextInput(),
              )
            : */

        buildTextInput(),
        // ,

        /*Text(
          errorController!.text,
          textAlign: TextAlign.left,
          style: Ts.robotoExtraSmall.copyWith(
            color: Cc.red,
            fontSize: 12,
          ),
        ),*/
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

  Widget buildTextInput() {
    return TextFormField(
      autocorrect: true,
      autofocus: false,
      enabled: !disabled,
      controller: config!.textEditingController,
      keyboardType: keyboardType,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: minLines,
      // maxLengthEnforced: maxLengthEnforced,
      style: TextStyle(
        fontSize: 15.5,
        color: Colors.black,
      ),
      onChanged: (value) {
        if (config != null) {
          config!.onValueChanged(value);
        }
        if (trigger != null) {
          trigger!();
        }
      },
      decoration: InputDecoration(
        // fillColor: Cc.BG_FRONT,
        filled: true,
        hintText: "Enter ${config!.labelText}",
        // errorText: errorText,
        // labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        counterStyle: TextStyle(color: Colors.transparent),
        // errorStyle: ,
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 5.0, top: 5.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            // color: Cc.BG_FRONT,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            // color: Cc.BG_FRONT,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            // color: Cc.BG_FRONT,
            width: 0.5,
          ),
        ),
        /*prefixIcon: IconTheme(
                data: IconThemeData(
                  color: Cc.deep_red,
                ),
                child: Icon(icon),
              ),*/
      ),
      inputFormatters: inputFormatters,
      textCapitalization: TextCapitalization.sentences,
      validator: validator,
    );
  }
}
